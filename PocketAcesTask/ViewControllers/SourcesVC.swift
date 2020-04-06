//
//  SourcesVC.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 05/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class SourcesVC: BaseTableViewController {
    override class var fromStoryboard: UIStoryboard? { return Storybaords.main }
    
    var items = [SourceEntry]()
    var inputCountry = CountryEntry.createMyCountry() {
        didSet {
            if tableView != nil {
                tableView.contentOffset.y = -tableView.contentInset.top
                getSources()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(nibType: SourceCell.self)
        addPullToRefresh()
        
        getSources()
    }
    
    func getSources() {
        self.emptyView.isHidden = true
        if self.items.isEmpty {
            self.activityIndicator.startAnimating()
        } else {
            self.showLoadingFooter = true
        }
        
        NewsApi.getAllSources(country: self.inputCountry) { [weak self] (res, data) in
            guard let `self` = self else { return }
            self.items = data?.sources ?? []
            self.endRefreshing()
            self.tableView.reloadData()
            self.emptyView.isHidden = !self.items.isEmpty
            self.emptyView.title = res.notReached ? R.string.noInternet : (data?.message ?? R.string.noResult)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: SourceCell.self)
        cell.source = items[indexPath.row]
        cell.reloadViews()
        return cell
    }
    
    override func onPullRefresh() {
        getSources()
    }
}

