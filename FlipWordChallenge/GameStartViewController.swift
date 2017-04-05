//
//  GameStartViewController.swift
//  FlipWordChallenge
//
//  Created by Ryuji Mano on 4/4/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class GameStartViewController: UIViewController {
    
    //amount of buttons
    var buttonAmount: Int = 4
    
    //possible amount of associated buttons
    var possibleAssociatedAmount: Int = 4
    //amount of associated buttons for each button
    var associatedAmount: Int = 1
    
    @IBOutlet weak var buttonAmountLabel: UILabel!
    @IBOutlet weak var associatedAmountLabel: UILabel!
    
    @IBOutlet weak var buttonSlider: UISlider!
    @IBOutlet weak var associatedSlider: UISlider!

    @IBOutlet weak var startButton: UIButton!
    
    
    //MARK: View Setup
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        startButton.layer.cornerRadius = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set the sliders' values to the initial value
        buttonSlider.value = 0
        associatedSlider.value = 0
        
        //constrain the possible amount of associated buttons allowed
        possibleAssociatedAmount = (buttonAmount / 2) - 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: ButtonSlider Action
    @IBAction func onButtonSlider(_ sender: Any) {
        let slider = sender as! UISlider
        
        let value = slider.value * 5
        let intValue = Int(value)
        
        let diff = (value).subtracting(Float(intValue))
        var val = Float(diff > 0.5 ? Float(intValue + 1) : Float(intValue))
        val.divide(by: 5.0)
        
        //"stick" the slider to "nice" values at calculated positions
        if -0.1 > val - slider.value {
            val = val - 0.2
        }
        else if val - slider.value > 0.1  {
            val = val + 0.2
        }
        slider.setValue(val, animated: false)
        
        
        //set the amount of buttons from user input
        buttonAmount = Int(val * 5) + 4
        buttonAmountLabel.text = "\(buttonAmount)"
        
        //constrain the possible amount of associated buttons allowed
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
        
        //"stick" the slider to "nice" values at calculated positions
        if -(div / 2) > val - slider.value {
            val = val - div
        }
        else if val - slider.value > (div / 2)  {
            val = val + div
        }
        slider.setValue(val, animated: false)
        
        //set the amount of associated buttons from user input
        associatedAmount = Int(val * Float(possibleAssociatedAmount)) + 1
        associatedAmountLabel.text = "\(associatedAmount)"
    }

    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! GameViewController
        
        //set the button amount and associated button amount in the GameViewController
        destination.cellCount = buttonAmount
        destination.associatedCount = associatedAmount
    }

}
