//
//  BaseTableViewController.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 03/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class BaseTableViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    // MARK: Overrideable methods
    func didScrollToBottom() { }
    func onPullRefresh() { }
    
    // MARK: Pull to refresh
    func addPullToRefresh() {
        tableView?.refreshControl = refreshControl
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            onPullRefresh()
        }
    }
    
    func endRefreshing() {
        activityIndicator.stopAnimating()
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}

extension BaseTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension BaseTableViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let flag = scrollView.contentOffset.y + scrollView.contentInset.top
        if flag > 0 {
            if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - 400 {
                didScrollToBottom()
            }
        }
    }
}

class Paginator<T> {
    
    var pageCallIndex = 0
    var page = 0
    var items = [T]()
    var isGettingData = false
    
    var returnPageData: ((Int, Int)->Void) = { _, _ in
        assertionFailure("Please define this")
    }
    
    func getNextPage(fromStart: Bool) {
        if fromStart {
            if page == 0 && isGettingData {
                // do nothing
            } else {
                page = 0
                isGettingData = false
            }
        }
        if isGettingData || page == -1 { return }
        pageCallIndex += 1
        isGettingData = true
        print("calling api, page: \(page)")
        returnPageData(page, pageCallIndex)
    }
    
    func nextPageCompletion(success: Bool, nextItems: [T], callIndex: Int) {
        if callIndex != pageCallIndex { return }
        if nextItems.isEmpty {
            page = -1 // marks end of page
        } else {
            page += 1
            items.append(contentsOf: nextItems)
        }
        isGettingData = false
    }
}

