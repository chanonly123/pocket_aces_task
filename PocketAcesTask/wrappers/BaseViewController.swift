//
//  UICustomVC.swift
//  Opentalk
//
//  Created by Chandan Karmakar on 16/09/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import UIKit
import AutoKeyboard

class BaseViewController: UIViewController {
        
    var viewCenterOffset: CGFloat = 0
    
    var isProgress = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = isProgress
            view.alpha = isProgress ? 0.8 : 1.0
            view.isUserInteractionEnabled = !isProgress
        }
    }
    
    var isVisible: Bool = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        myStatusBarStyleLight = true
        
        activityIndicator.stopAnimating()
                
        activityIndicator.stopAnimating()
        emptyView.msg = ""
    }
    
    @objc func tapBack() {
        if let nav = navigationController {
            if nav.viewControllers.count > 1 {
                nav.popViewController(animated: true)
            } else {
                nav.dismiss(animated: true, completion: nil)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = true
    }
    
    // MARK: Auto keyboard oberverver
    var myEnableAutoKeyboardObserver = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if myEnableAutoKeyboardObserver {
            registerAutoKeyboard()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isVisible = false
        if myEnableAutoKeyboardObserver {
            unRegisterAutoKeyboard()
        }
    }
    
    // MARK: status bar style override
    var myStatusBarStyleLight: Bool? {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }
    static var myStatusBarStyleLightGlobal: Bool?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let global = BaseViewController.myStatusBarStyleLightGlobal {
            return global ? UIStatusBarStyle.lightContent : UIStatusBarStyle.default
        }
        if let light = myStatusBarStyleLight {
            return light ? UIStatusBarStyle.lightContent : UIStatusBarStyle.default
        }
        return super.preferredStatusBarStyle
    }
    
    // MARK: Instantiate from Storyboard
    class var fromStoryboard: UIStoryboard? { return nil }
    
    class func instantiate() -> Self {
        return instantiateType(type: self)!
    }
    
    class func instantiateType<T: BaseViewController>(type: T.Type) -> T? {
        if let fromStoryboard = fromStoryboard {
            let storyboardId = String(describing: self)
            return fromStoryboard.instantiateViewController(withIdentifier: storyboardId) as? T
        }
        return nil
    }
    
    // MARK: adding activityIndicator
    private var _activityIndicator: UIActivityIndicatorView!
    var activityIndicator: UIActivityIndicatorView {
        if let act = _activityIndicator { return act } else {
            _activityIndicator = UIActivityIndicatorView(style: .gray)
            _activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            _activityIndicator.hidesWhenStopped = true
            view.addSubview(_activityIndicator)
            _activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            _activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: viewCenterOffset).isActive = true
            return _activityIndicator
        }
    }
    
    // MARK: adding empty view
    private var _emptyView: EmptyView!
    var emptyView: EmptyView {
        if let emptyView = _emptyView { return emptyView } else {
            _emptyView = EmptyView()
            view.addSubview(_emptyView!)
            _emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            _emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: viewCenterOffset).isActive = true
            _emptyView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32).isActive = true
            _emptyView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32).isActive = true
            _emptyView.isHidden = true
            return _emptyView!
        }
    }
    
    // MARK: Replacing nav bar buttons
    func setNavRighButton(title: String) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(tapNavRight))
    }
    
    func setNavRighButton(image: UIImage) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(tapNavRight))
    }
    
    func setNavLeftButton(title: String) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(tapNavLeft))
    }
    
    // can override
    @objc func tapNavRight() {  }
    
    // can override
    @objc func tapNavLeft() {  }
    
    // MARK: deinit
    deinit {
        print("======= deinit \(String(describing: self))")
    }

    
}
