//
//  FullNewsVC.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 04/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class FullNewsVC: BaseViewController, UIScrollViewDelegate {
    override class var fromStoryboard: UIStoryboard? { return Storybaords.main }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    var article: ArticleEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        adjustScrollViewInsets(scrollView)
        reloadViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustScrollViewInsets(scrollView)
    }
    
    func reloadViews() {
        guard let article = article else { return }
        lblTitle.text = article.title
        lblDesc.text = article.content
        if let source = article.source?.name {
            lblDesc.text = lblDesc.text?.appending("\n\nSource: \(source)")
        }
        ivImage.setNewsPic(url: article.urlToImage)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let superview = scrollView.superview {
            let vel = scrollView.panGestureRecognizer.velocity(in: superview)
            var i = 0.0
            scrollView.subviews.first?.subviews.forEach { each in
                UIView.animate(withDuration: 0.8, delay: i, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
                    each.transform = vel.y != 0 ? CGAffineTransform(translationX: 0, y: -vel.y * 0.025) : CGAffineTransform.identity
                }, completion: nil)
                i += 0.03
            }
        }
    }
}
