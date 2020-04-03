//
//  UIButton.swift
//  Opentalk
//
//  Created by Chandan Karmakar on 17/09/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import UIKit

public extension UIButton {
    var title: String? {
        get {
            return self.title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
            setTitle(newValue, for: .highlighted)
            setTitle(newValue, for: .selected)
            setTitle(newValue, for: .disabled)
            setTitle(newValue, for: .focused)
        }
    }
    
    var attrTitle: NSAttributedString {
        get {
            return self.attributedTitle(for: .normal) ?? NSAttributedString()
        }
        set {
            setAttributedTitle(newValue, for: .normal)
            setAttributedTitle(newValue, for: .normal)
            setAttributedTitle(newValue, for: .highlighted)
            setAttributedTitle(newValue, for: .selected)
            setAttributedTitle(newValue, for: .disabled)
            setAttributedTitle(newValue, for: .focused)
        }
    }
    
    var titleColor: UIColor? {
        get {
            return self.titleColor(for: .normal)
        }
        set {
            setTitleColor(newValue, for: .normal)
            setTitleColor(newValue, for: .highlighted)
            setTitleColor(newValue, for: .selected)
            setTitleColor(newValue, for: .disabled)
            setTitleColor(newValue, for: .focused)
        }
    }
    
    var image: UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
            setImage(newValue, for: .selected)
            setImage(newValue, for: .highlighted)
            setImage(newValue, for: .disabled)
            setImage(newValue, for: .focused)
        }
    }
    
    var backgroundImage: UIImage? {
        get {
            return backgroundImage(for: .normal)
        }
        set {
            setBackgroundImage(newValue, for: .normal)
            setBackgroundImage(newValue, for: .selected)
            setBackgroundImage(newValue, for: .highlighted)
            setBackgroundImage(newValue, for: .disabled)
            setBackgroundImage(newValue, for: .focused)
        }
    }
    
}
