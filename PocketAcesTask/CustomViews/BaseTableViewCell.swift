//
//  BaseTableViewCell.swift
//  eezylife-sample
//
//  Created by Chandan Karmakar on 14/03/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        //contentView.enableTouchFeedback(enable: true)
    }
    
    var tableView: UITableView? {
        return (superview as? UITableView) ?? (superview?.superview as? UITableView)
    }
    
    func updateCellHeight() {
        tableView?.beginUpdates()
        tableView?.endUpdates()
    }

}
