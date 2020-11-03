//
//  CurrencyConversionModel.swift
//  SimpleSwiftApp
//
//  Created by Chau, Cuong | DCMS on 2020/11/03.
//  Copyright © 2020 Chau, Cuong | DCMS. All rights reserved.
//

import Foundation

class CurrencyConversion {
    
    let API_KEY = "e73214db3330da5a8600da8762c06795"
    let base = "EUR"
    let supportCurrencies = "VND, USD, CAD, AUD, JPY, SGD, EUR"
    var lastFetched: String = "system default"

    var rates: [String: Double] = [
        "USD": 1.162649,
        "CAD": 1.551212,
        "AUD": 1.661876,
        "SGD": 1.589929,
        "EUR": 1,
        "JPY": 121.997931,
        "VND": 26947.291319
    ]
        
    private var _from: String = "EUR"
    var from : String {
        set {
            if self.rates[newValue] != nil {
                _from = newValue
            }
        }
        get {
            return _from
        }
    }

    private var _to: String = "?"
    var to : String {
        set {
            if self.rates[newValue] != nil {
                _to = newValue
            }
        }
        get {
            return _to
        }
    }

    func getCurrentDateTime() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: date)
    }
    
    func retrieveLatestRate(callback: @escaping(String) -> (Void)) {
        let url = "http://data.fixer.io/api/latest?access_key=\(API_KEY)&base=\(base)&symbols=\(supportCurrencies)"
        
        HTTPHandler.getJson(urlStrParam: url, completionHandler: { data in
            if let data = data,
                let jsonData = JSONParser.parse(data: data) {
                
                if let ratesJSDict = jsonData["rates"],
                    let rateDict = ratesJSDict as? Dictionary<String, Double>
                {
                    self.lastFetched = self.getCurrentDateTime()
                    self.rates = rateDict
                }
            }
            callback(self.lastFetched)
            })
    }
    
    func convert(value: Double = 1) -> String {
        if (rates[to] == nil){
            return "0"
        }

        var inter = 1.0;
        
        if from != base,
            let fromRate = rates[from] {
            inter = 1.0 / fromRate
        }
        
        let amount = rates[to]! * inter * value
        return String(format: "%.02f", amount)
    }
}
