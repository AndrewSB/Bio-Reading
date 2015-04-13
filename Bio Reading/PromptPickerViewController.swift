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
    
    let people = UserStore.bios
    var curPerson: (String, Bool)? {
        didSet {
            selected.removeAll(keepCapacity: false)
            
            for i in 0...(IO.getNumSentances(curPerson!.0)! - 1) {
                selected.append(false)
            }
            
            collectionView.reloadData()
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
        doneLogic()
        
        self.navigationItem.title = curPerson!.0
        nameLabel.text = self.navigationItem.title!
        
        set(!curPerson!.1, forKey: "timed")
        
        foragingLogic()
        
        recordStoreLogic()
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
        if curPerson!.1 { //foraging
            view.userInteractionEnabled = true
        } else { //control
            var toSegueTo: NSIndexPath?
            for (index, element) in enumerate(selected) {
                if toSegueTo == nil {
                    if !element {
                        toSegueTo = NSIndexPath(forRow: index, inSection: 0)
                    }
                }
            }
            view.userInteractionEnabled = false
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    self.view.userInteractionEnabled = true
                    self.selectCell(toSegueTo!)
            })
        }
    }
    
    func doneLogic() {
        var stay = false
        
        for f in selected {
            if f == false {
                stay = true
            }
        }
        
        if !stay {
            curPersonIndex++
        }
    }
    
    func recordStoreLogic() {
        let rS = RecordStore.defaultStore()
        
        if curPerson!.0 != "Example" {
            if rS.curRecord != nil {
                rS.records.append(rS.curRecord!)
            }
            rS.curRecord = RecordEntry()
            rS.curRecord!.bioPerson = BioPersons.fromRaw(self.navigationItem.title!)
            rS.curRecord!.condition = curPerson!.1 ? .Foraging : .Control
        }

    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        (segue.destinationViewController as! UIViewController).title = sender as? String
        
        set(sender as? String, forKey: "currentTitle")
        set(self.navigationItem.title!, forKey: "currentPerson")
        set(curPersonControlTimes[curPersonIndex], forKey: "currentTime")
        
        if let s = segue.destinationViewController as? CuriosityViewController {
            s.person = self.navigationItem.title!
            s.index = selectedIndex
        }
    }
    
    @IBAction func unwindToPromptPickerViewController(segue: UIStoryboardSegue) {}

}
