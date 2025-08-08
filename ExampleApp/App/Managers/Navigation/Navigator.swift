//
//  Navigator.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 2.12.2024.
//

import Foundation
import UIKit
import SwiftUI

final class Navigator {
    
    init(window: UIWindow) {
        self.window = window
    }
    
    private(set) var window: UIWindow
    private var navigationController: UINavigationController? {
        // TODO: review - is this a good approach ? [using the tabbar structure that i copied from pdf converter; top view controller is not navigation but tabbar]
        topViewController as? UINavigationController ?? (topViewController as? UITabBarController)?.selectedViewController as? UINavigationController
    }
    private var topViewController: UIViewController? {
        var topController = window.rootViewController
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    
    func push<V: UIViewController>(_ viewController: V, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func present<V: UIViewController>(_ viewController: V, modalPresentationStyle: UIModalPresentationStyle? = nil) {
        if let modalPresentationStyle = modalPresentationStyle {
            viewController.modalPresentationStyle = modalPresentationStyle
        }
        topViewController?.present(viewController, animated: true)
    }
    
    func setRoot<V: UIViewController>(_ viewController: V, with transition: UIWindow.Transition? = nil) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        if let transition = transition {
            window.animate(transitionType: transition)
        }
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let navigationController {
            navigationController.popViewController(animated: animated)
        } else {
            topViewController?.dismiss(animated: animated, completion: completion)
        }
    }
    
    // MARK: View
    func setRoot<Content: View>(_ view: Content, with transition: UIWindow.Transition? = nil) {
        setRoot(HostingContainer(swiftUIView: view), with: transition)
    }
    
    func push<Content: View>(_ view: Content, animated: Bool = true) {
        push(HostingContainer(swiftUIView: view), animated: animated)
    }
    
    func present<Content: View>(_ view: Content, modalPresentationStyle: UIModalPresentationStyle? = nil) {
        present(HostingContainer(swiftUIView: view), modalPresentationStyle: modalPresentationStyle)
    }
    
    func presentAlertIfPossible(alert: UIAlertController, onPresent: Action? = nil) {
        // Check if the topmost view controller is already presenting an alert
        guard topViewController is UIAlertController else {
            self.present(alert)
            onPresent?()
            return
        }
    }
}
