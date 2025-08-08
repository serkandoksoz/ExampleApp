//
//  AppCoordinator.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 2.12.2024.
//

import Foundation
import UIKit
import Combine
import SwiftUI

@MainActor
final class AppCoordinator: NSObject, UITabBarControllerDelegate {
    
    private let navigator: Navigator
    private let logger = AppLogger(category: "AppCoordinator")
    
    
    init(navigator: Navigator) {
        self.navigator = navigator
        
        super.init()
        SplashScreen.handle(with: handle(route:))
    }
    
    func start() {
        Task {
            do {
                await LocalizationManager.shared.loadLocalizations()
                SplashScreen().navigate()
            }
        }
    }

    private func handle(route: SplashScreen) {
        let splashView = SplashView(viewModel: .init())
        let navigationController = UINavigationController(rootViewController: UIHostingController(rootView: splashView))
        navigationController.hidesBottomBarWhenPushed = true
        navigationController.isNavigationBarHidden = true
        navigator.setRoot(navigationController)
    }
    
}

// MARK: - Alerts
extension AppCoordinator {
    private func handle(route: GenericErrorAlert) {
        let alertController = UIAlertController(
            title: route.title,
            message: route.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: String(localized: "Ok"),
            style: .default,
            handler: nil
        )
        
        alertController.addAction(action)
        navigator.present(alertController)
    }
}

// MARK: - Toaster
extension AppCoordinator {
    private func handle(route: ToasterAlert) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        if let existingToast = window.subviews.first(where: { $0.tag == 999 }) {
            existingToast.removeFromSuperview()
        }
        
        let toastView = ToasterProvider().makeUIViewController(message: route.message, type: route.type)
        toastView.tag = 999
        toastView.alpha = 0
        
        window.addSubview(toastView)
        
        NSLayoutConstraint.activate([
            // Center horizontally
            toastView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            // Position from top
            toastView.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 52)
        ])
        
        UIView.animate(withDuration: 0.3, animations: {
            toastView.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                UIView.animate(withDuration: 0.3, animations: {
                    toastView.alpha = 0
                }) { _ in
                    toastView.removeFromSuperview()
                }
            }
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension AppCoordinator {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            logger.debug("Tab bar selected index: \(index)")
        }
    }
}
