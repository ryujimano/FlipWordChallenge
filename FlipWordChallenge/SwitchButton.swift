//
//  SwitchButton.swift
//  FlipWordChallenge
//
//  Created by Ryuji Mano on 4/4/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class SwitchButton: NSObject {
    
    //boolean value for each button
    var onOff: Bool = true
    
    //dictionary of buttons associated to this button
    var switchButtons: [Int : SwitchButton]!

}
