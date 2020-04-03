//
//  TopRoundedView.swift
//  Opentalk
//
//  Created by Chandan Karmakar on 16/09/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import UIKit

@IBDesignable
class UIViewExtended: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {}
    
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
    var topRounded: Bool = false {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let gradientColors = gradientColors {
            self.applyGradient(colours: gradientColors, horizontal: self.gradientHorizontal)
        }
        
        resolveCornerRadius()
        
    }
    
    func resolveCornerRadius() {
        if topRounded {
            let radi = cornerRadius == 0 ? 20 : cornerRadius
            roundCorners(corners: [.topLeft, .topRight], radius: radi)
            layer.cornerRadius = 0
        } else {
            if self.rounded { layer.cornerRadius = bounds.height / 2 }
            else { layer.cornerRadius = cornerRadius }
        }
    }
}

extension UIView {
    func applyGradient(colours: [UIColor]?, horizontal: Bool = false) {
        if let colours = colours {
            if horizontal {
                self.applyGradient(colours: colours, locations: nil, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
            } else {
                self.applyGradient(colours: colours, locations: nil, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
            }
        } else {
            self.layer.sublayers?.first(where: { $0.name == "gradient" })?.removeFromSuperlayer()
        }
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?, startPoint: CGPoint, endPoint: CGPoint) {
        let gradient: CAGradientLayer = self.layer.sublayers?.first(where: { $0.name == "gradient" }) as? CAGradientLayer ?? CAGradientLayer()
        gradient.name = "gradient"
        gradient.frame = self.bounds
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.cornerRadius = layer.cornerRadius
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

}
