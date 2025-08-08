//
//  SceneDelegate.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 17.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var navigator: Navigator!
    var appCoordinator: AppCoordinator?
    let logger = AppLogger(category: "SceneDelegate")
    
    override init() {
        super.init()
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        window.overrideUserInterfaceStyle = .light
        self.window = window
        navigator = Navigator(window: window)
        setupCoordinators()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
    
}

extension SceneDelegate {
    private func setupCoordinators() {
        appCoordinator = AppCoordinator(navigator: navigator)
        appCoordinator?.start()
    }
}

