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
    
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    var article: ArticleEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadViews()
    }
    
    func reloadViews() {
        guard let article = article else { return }
        lblTitle.text = article.title
        lblDesc.text = article.content
        ivImage.setNewsPic(url: article.urlToImage)
    }
}
