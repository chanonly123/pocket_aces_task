//
//  UITableView.swift
//  Dev
//
//  Created by Chandan Karmakar on 20/09/19.
//  Copyright © 2019 Chandan Karmakar. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(type: T.Type) -> T {
        let identifier = String(describing: type)
        if let reusableCell = self.dequeueReusableCell(withIdentifier: identifier) {
            if let cell = reusableCell as? T {
                return cell
            } else {
                assertionFailure("tableview cell cannot be casted: \(identifier)")
            }
        } else {
            assertionFailure("tableview cell not found: \(identifier)")
        }
        assertionFailure("tableviewcell not found")
        return UITableViewCell() as! T
    }
    
    func register(nibType: AnyClass) {
        let name = String(describing: nibType)
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
}
