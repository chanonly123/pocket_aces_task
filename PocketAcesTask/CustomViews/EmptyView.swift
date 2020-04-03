//
//  EmptyView.swift
//  Dev
//
//  Created by Chandan Karmakar on 20/09/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import UIKit

@IBDesignable
class EmptyView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        alignment = .center
        spacing = 8
        
        title = nil
        msg = nil
        btnTitle = nil
    }
    
    var title: String? {
        didSet {
            if lblTitle.superview == nil {
                addArrangedSubview(lblTitle)
            }
            lblTitle.text = title
            lblTitle.isHidden = title == nil
        }
    }
    
    var msg: String? {
        didSet {
            if lblMsg.superview == nil {
                addArrangedSubview(lblMsg)
            }
            lblMsg.text = msg
            lblMsg.isHidden = msg == nil
        }
    }
    
    var btnTitle: String? {
        didSet {
            if btn.superview == nil {
                addArrangedSubview(btn)
                btn.addTarget(self, action: #selector(actionBtn), for: .touchUpInside)
            }
            btn.title = btnTitle
            btn.isHidden = btnTitle == nil
        }
    }
    
    var btnHandler: (()->Void)?
    
    private lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "This is title"
        lbl.textColor = .black
        return lbl
    }()
    
    private lazy var lblMsg: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .darkGray
        lbl.text = "This is message"
        return lbl
    }()
    
    private lazy var btn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleColor = .white
        btn.title = "Retry"
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return btn
    }()
    
    @objc func actionBtn() {
        btnHandler?()
    }
    
}
