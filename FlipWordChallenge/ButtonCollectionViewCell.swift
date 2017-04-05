//
//  ButtonCollectionViewCell.swift
//  FlipWordChallenge
//
//  Created by Ryuji Mano on 4/4/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit


//Protocol for button delegate
protocol SwitchButtonDelegate: class {
    func onButtonTapped(sender: UIButton)
}

class ButtonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var button: UIButton!
    
    //delegate for each switch button
    weak var delegate: SwitchButtonDelegate!
    
    override func awakeFromNib() {
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
    }
    
    @IBAction func onTapDown(_ sender: Any) {
        //when a button is tapped, call delegate function
        delegate.onButtonTapped(sender: button)
    }
}
