//
//  UIImageView.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 04/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setNewsPic(url: String?) {
        tag += 1
        if let url = url, let url_ = URL(string: url) {
            image = nil
            setLoading(true)
            //let processor = ResizingImageProcessor(referenceSize: bounds.size)  .processor(processor) // crashing
            kf.setImage(with: url_, placeholder: nil, options: [.transition(.fade(0.2))]) {
                [weak self, thisTag = tag] result in
                if self?.tag != thisTag { return }
                switch result {
                case .failure( _): self?.image = nil
                //case .success(let value): printc("size: \(value.image.size)")
                default: break
                }
                self?.setLoading(false)
            }
        } else {
            image = nil
        }
    }
}
