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
    
    func getViewController() -> UIViewController? {
        var nextResponder = next
        while nextResponder != nil && !(nextResponder is UIViewController) {
            nextResponder = nextResponder?.next
        }
        return nextResponder as? UIViewController
    }
    
    // MARK: touch feedback
    func enableTouchFeedback(enable: Bool, touchHandler: ((Bool, UIView)->Void)?) {
        if !enable {
            savedTouchHandlers.removeObject(forKey: self)
            gestureRecognizers?.removeAll(where: { $0 is TouchGestureRecognizer })
            return
        }
        savedTouchHandlers.setObject(touchHandler as AnyObject, forKey: self)
        if gestureRecognizers?.first(where: { $0 is TouchGestureRecognizer }) == nil {
            let touch = TouchGestureRecognizer(target: self, action: #selector(onTouch(gesture:)))
            touch.cancelsTouchesInView = false
            addGestureRecognizer(touch)
        }
    }
    
    @objc func onTouch(gesture: UIGestureRecognizer) {
        let down = gesture.state == .began || gesture.state == .changed
        if let handler = savedTouchHandlers.object(forKey: self) as? ((Bool, UIView)->Void) {
            handler(down, self)
        } else {
            let transform = down ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
            if down {
                UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [.allowUserInteraction], animations: {
                    self.transform = transform
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {
                    self.transform = transform
                })
            }
        }
    }
}

fileprivate var savedTouchHandlers = NSMapTable<UIView, AnyObject>(keyOptions: .weakMemory, valueOptions: .strongMemory)

fileprivate class TouchGestureRecognizer: UIGestureRecognizer, UIGestureRecognizerDelegate {
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .began
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .changed
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .ended
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .cancelled
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(otherGestureRecognizer is TouchGestureRecognizer)
    }
    
}
