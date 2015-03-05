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
    var selectedIndex = Int()
        
    override func viewDidLoad() {
        self.navigationItem.title = "Marie Curie"
        
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
            selected[indexPath.row] = true
            selectedIndex = indexPath.row
            
            performSegueWithIdentifier("segueToPromptVC", sender: (collectionView.cellForItemAtIndexPath(indexPath) as PromptCollectionViewCell).promptLabel.text)
            
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        (segue.destinationViewController as UIViewController).title = sender as? String
        
        if let s = segue.destinationViewController as? CuriosityViewController {
            s.person = self.navigationItem.title!
            s.index = selectedIndex
        }
    }
    
    @IBAction func unwindToPromptPickerViewController(segue: UIStoryboardSegue) {}

}
