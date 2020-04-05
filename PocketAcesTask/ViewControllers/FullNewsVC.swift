//
//  FullNewsVC.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 04/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class FullNewsVC: BaseViewController {
    override class var fromStoryboard: UIStoryboard? { return Storybaords.main }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    var article: ArticleEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
