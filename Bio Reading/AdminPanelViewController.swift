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

class AdminPanelViewController: UIViewController {

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
        
        restoreStateFromDefaults()
        
        personTableView.delegate = self
        personTableView.dataSource = self
        personTableView.setEditing(true, animated: true)
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
        
        let classes = UserStore.parseClassName
        
        for clas in classes {
            let q = PFQuery(className: clas)
            q.fromLocalDatastore()
            q.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if let error = error {
                    let alert = UIAlertController(title: "Error finding some data", message: "\(error)", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    if let objects = objects {
                        println("found objects: \(objects)")
                        for object in objects {
                            if !Reachability.isConnectedToNetwork() {
                                println("not connected to network")
                                let alert = UIAlertController(title: "Not connected to internet", message: "connect and try again", preferredStyle: .Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                            } else {
                                object.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                    println(success)
                                    if let error = error {
                                        
                                        let alert = UIAlertController(title: "Error saving some data", message: "\(error)", preferredStyle: .Alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    }
                                    if success {
                                        println("saved an obj")
                                        object.unpinInBackground()
                                    }
                                })
                            }
                        }
                    }
                }
            })
        }
        
        syncRecordsButton.setTitle("Done syncing records", forState: .Normal)
        view.userInteractionEnabled = true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        saveStoreToDefaults()
    }
}

// Table View
extension AdminPanelViewController: UITableViewDataSource, UITableViewDelegate {
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
}

// State
extension AdminPanelViewController {
    private func restoreStateFromDefaults() {
        if let num = NSUserDefaults.standardUserDefaults().objectForKey("subjectNumber") as? Int {
            subjectNumberTextField.text = "\(num)"
        }
        
        increasingDecreasingSegmentedControl.selectedSegmentIndex = UserStore.rTCond!.hashValue
        
        timeLimitTextField.text = "\(UserStore.timeLimit!)"

        fontLabel.font = UIFont.HelveticaNeue()
        fontStepper.value = Double(fontLabel.font.pointSize)
    }
    
    private func saveStoreToDefaults() {
        UserStore.fontSize = CGFloat(fontStepper.value)
        UserStore.bios = randBios
        UserStore.subjectNumber = subjectNumberTextField.text.toInt()
        UserStore.rTCond = increasingDecreasingSegmentedControl.selectedSegmentIndex == 0 ? .Increasing : .Decreasing
        UserStore.timeLimit = timeLimitTextField.text.toInt()
    }
}
