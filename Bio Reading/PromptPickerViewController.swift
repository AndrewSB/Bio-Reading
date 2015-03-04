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
    
    var foraging = Bool()
    var practice = Bool()
    
    var selected = [Bool]()
    
    
    let colors = [0x00F900, 0x00AC76, ]
    
    override func viewDidLoad() {
        self.navigationItem.title = "Einstein"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSUserDefaults.standardUserDefaults().setObject(false, forKey: "timed")
        
        super.viewDidLoad()
        
        
        for (var i = 0; i < (practice ? 3 : 12); i++) {
            selected.append(false)
        }
    }
    
    // ======================================
    // COLLECTION VIEW METHODS
    // ======================================
    func collectionView(colorCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if practice {
            return 3
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
            performSegueWithIdentifier("segueToPromptVC", sender: (collectionView.cellForItemAtIndexPath(indexPath) as PromptCollectionViewCell).promptLabel.text)
            selected[indexPath.row] = true
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let s = segue.destinationViewController as? PromptViewController {
            s.navTitle = sender as String
        }
    }
    
    @IBAction func unwindToPromptPickerViewController(segue: UIStoryboardSegue) {}

}
