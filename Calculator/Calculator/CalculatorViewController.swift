//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Dimitar Topalov on 9/12/15.
//  Copyright (c) 2015 Dimitar Topalov. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var operandStack = Array<Double>()
    var displayValue: Double? {
        get {
            if let displayText = display.text {
                if let displayNumber = NSNumberFormatter().numberFromString(displayText)?.doubleValue {
                    return displayNumber
                }
            }
            
            return nil
        }
        
        set {
            display.text = newValue != nil ? "\(newValue)" : "0"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func appendComma() {
        if userIsInTheMiddleOfTypingANumber {
            if (display.text!.rangeOfString(".") == nil) {
                display.text = display.text! + "."
            }
        } else {
            display.text = "0."
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        history.text = history.text! + " \(operation) "
        
        switch (operation) {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π": performOperation { M_PI }
        default: break
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if ((displayValue) != nil) {
            operandStack.append(displayValue!)
            history.text = history.text! + " \(displayValue!) "
        }
    }
    
    @IBAction func clear() {
        operandStack.removeAll()
        display.text = "0"
        history.text = " "
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            if count(display.text!) == 1 || (count(display.text!) == 2 && display.text!.rangeOfString("-") != nil) {
                display.text = "0"
                userIsInTheMiddleOfTypingANumber = false
            } else {
                display.text = dropLast(display.text!)
            }
        }
    }
    
    @IBAction func changeSign() {
        if userIsInTheMiddleOfTypingANumber {
            if display.text!.rangeOfString("-") != nil {
                display.text = dropFirst(display.text!)
            } else {
                display.text = "-\(display.text!)"
            }
        } else {
            performOperation { -($0) }
        }
    }
    
    private func performOperation(operation: () -> Double) {
        displayValue = operation()
        enter()
    }
    
    private func performOperation(operation: (Double) -> Double) {
        if operandStack.count >= 1 {
            history.text = history.text! + "= "
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            history.text = history.text! + "= "
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
}
