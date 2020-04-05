//
//  HeadlineCell.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 05/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class HeadlineCell: BaseTableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet var expandHandle: NSLayoutConstraint!
 
    var article: ArticleEntry?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.onTap(exclude: [UIControl.self]) { [weak self] _ in
            guard let article = self?.article else { return }
            article.expanded = !article.expanded
            self?.toggle(expand: article.expanded, animated: true)
        }
    }
    
    func reloadViews() {
        guard let article = article else { return }
        lblTitle.text = article.title
        lblDesc.text = article.description
        if let source = article.source?.name {
            lblDesc.text = lblDesc.text?.appending("\n\nSource: \(source)")
        }
        ivImage.setNewsPic(url: article.urlToImage)
        toggle(expand: article.expanded, animated: false)
    }
    
    @IBAction func actionFullStory() {
        let viewc = FullNewsVC.instantiate()
        viewc.article = article
        getViewController()?.show(viewc, sender: nil)
    }
    
    func toggle(expand: Bool, animated: Bool) {
        if animated {
            if expand {
                lblDesc.alpha = 0
                expandHandle.isActive = expand
                updateCellHeight()
                UIView.animate(withDuration: 0.3) {
                    self.lblDesc.alpha = 1
                }
            } else {
                self.expandHandle.isActive = expand
                UIView.animate(withDuration: 0.3, animations: {
                    self.lblDesc.alpha = 0
                    self.layoutIfNeeded()
                }) { _ in
                    self.updateCellHeight()
                }
            }
        } else {
            lblDesc.alpha = expand ? 1 : 0
            expandHandle.isActive = expand
        }
    }
}
