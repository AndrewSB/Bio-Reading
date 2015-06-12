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

class PromptPickerViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let timerLabel = MZTimerLabel()
    
    var selected = [Bool]()
    var selectedIndex = Int()
    
    var curBioIndex: Int! {
        didSet { curPerson = UserStore.bios[curBioIndex] }
    }
    
    var curPerson: (String, Bool)! {
        didSet { newPerson() }
    }
    var curPersonIndex = 0
    
    var firstTimeInstructions = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        timerLabel.frame = CGRect(x: view.frame.width - 100, y: 10, width: 100, height: 44)
        timerLabel.timeFormat = "mm:ss"
        view.addSubview(timerLabel)
        
        curBioIndex = 0
        
        if UserStore.subjectNumber == nil {
            UserStore.subjectNumber = 123456
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        recordStoreLogic()
        doneLogic()
    }
    
    override func viewDidAppear(animated: Bool) {
        if firstTimeInstructions {
            self.foragingLogic()
        } else {
            firstTimeInstructions = true
            if curPerson.0.rangeOfString("Practice") != nil {
                self.performSegueWithIdentifier("segueToInstructions", sender: curPerson.1 ? foragingInstructions : controlInstructions)
            } else {
                self.performSegueWithIdentifier("segueToFam", sender: curPerson.0)
            }
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
            appDel.currentRecord!.cue = indexPath.item
            appDel.currentRecord!.dateTime = NSDate()
            appDel.currentRecord!.order = selected.filter({ !$0 }).count
            
            collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.grayColor()
            selected[indexPath.row] = true
            
            selectedIndex = indexPath.row
            
            appDel.currentRecord!.cue = indexPath.row
            appDel.currentRecord!.order = selected.filter({$0}).count
            
            UserStore.currentTime = IO.calculateTime(curPerson.0, prompt: selectedIndex, n: curPersonIndex)
            
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
                self.performSegueWithIdentifier("segueToFam", sender: UserStore.bios[self.curPersonIndex + 1].0)
            }
        }))
        
        self.presentViewController(doneAlert, animated: true, completion: nil)
        curBioIndex = curBioIndex + 1
        
        return true
    }
    
    func recordStoreLogic() {
        
        //store the old record if it exists and is valid
        if appDel.currentRecord?.audioFile != nil {
            appDel.managedObjectContext!.save(nil)
            println("saved \(appDel.currentRecord!)")
        }
        
        //get a new record and fill it out for the
        appDel.currentRecord = NSEntityDescription.getNewRecordInManagedContext()
        
        appDel.currentRecord!.subjectNumber = UserStore.subjectNumber!
        appDel.currentRecord!.bioPerson = self.navigationItem.title!
        appDel.currentRecord!.condition = curPerson.1 ? 0 : 1
        if let fam = UserStore.currentFamiliarity {
            appDel.currentRecord!.familiarity = fam
        }
    }
    
    func newPerson() {
        self.navigationItem.title = curPerson.0
        nameLabel.text = curPerson.0
        
        UserStore.isTimed = !curPerson.1
        
        selected = [Bool](count: IO.getNumSentances(curPerson.0)!, repeatedValue: false)
        collectionView.reloadData()
        
        timerLabel.reset()
        timerLabel.setStopWatchTime(300)
        if curPerson.1 { //foraging
            timerLabel.hidden = false
            timerLabel.startWithEndingBlock({ time in
                self.curBioIndex = self.curBioIndex + 1
            })
        } else {
            timerLabel.hidden = true
        }
    }
}

