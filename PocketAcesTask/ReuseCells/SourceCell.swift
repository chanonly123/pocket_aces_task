//
//  HeadlineCell.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 05/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class SourceCell: BaseTableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet var expandHandle: NSLayoutConstraint!
 
    var source: SourceEntry?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.onTap(exclude: [UIControl.self]) { [weak self] _ in
            guard let source = self?.source else { return }
            let viewc = HeadlinesVC.instantiate()
            viewc.input = .source(source)
            self?.getViewController()?.show(viewc, sender: nil)
        }
    }
    
    func reloadViews() {
        guard let article = source else { return }
        lblTitle.text = article.name
        lblDesc.text = article.description
    }
    
}
