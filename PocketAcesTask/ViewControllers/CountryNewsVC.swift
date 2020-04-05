//
//  ViewController.swift
//  PocketAcesTask
//
//  Created by Chandan Karmakar on 03/04/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class CountryNewsVC: BaseViewController {
    
    lazy var segment = UISegmentedControl(items: ["Headlines", "Channels"])
    
    var inputCountry = CountryEntry.createMyCountry() {
        didSet {
            updateViews()
        }
    }
    
    lazy var viewc1 = HeadlinesVC.instantiate()
    lazy var viewc2 = SourcesVC.instantiate()
                     
    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.titleView = segment
        segment.addTarget(self, action: #selector(segmentTabChanged), for: .valueChanged)
        
        segment.selectedSegmentIndex = 0
        updateViews()
    }
    
    func updateViews() {
        switch segment.selectedSegmentIndex {
        case 0:
            replace(viewc: viewc1, container: view)
            viewc1.input = .country(inputCountry)
        case 1:
            replace(viewc: viewc2, container: view)
            viewc2.inputCountry = inputCountry
        default: break
        }
        setNavRighButton(title: inputCountry.name ?? "")
    }
    
    @objc func segmentTabChanged() {
        updateViews()
    }
    
    override func tapNavRight() {
        let viewc = CountryPickerVC.instantiate()
        viewc.didSelect = { [weak self] country in
            self?.inputCountry = country
            self?.updateViews()
        }
        show(viewc, sender: nil)
    }
}

