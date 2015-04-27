//
//  QuestionPickerViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/6/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class PromptPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var selected = [Bool]()
    var selectedIndex = Int()
    
    var isFirstView = true
    
    let people = UserStore.bios
    var curPerson: (String, Bool)? {
        didSet {
            selected.removeAll(keepCapacity: false)
            
            for i in 0...(IO.getNumSentances(curPerson!.0)! - 1) {
                selected.append(false)
            }
            
            collectionView.reloadData()
            self.viewWillAppear(false)
        }
    }
    var curPersonIndex: Int = 0 {
        didSet {
            curPerson = people[curPersonIndex]
        }
    }
    
    var curPersonControlTimes = [0.5,1,2,1,1,1,1,1,1,1,1,1]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curPerson = people[curPersonIndex]
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if UserStore.subjectNumber == nil {
            UserStore.subjectNumber = 123456789
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.title = curPerson!.0
        nameLabel.text = self.navigationItem.title!
        
        recordStoreLogic()
        doneLogic()
        
        UserStore.isTimed = !curPerson!.1
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.foragingLogic()
        })
        
        if isFirstView {
            isFirstView = false
            
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
        
        let width: CGFloat = (collectionView.frame.size.width - 44)/3
        let height: CGFloat = (collectionView.frame.size.height - 66)/4
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectCell(indexPath)
    }
    
    func selectCell(indexPath: NSIndexPath) {
        for cell in collectionView.visibleCells() {
            cell.layer.borderWidth = 0
        }
        
        if !selected[indexPath.row] {
            
            
            collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.grayColor()
            selected[indexPath.row] = true
            
            selectedIndex = indexPath.row
            
            RecordStore.defaultStore().curRecord!.cue = indexPath.row
            RecordStore.defaultStore().curRecord!.order = selected.filter({!$0}).count
            
            let prompt = IO.getPrompt(curPerson!.0, index: indexPath.row)
            self.performSegueWithIdentifier("segueToPromptVC", sender: prompt)
        }
    }
    
    // MARK: - Helper
    func foragingLogic() {
        println(curPerson!.1)
        if !doneLogic() {
            if curPerson!.1 { //foraging
                view.userInteractionEnabled = true
            } else { //control
                var cellIndexSelectionPool = [UICollectionViewCell]()
                
                for (index, element) in enumerate(collectionView.visibleCells()) {
                    
                    if !selected[index] {
                        cellIndexSelectionPool.append(element as! UICollectionViewCell)
                    }
                }
                
                let toSegueTo = cellIndexSelectionPool.getRandomElement()
                view.userInteractionEnabled = false
                
                toSegueTo.layer.borderColor = UIColor.yellowColor().CGColor
                toSegueTo.layer.borderWidth = 5
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    self.view.userInteractionEnabled = true
                    self.selectCell(self.collectionView.indexPathForCell(toSegueTo as UICollectionViewCell)!
                    )
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
            RecordStore.defaultStore().writeToDisk()
            let changingPersonAlert = UIAlertController(title: "Changing Bios!", message: "You're about to switch to a new bio!", preferredStyle: .Alert)
            changingPersonAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { Void in
                self.curPersonIndex++
            }))
            
            self.presentViewController(changingPersonAlert, animated: true, completion: {println("presented")})
            return true
        }
        return false
    }
    
    func recordStoreLogic() {
        let rS = RecordStore.defaultStore()
        
        //store the old record if it exists
        if rS.curRecord != nil {
            rS.records.append(rS.curRecord!)
        }
        
        //invalidate the old record and create a new one, that will be filled out when the subject goes through the other views
        rS.curRecord = RecordEntry()
        rS.curRecord!.bioPerson = BioPersons.fromRaw(self.navigationItem.title!)
        rS.curRecord!.condition = curPerson!.1 ? .Foraging : .Control
            

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
