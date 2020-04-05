//
//  CountryPickerVC.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 05/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class CountryPickerVC: BaseTableViewController {
    override class var fromStoryboard: UIStoryboard? { return Storybaords.main }
    
    var items = [CountryEntry]()
    
    var didSelect: ((CountryEntry)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select country"
        
        if let path = Bundle.main.url(forResource: "country_codes", withExtension: "json") {
            let data = try? JSONDecoder().decode(CountryCodeData.self, from: Data(contentsOf: path))
            items = data?.data ?? []
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        didSelect?(items[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: CountryPickerCell.self)
        cell.country = items[indexPath.row]
        cell.reloadViews()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

class CountryPickerCell: BaseTableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    var country: CountryEntry?
    
    func reloadViews() {
        lblName.text = (country?.name ?? "") + " (\(country?.code ?? ""))"
    }
}
