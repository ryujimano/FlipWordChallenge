//
//  ButtonCollectionViewCell.swift
//  FlipWordChallenge
//
//  Created by Ryuji Mano on 4/4/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

protocol SwitchButtonDelegate: class {
    func onButtonTapped(sender: SwitchButton)
}

class ButtonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var button: SwitchButton!
    weak var delegate: SwitchButtonDelegate!
    
    override func awakeFromNib() {
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
    }
    
    
    @IBAction func onTap(_ sender: Any) {
    }
    
    @IBAction func onTapDown(_ sender: Any) {
        delegate.onButtonTapped(sender: button)
    }
}
