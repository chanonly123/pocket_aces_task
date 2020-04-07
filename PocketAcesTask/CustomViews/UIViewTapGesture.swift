//
//  GestureClosures.swift
//  Opentalk
//
//  Created by Chandan on 25/09/18.
//  Copyright © 2019 Opentalk. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

private var handlers = NSMapTable<UIView, AnyObject>(keyOptions: .weakMemory, valueOptions: .strongMemory)
private var recognizers = NSMapTable<UIView, UITapGestureRecognizer>(keyOptions: .weakMemory, valueOptions: .strongMemory)
private var recognizersShouldReceive = NSMapTable<UIView, AnyObject>(keyOptions: .weakMemory, valueOptions: .strongMemory)

extension UIView: UIGestureRecognizerDelegate {
    public func onTap(exclude: [AnyClass] = [], _ handler: @escaping ((_ sender: UITapGestureRecognizer) -> Void)) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTapClosure))
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)
        recognizers.setObject(tapGestureRecognizer, forKey: self)
        handlers.setObject(handler as AnyObject, forKey: self)
        recognizersShouldReceive.setObject(exclude as AnyObject, forKey: self)
    }
    
    @objc public func onTapClosure(sender: UITapGestureRecognizer) {
        if let handler = handlers.object(forKey: self) as? ((_ sender: UITapGestureRecognizer) -> Void) {
            handler(sender)
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer === recognizers.object(forKey: self) {
            if let exclude = recognizersShouldReceive.object(forKey: self) as? [AnyClass], let view = touch.view {
                for each in exclude {
                    let contains = view.isKind(of: each)
                    if contains {
                        return false
                    }
                }
            }
            return true
        }
        return true
    }
}
