//
//  SearchVC.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 04/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class SearchNewsVC: BaseTableViewController {
    override class var fromStoryboard: UIStoryboard? { return Storybaords.main }
    
    let paginator = Paginator<ArticleEntry>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPullToRefresh()
        addSearchBar()
        
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
        let cell = tableView.dequeueReusableCell(type: SearchNewsCell.self)
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
    
    override func searchTextChanged(searchText: String) {
        
    }
}

class SearchNewsCell: BaseTableViewCell {
   
   @IBOutlet weak var cardView: UIView!
   @IBOutlet weak var ivImage: UIImageView!
   @IBOutlet weak var lblTitle: UILabel!

   var article: ArticleEntry?
   
   override func awakeFromNib() {
       super.awakeFromNib()
       cardView.onTap() { [weak self] _ in
            let viewc = FullNewsVC.instantiate()
            viewc.article = self?.article
            AppDelegate.getNavController()?.present(viewc, animated: true)
       }
   }
   
   func reloadViews() {
       guard let article = article else { return }
       lblTitle.text = article.title
       ivImage.setNewsPic(url: article.urlToImage)
   }
    
}
