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
    
    var cellCount = 4
    var associatedCount = 1
    
    var buttons: [SwitchButton] = []
    
    var onColor: UIImage!
    var offColor: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        
        for _ in 0 ..< cellCount {
            buttons.append(SwitchButton())
        }
        
        var k = 0
        for i in 0 ..< cellCount {
            var switchButtons: [Int : SwitchButton] = [:]
            k = 0
            while k < associatedCount {
                let j = Int(arc4random_uniform(UInt32(cellCount)))
                if j != i && switchButtons[j] == nil {
                    switchButtons[j] = buttons[j]
                    k += 1
                }
            }
            buttons[i].switchButtons = switchButtons
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if cellCount == 4 || cellCount % 3 == 0 {
            return 1
        }
        else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if cellCount == 4 || cellCount % 3 == 0 {
                return cellCount
            }
            else {
                return (cellCount / 3) * 3
            }
        }
        else {
            return cellCount % 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath) as! ButtonCollectionViewCell
        
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        
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
 
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cellCount > 4 {
            return CGSize(width: 120, height: 120)
        }
        return CGSize(width: 175, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let rowCount = cellCount > 4 ? 3 : 2
        
        let verticalCount = ((cellCount - 1) / 6) >= 1 ? 3 : 2
        let totalCellHeight = verticalCount * (rowCount > 2 ? 120 : 175)
        let totalHeightSpacingWidth = 5 * (verticalCount - 1)
        
        let topInset = (collectionView.bounds.height - CGFloat(totalCellHeight + totalHeightSpacingWidth)) / 2
        let bottomInset = topInset
        
        if section == 0 {
            let totalCellWidth = rowCount * (rowCount > 2 ? 120 : 175)
            let totalSpacingWidth = 5 * (rowCount - 1)
            
            let leftInset = (collectionView.bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            
            return UIEdgeInsets(top: topInset, left: leftInset, bottom: (cellCount == 4 || cellCount % 3 == 0) ? bottomInset : 5, right: rightInset)
        }
        else {
            let rowCount2 = cellCount % 3
            let totalCellWidth = rowCount2 * 120
            let totalSpacingWidth = 5 * (rowCount2 - 1)
            
            let leftInset = (collectionView.bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            
            
            return UIEdgeInsets(top: 0, left: leftInset, bottom: bottomInset, right: rightInset)
        }
    }
    
    func onButtonTapped(sender: SwitchButton) {
        for i in 0 ..< cellCount {
            if i == sender.tag {
                buttons[i].onOff = !buttons[i].onOff
                for (idx, _) in buttons[i].switchButtons {
                    buttons[idx].onOff = !buttons[idx].onOff
                }
                break
            }
        }
        collectionView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return colorImage!
    }

}

