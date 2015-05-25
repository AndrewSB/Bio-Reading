//
//  QuestionPickerViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/6/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import CoreData

class PromptPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var selected = [Bool]()
    var selectedIndex = Int()
    
    let people = UserStore.bios
    var curPerson: (String, Bool)? {
        didSet {
            selected.removeAll(keepCapacity: false)
            
            for i in 0...(IO.getNumSentances(curPerson!.0)! - 1) {
                selected.append(false)
            }
            
            collectionView.reloadData()
//            self.viewWillAppear(false)
        }
    }
    var curPersonIndex: Int = 0 {
        didSet {
            curPerson = people[curPersonIndex]
        }
    }
    
    var curPersonControlTimes: [Double] {
        get {
            var r = [Double]()
            for i in 0..<(IO.getNumSentances(curPerson!.0)! - 1) {
                let spider = IO.getCPIDR(curPerson!.0, index: i)
                
                let enn = selected.filter({ $0 }).count
                
                r.append(IO.calculateTime(spider!, n: enn, rt: RTCond.Increasing))
            }
            
            return r
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curPerson = people[curPersonIndex]
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if UserStore.subjectNumber == nil {
            UserStore.subjectNumber = 123456789
        }
        
        let fsdfds = self.curPersonControlTimes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = curPerson!.0
        nameLabel.text = self.navigationItem.title!
        
        recordStoreLogic()
        doneLogic()
        
        UserStore.isTimed = !curPerson!.1
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
            self.foragingLogic()
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
            collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.grayColor()
            selected[indexPath.row] = true
            
            selectedIndex = indexPath.row
            
            appDel.currentRecord!.cue = indexPath.row
            appDel.currentRecord!.order = selected.filter({!$0}).count
            
            let prompt = IO.getPrompt(curPerson!.0, index: indexPath.row)
            self.performSegueWithIdentifier("segueToPromptVC", sender: prompt)
        }
        
        println(selected)
    }
    
    // MARK: - Helper
    func foragingLogic() {
        println(curPerson!.1)
        if !doneLogic() {
            if curPerson!.1 { //foraging
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
                toSegueTo.layer.borderWidth = 2
                
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
                stay = true
            }
        }
        
        if !stay {
            let alertC = FamiliarityAlertViewController(title: "Switching Bios", message: "How familiar are you with \(curPerson!.0)?\n\n\n", preferredStyle: .Alert)
            
            alertC.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (alertController) in
                UserStore.currentFamiliarity = Double(alertC.slider.value)
            }))
            
            self.presentViewController(alertC, animated: true, completion: nil)
            return true
        }
        return false
    }
    
    func recordStoreLogic() {
        let app = appDel.currentRecord
        println(app)
        
        //store the old record if it exists
        appDel.managedObjectContext!.save(nil)
        
        //get a new record and fill it out for the
        appDel.currentRecord = NSEntityDescription.getNewRecordInManagedContext()
        appDel.currentRecord!.bioPerson = self.navigationItem.title!
        appDel.currentRecord!.condition = curPerson!.1 ? 0 : 1
        appDel.currentRecord!.familiarity = UserStore.currentFamiliarity!
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        (segue.destinationViewController as! UIViewController).title = sender as? String
        
        UserStore.currentTitle = sender as? String
        UserStore.currentPerson = self.navigationItem.title!
        UserStore.currentTime = curPersonControlTimes[curPersonIndex]

        
        if let s = segue.destinationViewController as? CuriosityViewController {
            s.person = self.navigationItem.title!
            s.index = selectedIndex
        }
    }
    
    @IBAction func unwindToPromptPickerViewController(segue: UIStoryboardSegue) {}
}
