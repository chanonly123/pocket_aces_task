//
//  UIImageViewExtended.swift
//  Dev
//
//  Created by Chandan Karmakar on 18/09/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import UIKit

@IBDesignable
class UIImageViewExtended: UIImageView {
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    
    @IBInspectable
    var borderColor: UIColor = .white {
        didSet { layer.borderColor = borderColor.cgColor }
    }
    
    override func layoutSubviews() {
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
