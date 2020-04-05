//
//  TabBarVC.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 05/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = viewControllers?.map({
            UINavigationController(rootViewController: $0)
        })
        
    }
}
