//
//  GameStartViewController.swift
//  FlipWordChallenge
//
//  Created by Ryuji Mano on 4/4/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class GameStartViewController: UIViewController {
    
    var buttonAmount: Int = 4
    var possibleAssociatedAmount: Int = 4
    var associatedAmount: Int = 1
    
    @IBOutlet weak var buttonAmountLabel: UILabel!
    @IBOutlet weak var associatedAmountLabel: UILabel!
    
    @IBOutlet weak var buttonSlider: UISlider!
    @IBOutlet weak var associatedSlider: UISlider!

    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        startButton.layer.cornerRadius = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonSlider.value = 0
        associatedSlider.value = 0
        
        possibleAssociatedAmount = (buttonAmount / 2) - 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButtonSlider(_ sender: Any) {
        let slider = sender as! UISlider
        
        let value = slider.value * 5
        let intValue = Int(value)
        
        let diff = (value).subtracting(Float(intValue))
        var val = Float(diff > 0.5 ? Float(intValue + 1) : Float(intValue))
        val.divide(by: 5.0)
        
        if -0.1 > val - slider.value {
            val = val - 0.2
        }
        else if val - slider.value > 0.1  {
            val = val + 0.2
        }
        slider.setValue(val, animated: false)
        
        buttonAmount = Int(val * 5) + 4
        buttonAmountLabel.text = "\(buttonAmount)"
        
        possibleAssociatedAmount = (buttonAmount / 2) - 1
    }
    
    @IBAction func onAssociatedSlider(_ sender: Any) {
        let slider = sender as! UISlider
        
        let value = slider.value * Float(possibleAssociatedAmount)
        let intValue = Int(value)
        
        let diff = (value).subtracting(Float(intValue))
        var val = Float(diff > 0.5 ? Float(intValue + 1) : Float(intValue))
        val.divide(by: Float(possibleAssociatedAmount))
        
        let div = Float(1.0).divided(by: Float(possibleAssociatedAmount))
        
        if -(div / 2) > val - slider.value {
            val = val - div
        }
        else if val - slider.value > (div / 2)  {
            val = val + div
        }
        slider.setValue(val, animated: false)
        
        associatedAmount = Int(val * Float(possibleAssociatedAmount)) + 1
        associatedAmountLabel.text = "\(associatedAmount)"
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! GameViewController
        destination.cellCount = buttonAmount
        destination.associatedCount = associatedAmount
    }

}
