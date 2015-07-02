//
//  AdminPanelViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 4/2/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

import Parse
import Bolts

class AdminPanelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var subjectNumberTextField: UITextField!
    @IBOutlet weak var timeLimitTextField: UITextField!
    
    @IBOutlet weak var increasingDecreasingSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var personTableView: UITableView!
    
    @IBOutlet weak var syncRecordsButton: UIButton!
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var fontStepper: UIStepper!
    
    var randBios: [(String, Bool)] = UserStore.bios {
        didSet {
            if personTableView != nil {
                personTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let num = NSUserDefaults.standardUserDefaults().objectForKey("subjectNumber") as? Int {
            subjectNumberTextField.text = "\(num)"
        }
        
        increasingDecreasingSegmentedControl.selectedSegmentIndex = UserStore.rTCond!.hashValue
        
        fontLabel.font = UIFont(name: "HelveticaNeue", size: get("fontSize") as! CGFloat)
        timeLimitTextField.text = "\(UserStore.timeLimit!)"
        
        fontStepper.value = Double(fontLabel.font.pointSize)
        
        personTableView.delegate = self
        personTableView.dataSource = self
        
        personTableView.setEditing(true, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randBios.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! UITableViewCell
        
        cell.textLabel?.text = randBios[indexPath.row].0
        cell.detailTextLabel?.text = randBios[indexPath.row].1 ? "Foraging" : "Control"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        randBios[indexPath.row].1 = !randBios[indexPath.row].1
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {

        let temp = randBios[sourceIndexPath.row]
        randBios.removeAtIndex(sourceIndexPath.row)
        randBios.insert(temp, atIndex: destinationIndexPath.row)
        
        tableView.reloadData()
    }
    
    @IBAction func emailLogsButtonWasHit(sender: AnyObject) {
        
    }
    
    @IBAction func stepperValue(sender: AnyObject) {
        fontLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(fontStepper.value))
        fontLabel.text = "\(fontStepper.value)"
    }
    
    @IBAction func syncRecordsButtonWasHit() {
        view.userInteractionEnabled = false
        var savedObjects = 0 {
            didSet {
                syncRecordsButton.setTitle("Uploaded \(savedObjects) items", forState: .Normal)
            }
        }
        
        let queries = UserStore.parseClassName.map({ (className) -> PFQuery in
            let q = PFQuery(className: className)
            q.fromLocalDatastore()
            return q
        })
        
        for query in queries {
            let foundObjects = query.findObjects() as! [PFObject]
            for object in foundObjects {
                object.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    println("lol \(object)")
                    savedObjects++
                })
//                object.unpin()
                println(savedObjects)
            }
        }
        
        syncRecordsButton.setTitle("Done syncing records", forState: .Normal)
        view.userInteractionEnabled = true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        println("set font size as \(CGFloat(fontStepper.value))")
        
        UserStore.fontSize = CGFloat(fontStepper.value)
        UserStore.bios = randBios
        UserStore.subjectNumber = subjectNumberTextField.text.toInt()
        UserStore.rTCond = increasingDecreasingSegmentedControl.selectedSegmentIndex == 0 ? .Increasing : .Decreasing
        UserStore.timeLimit = timeLimitTextField.text.toInt()
    }
}
