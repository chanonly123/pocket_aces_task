//
//  UIView.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 04/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

extension UIView {
    func setLoading(_ enable: Bool) {
        let width: Double = 0.15
        clipsToBounds = true
        let layerName = "loading_layer"
        let layerAnimName = "loading_layer_anim"
        if enable {
            if layer.sublayers?.first(where: { $0.name == layerName }) != nil { return }
            let colors: [UIColor] = [UIColor(white: 0.92, alpha: 1), UIColor(white: 0.95, alpha: 1), UIColor(white: 0.92, alpha: 1)]
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.name = layerName
            gradient.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width * 3, height: bounds.height)
            gradient.locations = [0, NSNumber(value: width), NSNumber(value: width * 2)]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 0)
            gradient.cornerRadius = layer.cornerRadius
            gradient.colors = colors.map { $0.cgColor }
            
            let anim = (gradient.animation(forKey: layerAnimName) as? CABasicAnimation) ?? CABasicAnimation(keyPath: "locations")
            anim.fromValue = [0, NSNumber(value: width), NSNumber(value: width * 2)]
            anim.toValue = [NSNumber(value: 1 - width * 2), NSNumber(value: 1 - width), 1]
            anim.duration = 0.8
            anim.fillMode = CAMediaTimingFillMode.forwards
            anim.isRemovedOnCompletion = false
            anim.repeatCount = Float.greatestFiniteMagnitude
            gradient.add(anim, forKey: layerAnimName)
            layer.addSublayer(gradient)
        } else {
            layer.sublayers?.first(where: { $0.name == layerName })?.removeFromSuperlayer()
        }
    }
}
