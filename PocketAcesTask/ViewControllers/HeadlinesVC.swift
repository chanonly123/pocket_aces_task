//
//  ViewController.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 03/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class HeadlinesVC: BaseTableViewController {
    
    let paginator = Paginator<ArticleEntry>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPullToRefresh()
        
        paginator.returnPageData = { [weak self] page, callIndex in
            guard let `self` = self else { return }
            
            if self.paginator.items.isEmpty {
                self.activityIndicator.startAnimating()
            }
            
            NewsApi.getTopHeadline(page: page) { (res, data) in
                self.paginator.nextPageCompletion(success: res.succ, nextItems: data?.articles ?? [], callIndex: callIndex)
                self.endRefreshing()
                self.tableView.reloadData()
            }
        }
        
        paginator.getNextPage(fromStart: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paginator.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: NewsCell.self)
        cell.article = paginator.items[indexPath.row]
        cell.reloadViews()
        return cell
    }
    
    override func didScrollToBottom() {
        paginator.getNextPage(fromStart: false)
    }
    
    override func onPullRefresh() {
        paginator.getNextPage(fromStart: true)
    }
}

class NewsCell: BaseTableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet var expandHandle: NSLayoutConstraint!
 
    var article: ArticleEntry?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.onTap() { [weak self] _ in
            guard let article = self?.article else { return }
            article.expanded = !article.expanded
            self?.toggle(expand: article.expanded, animated: true)
        }
    }
    
    func reloadViews() {
        guard let article = article else { return }
        lblTitle.text = article.title
        lblDesc.text = article.description
        ivImage.setNewsPic(url: article.urlToImage)
        
        article.expanded = !article.expanded
        toggle(expand: article.expanded, animated: false)
    }
    
    @IBAction func actionFullStory() {
        let viewc = FullNewsVC.instantiate()
        viewc.article = article
        AppDelegate.getNavController()?.present(viewc, animated: true)
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
