//
//  ViewController.swift
//  Convert
//
//  Created by Ibrahim Idris on 22/08/2018.
//  Copyright © 2018 Ibrahim Idris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var quantityButton: UIButton!
    @IBOutlet weak var fromUnitButton: UIButton!
    @IBOutlet weak var toUnitButton: UIButton!
    @IBOutlet weak var calculationTextField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    
    var selectedQuantity = 0
    var selectedUnits = lengthTitles
    var unitTable = length_table
    var fromUnitIndex = 0
    var toUnitIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitles()
        
    }
    
    func setTitles() {
        quantityButton.setTitle(quantityTitles[selectedQuantity], for: .normal)
        fromUnitButton.setTitle(selectedUnits[fromUnitIndex], for: .normal)
        toUnitButton.setTitle(selectedUnits[toUnitIndex], for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SelectionViewController
        destinationVC.delegate = self
        if segue.identifier == "quantitySegue" {
            destinationVC.data = quantityTitles
            destinationVC.typeOfSelection = "quantity"
            destinationVC.title = "Select Quantity"
        } else {
            destinationVC.data = selectedUnits
            destinationVC.typeOfSelection = "unit"
            destinationVC.title = "Select Unit"
            if segue.identifier == "fromSegue" {
                destinationVC.whichUnit = "from"
            } else if segue.identifier == "toSegue" {
                destinationVC.whichUnit = "to"
            }
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        calculationTextField.endEditing(true)
    }
    
    @IBAction func performCalculation(_ sender: UITextField) {
        
        if calculationTextField.text != nil {
            
            //TODO:- Figure out what units to calculate for
            
            let calcValue = Double(calculationTextField.text!)
            
            if let valueEntered = calcValue {
                if fromUnitIndex == toUnitIndex {
                    answerLabel.text = calculationTextField.text
                } else {
                    // TODO: Perform calculation here
                    var newValue = valueEntered * (unitTable[fromUnitIndex][toUnitIndex])
                    newValue = Double(newValue).rounded(toPlaces: 3)
                    answerLabel.text = String(newValue)
                    copyButton.isHidden = false
                }
            }
            
        }
        
    }
    
    @IBAction func copyButtonPressed(_ sender: UIButton) {
        UIPasteboard.general.string = answerLabel.text
    }
    
    func resetInputs() {
        calculationTextField.text = ""
        answerLabel.text = "0.0"
        copyButton.isHidden = true
    }
    
}

extension ViewController: DidSelectOption {
    
    func selected(quantity: Int) {
        selectedQuantity = quantity
        selectedUnits = unitTitles[selectedQuantity]
        unitTable = quantityTables[selectedQuantity]
        fromUnitIndex = 0
        toUnitIndex = 1
        resetInputs()
        setTitles()
    }
    
    func selected(unit: Int, whichUnit: String) {
        resetInputs()
        if whichUnit == "from" {
            fromUnitIndex = unit
            fromUnitButton.setTitle(selectedUnits[fromUnitIndex], for: .normal)
        } else {
            toUnitIndex = unit
            toUnitButton.setTitle(selectedUnits[toUnitIndex], for: .normal)
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (range.location == 0 && string.count == 0) {
            answerLabel.text = "0.0"
            copyButton.isHidden = true
        }
        
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        if filtered == string {
            return true
        } else {
            if string == "." {
                let countdots = textField.text!.components(separatedBy:".").count - 1
                if countdots == 0 {
                    return true
                } else {
                    if countdots > 0 && string == "." {
                        return false
                    } else {
                        return true
                    }
                }
            } else {
                return false
            }
        }
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
