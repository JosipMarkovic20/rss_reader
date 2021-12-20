//
//  AppDelegate.swift
//  RSS Reader
//
//  Created by Josip Marković on 20.12.2021..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else {return false}
        self.appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        return true
    }

}

