//
//  Observer.swift
//  Dev
//
//  Created by Chandan Karmakar on 15/10/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import Foundation

fileprivate let rTargets = NSMapTable<AnyObject, AnyObject>(keyOptions: .weakMemory,
                                                            valueOptions: .strongMemory)

protocol Observable: class {}

extension Observable {
    func registerChange(_ target: AnyObject, handler: @escaping ((Self)->Void)) {
        var objectsMap: NSMapTable<AnyObject, AnyObject>!
        if let objects = rTargets.object(forKey: target) as? NSMapTable<AnyObject, AnyObject> {
            objectsMap = objects
        } else {
            objectsMap = NSMapTable<AnyObject, AnyObject>(keyOptions: .weakMemory, valueOptions: .strongMemory)
            rTargets.setObject(objectsMap, forKey: target)
        }
        objectsMap.setObject(handler as AnyObject, forKey: self)
    }
    
    func removeChange(_ target: AnyObject) {
        rTargets.removeObject(forKey: target)
    }
    
    func notify() {
        let targets = rTargets.keyEnumerator().allObjects
        targets.forEach {
            if let objectsMap = rTargets.object(forKey: $0 as AnyObject) as? NSMapTable<AnyObject, AnyObject> {
                if let handler = objectsMap.object(forKey: self as AnyObject) as? ((Self)->Void) {
                    handler(self)
                }
            }
        }
    }
}
