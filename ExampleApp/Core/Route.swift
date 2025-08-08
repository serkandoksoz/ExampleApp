//  Route.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 2.12.2024.
//

import Foundation
import OSLog

private let router = Router()

/// Protocol to define a routable component in the application.
protocol Route {}

// MARK: - Route Extensions
extension Route {
    /// Triggers navigation to the route defined by the conforming type.
    func navigate() {
        router.follow(route: self)
    }
    
    /// Registers a handler for a specific route type. The handler is called when navigating to the route.
    /// - Parameter handler: An asynchronous closure that handles the route. It accepts an instance of the route type.
    @MainActor
    static func handle(with handler: @escaping (Self) async -> Void) {
        router.register(handler: handler)
    }
}

extension Route {
    var navigationAction: Action {
        Action {
            self.navigate()
        }
    }
}

/// A private router class responsible for managing and dispatching route handlers.
private final class Router {
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Routing")
    
    /// Maps route types to their corresponding handling closures.
    private var handlers: [ObjectIdentifier: (any Route) async -> Void] = [:]
    
    /// Registers a handling closure for a specific route type.
    /// - Parameters:
    ///   - handler: The closure that handles the route.
    @MainActor
    func register<R: Route>(handler: @escaping (R) async -> Void) {
        let id = ObjectIdentifier(R.self)
        
        if handlers[id] != nil {
            logger.warning("Overwriting an existing handler for route: \(String(describing: R.self))")
        }
        
        handlers[id] = { route in
            guard let route = route as? R else {
                return
            }
            await handler(route)
        }
    }
    
    // MARK: Navigation Methods
    /// Follows a route by invoking its registered handler.
    /// - Parameter route: The route to follow.
    func follow<R: Route>(route: R) {
        Task { @MainActor in
            let routeIdentifier = ObjectIdentifier(R.self)
            guard let handler = handlers[routeIdentifier] else {
                logger.error("No handler registered for route: \(String(describing: R.self))")
                return
            }
            logger.log("Handling route: \(String(describing: R.self)), Date: \(Date())")
            await handler(route)
        }
    }
}
