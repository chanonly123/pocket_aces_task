//
//  UITableView.swift
//  Dev
//
//  Created by Chandan Karmakar on 20/09/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(type: T.Type) -> T? {
        let identifier = String(describing: type)
        if let reusableCell = self.dequeueReusableCell(withIdentifier: identifier) {
            if let cell = reusableCell as? T {
                return cell
            } else {
                //printc("tableview cell cannot be casted: \(identifier)")
            }
        } else {
            //printc("tableview cell not found: \(identifier)")
        }
        guard let tableViewCell = UITableViewCell() as? T else {
            //fatalError("tableviewcell not found")
            print("tableviewcell not found")
            return nil
        }
        return tableViewCell
    }
    
    func register(nibType: AnyClass) {
        let name = String(describing: nibType)
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
}
