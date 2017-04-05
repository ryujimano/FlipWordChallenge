//
//  GameViewController.swift
//  FlipWordChallenge
//
//  Created by Ryuji Mano on 4/3/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SwitchButtonDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var quitButton: UIButton!
    
    //the amount of buttons
    var cellCount = 4
    //the amount of associated buttons to each button
    var associatedCount = 1
    
    //array of buttons
    var buttons: [SwitchButton] = []
    
    @IBOutlet weak var finishedView: UIView!
    

    //MARK: View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        
        //initialize new buttons
        for _ in 0 ..< cellCount {
            buttons.append(SwitchButton())
        }
        
        //set buttons to be associated to each button
        var k = 0
        for i in 0 ..< cellCount {
            var switchButtons: [Int : SwitchButton] = [:]
            k = 0
            while k < associatedCount {
                //choose a random button to associate to ith button
                let j = Int(arc4random_uniform(UInt32(cellCount)))
                if j != i && switchButtons[j] == nil {
                    switchButtons[j] = buttons[j]
                    k += 1
                }
            }
            buttons[i].switchButtons = switchButtons
        }
        
        finishedView.alpha = 0
        finishedView.isUserInteractionEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //split into 2 sections if jagged
        if cellCount == 4 || cellCount % 3 == 0 {
            return 1
        }
        else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //set first section to have 2 or 3 buttons per row
        if section == 0 {
            if cellCount == 4 || cellCount % 3 == 0 {
                return cellCount
            }
            else {
                return (cellCount / 3) * 3
            }
        }
        //set second section to have the remaining buttons
        else {
            return cellCount % 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath) as! ButtonCollectionViewCell
        
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        
        //set the color to green if the button is on
        //set the color to red if the button is off
        if indexPath.section == 0 {
            let button = buttons[indexPath.item]
            if button.onOff {
                cell.button.backgroundColor = .green
            }
            else {
                cell.button.backgroundColor = .red
            }
            cell.button.tag = indexPath.item
        }
        else {
            let button = buttons[(3 * (cellCount / 3)) + indexPath.item]
            if button.onOff {
                cell.button.backgroundColor = .green
            }
            else {
                cell.button.backgroundColor = .red
            }
            cell.button.tag = (3 * (cellCount / 3)) + indexPath.item
        }
 
        //set the SwitchButtonDelegate to this view controller
        cell.delegate = self
        
        return cell
    }
    
    
    
    //MARK: CollectionView Layout Configuration
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //set layout to 2 buttons per row
        if cellCount > 4 {
            return CGSize(width: 120, height: 120)
        }
        //otherwise set layout to 3 buttons per row
        return CGSize(width: 175, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let rowCount = cellCount > 4 ? 3 : 2
        
        let verticalCount = ((cellCount - 1) / 6) >= 1 ? 3 : 2
        let totalCellHeight = verticalCount * (rowCount > 2 ? 120 : 175)
        let totalHeightSpacingWidth = 5 * (verticalCount - 1)
        
        //top and bottom insets calculated to center buttons in CollectionView
        let topInset = (collectionView.bounds.height - CGFloat(totalCellHeight + totalHeightSpacingWidth)) / 2
        let bottomInset = topInset
        
        if section == 0 {
            let totalCellWidth = rowCount * (rowCount > 2 ? 120 : 175)
            let totalSpacingWidth = 5 * (rowCount - 1)
            
            //left and right insets calculated to center buttons in CollectionView
            let leftInset = (collectionView.bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            
            //return appropriate insets to center this section
            return UIEdgeInsets(top: topInset, left: leftInset, bottom: (cellCount == 4 || cellCount % 3 == 0) ? bottomInset : 5, right: rightInset)
        }
        else {
            let rowCount2 = cellCount % 3
            let totalCellWidth = rowCount2 * 120
            let totalSpacingWidth = 5 * (rowCount2 - 1)
            
            //left and right insets calculated to center buttons in CollectionView
            let leftInset = (collectionView.bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            
            //return appropriate insets to center this section
            return UIEdgeInsets(top: 0, left: leftInset, bottom: bottomInset, right: rightInset)
        }
    }
    
    
    
    //MARK: Switch Button Action
    func onButtonTapped(sender: UIButton) {
        //check if the game is finished
        var isFinished = true
        
        //turn corresponding buttons on/off
        for i in 0 ..< cellCount {
            if i == sender.tag {
                //if ith button is tapped, turn on/off
                buttons[i].onOff = !buttons[i].onOff
                
                for (idx, _) in buttons[i].switchButtons {
                    //turn associated button on/off
                    buttons[idx].onOff = !buttons[idx].onOff
                }
            }
        }
        //reload the CollectionView
        collectionView.reloadData()
        
        //check each button to see if the game is finished
        for i in 0 ..< cellCount {
            if buttons[i].onOff {
                isFinished = false
            }
        }
        
        //if the game is finished, change the view to the "congratulations" view
        if isFinished {
            UIView.animate(withDuration: 0.8, animations: {
                self.view.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.6)
                
                self.collectionView.alpha = 0
                self.collectionView.isUserInteractionEnabled = false
                self.quitButton.alpha = 0
                self.quitButton.isUserInteractionEnabled = false
                
                self.finishedView.alpha = 1
                self.finishedView.isUserInteractionEnabled = true
            })
        }
    }

    
    
    //MARK: PlayAgainButton Action
    @IBAction func playAgainTapped(_ sender: Any) {
        //go back to initial View Controller when tapped
        dismiss(animated: false, completion: nil)
    }
    
    
    //MARK: QuitButton Action
    @IBAction func quitTapped(_ sender: Any) {
        //go back to initial View Controller when tapped
        dismiss(animated: false, completion: nil)
    }
    
}

