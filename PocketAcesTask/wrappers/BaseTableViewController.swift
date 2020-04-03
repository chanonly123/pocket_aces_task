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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    
}
