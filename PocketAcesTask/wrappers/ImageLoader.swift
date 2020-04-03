//
//  ImageLoader.swift
//  GoContacts
//
//  Created by Chandan Karmakar on 27/11/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import Kingfisher

class ImageLoader {
    static func setUserImage(_ imageView: UIImageView, _ url: String?) {
        let placeholder = #imageLiteral(resourceName: "ic_placeholder_photo")
        if let url = url {
            if let url_ = URL(string: "\(Apis.base)\(url)") {
                imageView.kf.setImage(with: url_, placeholder: placeholder, options: [.transition(.fade(0.2))])
                return
            }
        }
        imageView.image = placeholder
    }
}
