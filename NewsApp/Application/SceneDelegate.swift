//
//  SceneDelegate.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 5.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
                            
        let darkModeEnabled = UserDefaults.standard.bool(forKey: "IsDarkMode")
            if darkModeEnabled {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .dark
                    }
                }
                
            } else {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .light
                    }
                }
            }
        
        let authManager = AuthenticationManager()
        if authManager.getUserFromUserDefaults() != nil {
            let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
            if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {
                window.rootViewController = tabBarController
            }
        } else {
            let storyboard = UIStoryboard(name: "OnboardingVC", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingVC") as? OnboardingVC {
                window.rootViewController = UINavigationController(rootViewController: vc)
            }
        }

        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

