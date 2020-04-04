//
//  AppDelegate.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 03/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    static func getNavController() -> UINavigationController? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? UINavigationController
    }
}

class Storybaords {
    static var main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) 

}
