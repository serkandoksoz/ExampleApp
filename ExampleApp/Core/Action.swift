//  Action.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 2.12.2024.
//

class ActionWith<T> {
    private let action: (T) -> Void
    
    init(action: @escaping (T) -> Void) {
        self.action = action
    }
    
    func callAsFunction(_ data: T) {
        action(data)
    }
    
    init(action: @escaping (T) async throws -> Void) {
        self.action = { data in
            Task { try await action(data) }
        }
    }
}

class Action {
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    init(action: @escaping () async throws -> Void) {
        self.action = { Task { try await action() } }
    }
    
    func callAsFunction() {
        action()
    }
}

extension Action {
    /// Creates an `Action` instance with an empty closure.
    ///
    /// - Returns: An `Action` instance that performs no action when invoked.
    static var empty: Action {
        Action(action: {})
    }
}

extension ActionWith {
    /// Creates an `ActionWith` instance with an empty closure.
    ///
    /// - Returns: An `ActionWith` instance that performs no action when invoked.
    static var empty: ActionWith<T> {
        ActionWith(action: { _ in })
    }
}

