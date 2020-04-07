//
//  CustomButtons.swift
//  eezylife-sample
//
//  Created by Chandan Karmakar on 14/03/20.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import UIKit

@IBDesignable
class UIButtonExtended: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        imageView?.contentMode = .scaleAspectFit
    }
    
    @IBInspectable
    var shadowLevel: CGFloat = 0.0 {
        didSet {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.3
            layer.shadowRadius = shadowLevel * 0.4
            layer.shadowOffset = CGSize(width: shadowLevel*0.2, height: shadowLevel*0.2)
        }
    }
    
    @IBInspectable
    var touchFeedback: Bool = false {
        didSet { /*enableTouchFeedback(enable: touchFeedback, touchHandler: nil)*/ }
    }
    
    @IBInspectable
    var gradientColors: [UIColor]? {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    var gradientHorizontal: Bool = false {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable
    var rounded: Bool = false {
        didSet { resolveCornerRadius() }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet { resolveCornerRadius() }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var rotation: CGFloat = 0 {
        didSet {
            imageView?.transform = .init(rotationAngle: rotation / 180.0 * CGFloat.pi)
        }
    }
    
    @IBInspectable
    var isIconAtRight: Bool = false {
        didSet {
            if isIconAtRight {
                transform = CGAffineTransform(scaleX: -1, y: 1)
                titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
            } else {
                transform = CGAffineTransform.identity
                titleLabel?.transform = CGAffineTransform.identity
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let gradientColors = gradientColors {
            self.applyGradient(colours: gradientColors, horizontal: self.gradientHorizontal)
        }
        
        resolveCornerRadius()
        
    }
    
    func resolveCornerRadius() {
        if self.rounded { layer.cornerRadius = bounds.height / 2 }
        else { layer.cornerRadius = cornerRadius }
    }
    
    var onClick:(()->Void)? {
        didSet {
            removeTarget(self, action: #selector(actionClick), for: .touchUpInside)
            if onClick != nil {
                addTarget(self, action: #selector(actionClick), for: .touchUpInside)
            }
        }
    }
    
    @objc func actionClick() {
        onClick?()
    }
    
}
