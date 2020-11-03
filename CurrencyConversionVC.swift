//
//  CurrencyConversionVC.swift
//  SimpleSwiftApp
//
//  Created by Chau, Cuong | DCMS on 2020/11/02.
//  Copyright © 2020 Chau, Cuong | DCMS. All rights reserved.
//

import UIKit

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }
    
    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
}

class CurrencyConversionVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var fromCurrency: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var toCurrency: UIButton!
    @IBOutlet weak var fromInput: UITextField!
    @IBOutlet weak var toInput: UITextField!
    @IBOutlet weak var lastFetchedLabel: UILabel!

    var isFrom: Bool = false
    var isTo: Bool = false
    var pickerData: [String] = [String]()
    var focusedInput: UITextField? = nil
    let trailingSymbol = "🔽"
    
    var conversionBrain = CurrencyConversion()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        conversionBrain.retrieveLatestRate(callback: { lastFetch in
            DispatchQueue.main.async {
                self.lastFetchedLabel.text = "Last fetched: \(lastFetch)"
            }
        })
//        self.lastFetchedLabel.text = "Last fetched: \(conversionBrain.lastFetched)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        picker.delegate = self
        picker.dataSource = self
        
        pickerData = Array(conversionBrain.rates.keys).sorted()
        
        picker.isHidden = true
        toInput.isEnabled = false
        focusedInput = fromInput
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.picker.isHidden = true
        
        let selectedCurrency = self.pickerData[row]
        
        if isTo {
            conversionBrain.to = selectedCurrency
            self.toCurrency.setTitle(selectedCurrency + trailingSymbol, for: .normal)
        } else {
            conversionBrain.from = selectedCurrency
            self.fromCurrency.setTitle(selectedCurrency + trailingSymbol, for: .normal)
        }
        
        if focusedInput == fromInput {
            self.toInput.text = conversionBrain.convert()
        } else {
            self.fromInput.text = conversionBrain.convert()
        }
        
        print (conversionBrain.convert())
        
    }
    
    func getFromCurrency () -> String {
        if let fromSymbol = fromCurrency.currentTitle?[0..<3] {
            return fromSymbol
        }
        return ""
    }
    
    func getToCurrency () -> String {
        if let toSymbol = toCurrency.currentTitle?[0..<3] {
            return toSymbol
        }
        return ""
    }
    
    @IBAction func onCurrencyButtonClicked(_ sender: UIButton) {
        
        if  sender == toCurrency {
            isTo = true
            isFrom = false
            toInput.isEnabled = true
        } else if sender == fromCurrency {
            isTo = false
            isFrom = true
            fromInput.isEnabled = true
        }
        
        if self.picker.isHidden {
            self.picker.isHidden = false
        }
    }
    
    @IBAction func inputChanged(_ sender: UITextField) {

        if let text = sender.text,
            let value = Double(text){
            if sender == fromInput {
                focusedInput = fromInput
                toInput.text = conversionBrain.convert(value: value)
            } else if sender == toInput {
                focusedInput = toInput
                fromInput.text = conversionBrain.convert(value: value)
            }
        }
    }

    
    @IBAction func inputFocused(_ sender: UITextField) {
        if sender == fromInput {
            fromInput.text = "1.0"
            
            conversionBrain.to = getToCurrency()
            conversionBrain.from = getFromCurrency()
            
            toInput.text = conversionBrain.convert()
            
            focusedInput = fromInput
   
        } else if sender == toInput {
            toInput.text = "1.0"
            
            conversionBrain.to = getFromCurrency()
            conversionBrain.from = getToCurrency()
            
            fromInput.text = conversionBrain.convert()
            
            focusedInput = toInput
          
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return pickerData[row]
    }
}
