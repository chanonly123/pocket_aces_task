//
//  TopRoundedView.swift
//  eezylife-sample
//
//  Created by Chandan Karmakar on 14/03/20.
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
    
    func commonInit() { }
    
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
        didSet { enableTouchFeedback(enable: touchFeedback, touchHandler: nil) }
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
    var cornerSides: Int = 0 {
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
        if self.rounded {
            layer.cornerRadius = bounds.height / 2
        }
        else {
            if cornerSides > 0 {
                var arr: UIRectCorner = []
                if cornerSides & 1 > 0 {
                    arr.insert(.topLeft)
                }
                if cornerSides & 2 > 0 {
                    arr.insert(.topRight)
                }
                if cornerSides & 4 > 0 {
                    arr.insert(.bottomRight)
                }
                if cornerSides & 8 > 0 {
                    arr.insert(.bottomLeft)
                }
                roundCorners(corners: arr, radius: cornerRadius)
                layer.cornerRadius = 0
            } else {
                layer.cornerRadius = cornerRadius
            }
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

@IBDesignable
class UIViewXib: UIViewExtended {
    weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func commonInit() {
        super.commonInit()
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView = view
        let height = view.heightAnchor.constraint(equalToConstant: 50)
        height.priority = UILayoutPriority(rawValue: 10)
        height.isActive = true
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
