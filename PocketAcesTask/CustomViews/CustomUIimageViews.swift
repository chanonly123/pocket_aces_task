//
//  UIImageViewExtended.swift
//  Dev
//
//  Created by Chandan Karmakar on 18/09/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import UIKit

@IBDesignable
public class UIImageViewExtended: UIImageView {
    
    @IBInspectable
    var touchFeedback: Bool = false {
        didSet {
            /*enableTouchFeedback(enable: touchFeedback, touchHandler: { down, view in
                UIView.animate(withDuration: 0.2) {
                    view.alpha = down ? 0.5 : 1.0
                    view.transform = down ? CGAffineTransform(scaleX: 0.8, y: 0.8) : .identity
                }
            })*/
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    
    @IBInspectable
    var borderColor: UIColor = .white {
        didSet { layer.borderColor = borderColor.cgColor }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.addMaskToBounds(maskBounds: self.frame)
        layer.cornerRadius = bounds.size.height / 2
    }
    
    private func addMaskToBounds(maskBounds: CGRect) {
        let maskLayer = CAShapeLayer()
        let maskPath = CGPath(ellipseIn: maskBounds, transform: nil)
        maskLayer.bounds = maskBounds
        maskLayer.path = maskPath
        maskLayer.fillColor = UIColor.black.cgColor
        let point = CGPoint(x: maskBounds.size.width / 2, y: maskBounds.size.height / 2)
        maskLayer.position = point
        self.layer.mask = maskLayer
    }
}
