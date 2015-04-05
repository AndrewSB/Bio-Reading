//
//  AdminPanelViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 4/2/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class AdminPanelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var personTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        personTableView.delegate = self
        personTableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as UITableViewCell
        
        cell.showsReorderControl = true
        
        cell.textLabel?.text = "sex"
        
        return cell
    }
}
