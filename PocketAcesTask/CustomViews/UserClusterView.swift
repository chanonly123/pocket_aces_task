//
//  UserClusterView.swift
//  eezylife-sample
//
//  Created by Chandan Karmakar on 15/03/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

@IBDesignable
class UserClusterView: UIViewExtended {
    
    lazy var width: NSLayoutConstraint = {
        let w = self.widthAnchor.constraint(equalToConstant: self.bounds.height)
        w.isActive = true
        return w
    }()
    
    @IBInspectable
    var hideRatio: CGFloat = 0.8 {
        didSet {
            repositionViews()
        }
    }
    
    @IBInspectable
    var testCount: Int = 3
    
    var users: [Int] = []
    
    private var isInterfaceBuilder = false
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        isInterfaceBuilder = true
        for _ in 0..<testCount {
            let iv = UIImageViewExtended(frame: .zero)
            iv.contentMode = .scaleAspectFill
            iv.backgroundColor = .lightGray
            addSubview(iv)
        }
        repositionViews()
    }
    
    func reloadViews() {
        subviews.forEach { $0.removeFromSuperview() }
        users.forEach { _ in
            let iv = UIImageViewExtended(frame: .zero)
            iv.contentMode = .scaleAspectFill
            iv.backgroundColor = .lightGray
            iv.image = randomImage
            addSubview(iv)
        }
        repositionViews()
    }
    
    func repositionViews() {
        let count = isInterfaceBuilder ? testCount : users.count
        if count > 1 {
            width.constant = bounds.height + bounds.height * CGFloat(count - 1) * hideRatio
        } else {
            width.constant = bounds.height
        }
        var i: CGFloat = 0
        subviews.forEach {
            $0.frame = CGRect(x: bounds.height * i * hideRatio, y: 0, width: bounds.height, height: bounds.height)
            i += 1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        repositionViews()
    }

}

var randomImage: UIImage? {
    let name = "ic_person\(Int.random(in: 1...4))"
    return UIImage(named: name)
}
