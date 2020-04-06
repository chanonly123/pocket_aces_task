//
//  ViewController.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 03/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class HeadlinesVC: BaseTableViewController {
    override class var fromStoryboard: UIStoryboard? { return Storybaords.main }
    
    let paginator = Paginator<ArticleEntry>(startPage: 1)
    
    var input = HeadlineNewsInput.country(CountryEntry.createMyCountry()) {
        didSet {
            if tableView != nil {
                tableView.contentOffset.y = -tableView.contentInset.top
                paginator.getNextPage(fromStart: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch input {
        case .country(_):
            title = "Headlines"
        case .source(let source):
            title = source.name ?? ""
        }
        
        
        tableView.register(nibType: HeadlineCell.self)
        addPullToRefresh()
        
        paginator.returnPageData = { [weak self] page, callIndex in
            guard let `self` = self else { return }
            
            self.emptyView.isHidden = true
            if self.paginator.items.isEmpty {
                self.activityIndicator.startAnimating()
            } else {
                self.showLoadingFooter = true
            }
            
            NewsApi.getTopHeadline(page: page, input: self.input) { [weak self] (res, data) in
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
        
        paginator.getNextPage(fromStart: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paginator.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: HeadlineCell.self)
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

enum HeadlineNewsInput {
    case country(CountryEntry)
    case source(SourceEntry)
}
