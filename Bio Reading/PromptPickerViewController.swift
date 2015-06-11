//
//  QuestionPickerViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/6/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PromptPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let timerLabel = MZTimerLabel()
    var timer: NSTimer!
    
    var selected = [Bool]()
    var selectedIndex = Int()
    
    var override = false {
        didSet {
            if oldValue {
                timerLabel.timerType = MZTimerLabelTypeTimer
                timerLabel.setCountDownTime(300)
                timerLabel.startWithEndingBlock({ (timer) in
                    self.selected = [Bool](count: self.selected.count, repeatedValue: false)
                })
            }
        }
    }
    
    let people = UserStore.bios
    var curPerson: (String, Bool)! {
        didSet {
            //prompt logic
            selected.removeAll(keepCapacity: false)
            
            for i in 0...(IO.getNumSentances(curPerson.0)! - 1) {
                selected.append(false)
            }
            
            collectionView.reloadData()
            
            
            //control time logic
            curPersonControlTimes = [Double]()
            
            for i in 0..<(IO.getNumSentances(curPerson.0)!) {
                let spider = IO.getCPIDR(curPerson.0, index: i)
                
                curPersonControlTimes.append(IO.calculateTime(spider!, n: i, rt: UserStore.rTCond!))
            }
            
            
            self.viewWillAppear(false)
        }
    }
    var curPersonIndex: Int = 0 {
        didSet {
            override = false
            curPerson = people[curPersonIndex]
        }
    }
    
    var curPersonControlTimes = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        timerLabel.frame = CGRect(x: view.frame.width - 80, y: 10, width: 100, height: 44)
        view.addSubview(timerLabel)

        
        curPerson = people[curPersonIndex]
        
        if UserStore.subjectNumber == nil {
            UserStore.subjectNumber = 123456789
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = curPerson.0
        nameLabel.text = self.navigationItem.title!
        
        recordStoreLogic()
        doneLogic()
        
        UserStore.isTimed = !curPerson.1
    }
    
    override func viewDidAppear(animated: Bool) {
        if !override {
            if curPerson.0.rangeOfString("Practice") != nil  {
                self.performSegueWithIdentifier("segueToInstructions", sender: curPerson.1 ? foragingInstructions : controlInstructions)
            }
        } else {
            override = true
        }
        
        super.viewDidAppear(animated)
        
        if override {
            self.foragingLogic()
            
        }
    }


    
    // ======================================
    // COLLECTION VIEW METHODS
    // ======================================
    func collectionView(colorCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selected.count
    }
    
    func collectionView(colorCollectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellID", forIndexPath: indexPath) as! PromptCollectionViewCell
        
        cell.promptLabel.text = IO.getPrompt(self.navigationItem.title!, index: indexPath.row)
        cell.backgroundColor = selected[indexPath.row] ? UIColor.grayColor() : UIColor(red: 0.251, green: 0.69, blue: 0.692, alpha: 1)
        
        return cell
    }
    
    func collectionView(colorCollectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 44)/3, height: (collectionView.frame.size.height - 66)/4)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectCell(indexPath)
    }
    
    func selectCell(indexPath: NSIndexPath) {
        if !selected[indexPath.row] {
            appDel.currentRecord!.cue = indexPath.item
            appDel.currentRecord!.dateTime = NSDate()
            appDel.currentRecord!.order = selected.filter({ !$0 }).count
            
            collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.grayColor()
            selected[indexPath.row] = true
            
            selectedIndex = indexPath.row
            
            appDel.currentRecord!.cue = indexPath.row
            appDel.currentRecord!.order = selected.filter({$0}).count
            
            println(curPersonControlTimes[indexPath.row])
            UserStore.currentTime = curPersonControlTimes[indexPath.row]
            
            let prompt = IO.getPrompt(curPerson.0, index: indexPath.row)
            self.performSegueWithIdentifier("segueToPromptVC", sender: prompt)
        }
        
        println(selected)
    }
    
    // MARK: - Helper
    func secondPassed() {
        var secs: Double = 0
        
        let timeComponents = split(timerLabel.text!, isSeparator: { $0 == ":" })
        for (index, element) in enumerate(timeComponents) {
            let power = timeComponents.count - index
            
            secs += pow(Double(element.toInt()!), Double(power))
            println(secs)
        }
        
        let secString = Int(secs--)
        
        timerLabel.text = secString.secondsToString()
    }
    
    
    func foragingLogic() {
        println(curPerson.1)
        if !doneLogic() {
            if curPerson.1 { //foraging
                view.userInteractionEnabled = true
            } else { //control
                
                var cellIndexSelectionPool = [Int]()
                
                for i in 0..<selected.count {
                    if !selected[i] {
                        cellIndexSelectionPool.append(i)
                    }
                }
                
                let chosenIndex = NSIndexPath(forItem: cellIndexSelectionPool.getRandomElement(), inSection: 0)
                let toSegueTo = collectionView.cellForItemAtIndexPath(chosenIndex)!
                view.userInteractionEnabled = false
                
                toSegueTo.layer.borderColor = UIColor.yellowColor().CGColor
                toSegueTo.layer.borderWidth = 5
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    self.view.userInteractionEnabled = true
                    self.selectCell(chosenIndex)
                    
                    toSegueTo.layer.borderWidth = 0
                })
            }
            
        }
        
        
    }
    
    func doneLogic() -> Bool {
        var stay = false
        
        for f in selected {
            if f == false {
                return false
            }
        }
        
        let doneAlert = UIAlertController(title: "Done with set", message: "", preferredStyle: .Alert)
        doneAlert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (alertController) in
            if self.curPersonIndex +  1 <= self.people.count {
                println("yo yo")
                println("person is \(self.people[self.curPersonIndex + 1].0)")
                self.performSegueWithIdentifier("segueToFam", sender: self.people[self.curPersonIndex + 1].0)
            }
        }))
        
        self.presentViewController(doneAlert, animated: true, completion: nil)
        
        return true
    }
    
    func recordStoreLogic() {
        let app = appDel.currentRecord
        println(app)
        
        //store the old record if it exists
        appDel.managedObjectContext!.save(nil)
        
        //get a new record and fill it out for the
        appDel.currentRecord = NSEntityDescription.getNewRecordInManagedContext()
        
        appDel.currentRecord!.subjectNumber = UserStore.subjectNumber!
        appDel.currentRecord!.bioPerson = self.navigationItem.title!
        appDel.currentRecord!.condition = curPerson.1 ? 0 : 1
        if let fam = UserStore.currentFamiliarity {
            appDel.currentRecord!.familiarity = fam
        }
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        (segue.destinationViewController as! UIViewController).title = sender as? String
        
        UserStore.currentTitle = sender as? String
        UserStore.currentPerson = self.navigationItem.title!
        
        if let s = segue.destinationViewController as? CuriosityViewController {
            s.person = self.navigationItem.title!
            s.index = selectedIndex
        }
        
        if let des = segue.destinationViewController as? FamiliarityViewController {
            des.person = sender as! String
        }
        
        if let des = segue.destinationViewController as? FirstTimeInstructionViewController {
            des.instructionText = sender as! String
        }
    }
    
    @IBAction func unwindToPromptPickerViewController(segue: UIStoryboardSegue) {}
}
