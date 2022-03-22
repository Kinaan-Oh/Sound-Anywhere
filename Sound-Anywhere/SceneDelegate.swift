//
//  SceneDelegate.swift
//  Sound-Anywhere
//
//  Created by 오현식 on 2022/03/21.
//

import UIKit
import Resource

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        configureWindow(windowScene)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

    // MARK: - Private Methods
    
    private func configureWindow(_ windowScene: UIWindowScene) {
        let mainTabBarViewController = Resource.Storyboard.main.instance()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = mainTabBarViewController
        window?.makeKeyAndVisible()
    }
}
