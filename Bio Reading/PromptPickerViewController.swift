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

import Parse
import Fabric
import Crashlytics

var globalTimerLabel: MZTimerLabel!

class PromptPickerViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var curRecord: Record!
    
    let timerLabel = MZTimerLabel()
    
    var selected = [Bool]()
    var selectedIndex = Int()
    
    var curSentance: Int?
    
    var curBioIndex: Int! {
        didSet {
            curPerson = UserStore.bios[curBioIndex]
            UserStore.currentBio = curBioIndex
        }
    }
    var curPerson: (String, Bool)! {
        didSet { newPerson() }
    }
    var curPersonIndex = 0
    
    var firstTimeInstructions = false
    var onePassFlag = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        timerLabel.timerType = MZTimerLabelTypeTimer
        timerLabel.frame = CGRect(x: view.frame.width - 100, y: 10, width: 100, height: 44)
        timerLabel.timeFormat = "mm:ss"
        view.addSubview(timerLabel)
        globalTimerLabel = timerLabel
        
        curBioIndex = 0
        
        if UserStore.subjectNumber == nil {
            UserStore.subjectNumber = 123456
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        globalTimerLabel = self.timerLabel
        
        if !onePassFlag {
            onePassFlag = true
            
            if curRecord != nil {
                managedObjectContext.save(nil)
            }
            curRecord = NSEntityDescription.insertNewObjectForEntityForName("Record", inManagedObjectContext: managedObjectContext) as! Record
        }
        
        recordStoreLogic()
        doneLogic()
    }
    
    override func viewDidAppear(animated: Bool) {
        if firstTimeInstructions {
            if !doneLogic() {
                self.foragingLogic()
            }
        } else {
            firstTimeInstructions = true
            if curPerson.0.rangeOfString("Practice") != nil {
                self.performSegueWithIdentifier("segueToInstructions", sender: curPerson.1 ? foragingInstructions : controlInstructions)
            } else {
                println("familiarity with \(curPerson.0)")
                self.performSegueWithIdentifier("segueToFam", sender: curPerson.0)
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        globalTimerLabel = self.timerLabel
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        (segue.destinationViewController as! UIViewController).title = sender as? String
        
        UserStore.currentTitle = sender as? String
        UserStore.currentPerson = self.navigationItem.title!
        
        if let des = segue.destinationViewController as? PromptViewController {
            des.curRecord = self.curRecord
        }
        
        if let s = segue.destinationViewController as? CuriosityViewController {
            s.person = self.navigationItem.title!
            s.index = selectedIndex
            
            s.curRecord = self.curRecord
        }
        
        if let des = segue.destinationViewController as? FamiliarityViewController {
            des.person = sender as! String
            des.curRecord = self.curRecord!
        }
        
        if let des = segue.destinationViewController as? FirstTimeInstructionViewController {
            des.instructionText = sender as! String
            des.person = curPerson.0
        }
    }
    
    @IBAction func unwindToPromptPickerViewController(segue: UIStoryboardSegue) {}
}


extension PromptPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {

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
            curSentance = indexPath.row
            
            onePassFlag = false
            
            let sen = IO.getSentance(curPerson.0, index: indexPath.item)!
          
          
            curRecord.order = selected.filter({ $0 }).count + 1
            curRecord.dateTime = NSDate()
            curRecord.cpidr = IO.getCPIDR(curPerson.0, index: indexPath.item)!
            curRecord.sentance = IO.getSentance(curPerson.0, index: indexPath.item)!
            
            collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.grayColor()
            selected[indexPath.row] = true
            
            selectedIndex = indexPath.row
            
            UserStore.currentTime = IO.calculateTime(curPerson.0, prompt: selectedIndex, n: selected.filter({ $0 }).count)
            
            let prompt = IO.getPrompt(curPerson.0, index: indexPath.row)
            self.performSegueWithIdentifier("segueToPromptVC", sender: prompt)
        }
    }
}

extension PromptPickerViewController {
    
    func foragingLogic() {
        if curPerson.1 { //foraging
            view.userInteractionEnabled = true
        } else { //control
            let possibilities: [Int?] = map(enumerate(selected)) { (index, element) in
                !element ? index : nil
            }
            
            var cellIndexSelectionPool = [Int]()
            for i in possibilities {
                if i != nil {
                    cellIndexSelectionPool.append(i!)
                }
            }
            
            Crashlytics().setObjectValue(cellIndexSelectionPool, forKey: "cell index row")
        
            let chosenIndex = NSIndexPath(forItem: cellIndexSelectionPool.getRandomElement(), inSection: 0)
            let toSegueTo = collectionView.cellForItemAtIndexPath(chosenIndex)!
            view.userInteractionEnabled = false
                
            toSegueTo.layer.borderColor = UIColor.yellowColor().CGColor
            toSegueTo.layer.borderWidth = 5
            
            println("Control: queued cell \(chosenIndex.row)")
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.view.userInteractionEnabled = true
                self.selectCell(chosenIndex)
                    
                toSegueTo.layer.borderWidth = 0
            })
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
            if self.curPersonIndex +  1 <= UserStore.bios.count {
                self.curBioIndex = self.curBioIndex + 1
            }
        }))
        
        self.presentViewController(doneAlert, animated: true, completion: nil)

        
        return true
    }
    
    func recordStoreLogic() {
        println(UserStore.subjectNumber)
        curRecord.subjectNumber = UserStore.subjectNumber!
        curRecord.bioPerson = self.navigationItem.title!
        curRecord.rTCond = curPerson.1 ? "Foraging" : (UserStore.rTCond! == .Increasing ? "Increasing" : "Decreasing")
        if let fam = UserStore.currentFamiliarity {
            curRecord.familiarity = NSDecimalNumber(double: fam)
        }
    }
    
    func newPerson() {
        self.navigationItem.title = curPerson.0
        nameLabel.text = curPerson.0
        
        onePassFlag = false
        firstTimeInstructions = false
        
        UserStore.isTimed = !curPerson.1
        
        selected = [Bool](count: IO.getNumSentances(curPerson.0)!, repeatedValue: false)
        collectionView.reloadData()
        
        UserStore.timeOffset = IO.createNewOffset(UserStore.rTCond!)
        
        timerLabel.reset()
        timerLabel.setCountDownTime(Double(UserStore.timeLimit!))
        globalTimerLabel = timerLabel
        if curPerson.1 { //foraging
            timerLabel.hidden = false
            timerLabel.endedBlock = { time in
                println("TIME!")
                self.curBioIndex = self.curBioIndex + 1
            }
        } else { //control
            timerLabel.hidden = true
        }
        
        if curPerson.0.rangeOfString("Practice") == nil {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.recordStoreLogic()
                self.viewDidAppear(false)
            })
        }
    }
}

