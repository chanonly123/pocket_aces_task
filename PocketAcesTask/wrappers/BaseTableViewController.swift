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
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }

        if #available(iOS 13.0, *) {
            tableView.automaticallyAdjustsScrollIndicatorInsets = false
        }
        
        adjustScrollViewInsets(tableView)
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
        self.showLoadingFooter = false
    }
    
    // MARK: Next page loading footer
    var showLoadingFooter: Bool = false {
        didSet {
            if showLoadingFooter {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
                view.backgroundColor = .white
                let activity = UIActivityIndicatorView(style: .gray)
                activity.translatesAutoresizingMaskIntoConstraints = false
                activity.hidesWhenStopped = true
                activity.startAnimating()
                view.addSubview(activity)
                activity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                activity.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                tableView.tableFooterView = view
                tableView.sectionFooterHeight = 50
            } else {
                tableView.tableFooterView = UIView()
                tableView.sectionFooterHeight = 0
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustScrollViewInsets(tableView)
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
    
    let startPage: Int
    var pageCallIndex = 0
    var page: Int
    var items = [T]()
    var isGettingData = false
    
    init(startPage: Int) {
        self.startPage = startPage
        self.page = startPage
    }
    
    var returnPageData: ((Int, Int)->Void)?
    
    func getNextPage(fromStart: Bool) {
        if returnPageData == nil { return }
        if fromStart {
            if page == startPage && isGettingData {
                // do nothing
            } else {
                page = startPage
                isGettingData = false
            }
        }
        if isGettingData || page == -1 { return }
        pageCallIndex += 1
        isGettingData = true
        print("calling api, page: \(page)")
        returnPageData?(page, pageCallIndex)
    }
    
    func nextPageCompletion(success: Bool, nextItems: [T], callIndex: Int, thisPage: Int) {
        if callIndex != pageCallIndex { return }
        if page == startPage {
            items.removeAll()
        }
        if nextItems.isEmpty {
            if success {
                page = -1 // marks end of page
            }
        } else {
            page += 1
            items.append(contentsOf: nextItems)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isGettingData = false
        }
    }
}

