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
    
    var foraging = Bool()
    var practice = Bool()
    
    var selected = [Bool]()
    var selectedIndex = Int()
    
    var curIndex = 0
    
    let demPeeps = [("Marie Curie", true), ("Marie Curie", false), ("Einstien", true)]
    var currentPeep: (String, Bool) = (String(), Bool())

    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSUserDefaults.standardUserDefaults().setObject(false, forKey: "timed")
        
        if selected.count == 0 {
            for (var i = 0; i < (practice ? 1 : 12); i++) {
                selected.append(false)
            }
        }
        
        doneLogic()
        
        if practice {
            currentPeep = ("Einstein", false)
            curIndex = -1
        }
        
        
        self.navigationItem.title = currentPeep.0
        foraging = currentPeep.1
        
        
        println(self.navigationItem.title!)
    
        nameLabel.text = self.navigationItem.title!
        
        foragingLogic()
    }
    
    // ======================================
    // COLLECTION VIEW METHODS
    // ======================================
    func collectionView(colorCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if practice {
            return 1
        }
        return 12
    }
    
    func collectionView(colorCollectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellID", forIndexPath: indexPath) as PromptCollectionViewCell
        
        cell.promptLabel.text = getPrompt(self.navigationItem.title!, indexPath.row)
        cell.backgroundColor = selected[indexPath.row] ? UIColor.grayColor() : UIColor(red: 0.251, green: 0.69, blue: 0.692, alpha: 1)
        
        return cell
    }
    
    func collectionView(colorCollectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        
        let width: CGFloat = (collectionView.frame.size.width - 44)/3
        let height: CGFloat = (collectionView.frame.size.height - 66)/4
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("lol at \(indexPath.row)")
        
        if !selected[indexPath.row] {
            collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.grayColor()
            selected[indexPath.row] = true
            
            selectedIndex = indexPath.row
            
            performSegueWithIdentifier("segueToPromptVC", sender: (collectionView.cellForItemAtIndexPath(indexPath) as PromptCollectionViewCell).promptLabel.text)
            
        }
    }
    
    // MARK: - Helper
    func foragingLogic() {
        if foraging {
            view.userInteractionEnabled = false
            
            var segueToCell = UICollectionViewCell()
            for (index, element) in enumerate(self.collectionView.visibleCells()) {
                if self.selected[index] == false {
                    segueToCell = element as UICollectionViewCell
                }
            }
            
            let iPath = self.collectionView.indexPathForCell(segueToCell)
            println("")
            
            segueToCell.selected = true
            
            
//            let time: Int64 = Int64(NSEC_PER_SEC)
//            let popTime = dispatch_time(DISPATCH_TIME_NOW, time);
//            dispatch_after(popTime, dispatch_get_main_queue(), {
//                
//                var segueToCell = UICollectionViewCell()
//                for (index, element) in enumerate(self.collectionView.visibleCells()) {
//                    if self.selected[index] == false {
//                        segueToCell = element as UICollectionViewCell
//                    }
//                }
            
//                let iPath = self.collectionView.indexPathForCell(segueToCell)
//                
//                self.collectionView.selectItemAtIndexPath(iPath, animated: true, scrollPosition: .None)
//            });

        } else {
            
        }
        view.userInteractionEnabled = true
    }
    
    func doneLogic() {
        var stay = false
        
        for f in selected {
            
            if f == false {
                
                stay = true
            }
        }
        
        if !stay {
            
            curIndex++
            currentPeep = demPeeps[curIndex]
            practice = false
            
            selected = [Bool]()
            for i in 0...11 {
                selected.append(false)
            }
            
            self.collectionView.reloadData()
            
            let startingAlert = UIAlertController(title: "You is starting", message: "Be careful", preferredStyle: .Alert)
            let startAction = UIAlertAction(title: "Start", style: .Cancel, handler: nil)
            startingAlert.addAction(startAction)
            
            self.presentViewController(startingAlert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        (segue.destinationViewController as UIViewController).title = sender as? String
        
        NSUserDefaults.standardUserDefaults().setObject(sender as? String, forKey: "currentTitle")
        NSUserDefaults.standardUserDefaults().setObject(self.navigationItem.title!, forKey: "currentPerson")
        
        if let s = segue.destinationViewController as? CuriosityViewController {
            s.person = self.navigationItem.title!
            s.index = selectedIndex
        }
    }
    
    @IBAction func unwindToPromptPickerViewController(segue: UIStoryboardSegue) {}

}
