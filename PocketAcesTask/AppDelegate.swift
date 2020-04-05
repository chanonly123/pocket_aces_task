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
        
        let uRLCache = URLCache(memoryCapacity: 500 * 1024 * 1024, diskCapacity: 500 * 1024 * 1024, diskPath: nil)
        URLCache.shared = uRLCache
        
        return true
    }
}

class Storybaords {
    static var main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) 

}

fileprivate var randomHeroId: Int = 0
var getRandomHeroId: String {
    randomHeroId += 1
    return String(randomHeroId)
}
