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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curPerson = people[curPersonIndex]
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        assert(self.selected.count < 13, "over 13")
        
        doneLogic()
        
        self.navigationItem.title = curPerson!.0
        nameLabel.text = self.navigationItem.title!
        
        foragingLogic()
    }
    
    // ======================================
    // COLLECTION VIEW METHODS
    // ======================================
    func collectionView(colorCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selected.count
    }
    
    func collectionView(colorCollectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellID", forIndexPath: indexPath) as PromptCollectionViewCell
        
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
