//
//  ViewController.swift
//  SimpleSwiftApp
//
//  Created by Chau, Cuong | DCMS on 2020/10/28.
//  Copyright © 2020 Chau, Cuong | DCMS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var display: UILabel!
    
    var isUserTyping = false;
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!;
        
        if isUserTyping {
            let textInDisplay = display.text!;
            display.text = textInDisplay + digit;
        } else {
            display.text = digit;
            isUserTyping = true;
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if isUserTyping {
            brain.setOperand(displayValue);
            isUserTyping = false
        }
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
}

