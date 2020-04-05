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
    
    let paginator = Paginator<ArticleEntry>(startPage: 1)
    
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myEnableAutoKeyboardObserver = true
        
        addPullToRefresh()
        addSearchBar()
        
        setNavRighButton(title: "Cancel")
        
        setupPaginator()
    }
    
    override func viewDidAppearFirstTime() {
        searchBar.becomeFirstResponder()
    }
    
    override func tapNavRight() {
        searchBar.resignFirstResponder()
    }
    
    func setupPaginator() {
        paginator.returnPageData = { [weak self] page, callIndex in
            guard let `self` = self else { return }
            
            self.emptyView.isHidden = true
            if self.paginator.items.isEmpty {
                self.activityIndicator.startAnimating()
            } else {
                self.showLoadingFooter = true
            }
            
            NewsApi.getSearchEverything(query: self.searchText, page: page) { [weak self] (res, data) in
                guard let `self` = self else { return }
                self.paginator.nextPageCompletion(success: res.succ,
                                                  nextItems: data?.articles ?? [],
                                                  callIndex: callIndex,
                                                  thisPage: page)
                self.endRefreshing()
                self.tableView.reloadData()
                
                self.emptyView.isHidden = !self.paginator.items.isEmpty
                self.emptyView.title = res.notReached ? R.string.noInternet : (data?.message ?? R.string.noResult)
            }
        }
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
    
    var searchIndex = 0
    override func searchTextChanged(searchText: String) {
        searchIndex += 1
        self.searchText = searchText.split(separator: " ").joined(separator: " ")
        if self.searchText.isEmpty { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [thisSearchIndex = searchIndex] in
            if self.searchIndex != thisSearchIndex { return }
            self.paginator.getNextPage(fromStart: true)
        }
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
            self?.getViewController()?.show(viewc, sender: nil)
        }
    }
    
    func reloadViews() {
        guard let article = article else { return }
        lblTitle.text = article.title
        ivImage.setNewsPic(url: article.urlToImage)
    }
    
}
