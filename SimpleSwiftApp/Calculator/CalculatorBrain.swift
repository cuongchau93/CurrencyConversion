//
//  CalculatorBrain.swift
//  SimpleSwiftApp
//
//  Created by Chau, Cuong | DCMS on 2020/10/29.
//  Copyright © 2020 Chau, Cuong | DCMS. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation {
        case Constant(Double)
        case Unary((Double) -> Double)
        case Binary((Double, Double) -> Double)
        case Equals
    }
    
    private let SupportedOperations: Dictionary<String, Operation> = [
        "π": Operation.Constant(Double.pi),
        "√": Operation.Unary(sqrt),
        "±": Operation.Unary({-$0}),
        "×": Operation.Binary({$0 * $1}),
        "-": Operation.Binary({$0 - $1}),
        "+": Operation.Binary({$0 + $1}),
        "÷": Operation.Binary({$0 / $1}),
        "=": Operation.Equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = SupportedOperations[symbol] {
            switch(operation) {
            case .Constant(let value):
                accumulator = value
                break;
            case .Unary(let function):
                if let operand  = accumulator {
                    accumulator = function(operand)
                }
                break;
            case .Binary(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .Equals:
                performBinaryOperation()
            }
        }
    }
    
    mutating func performBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOp: Double) -> Double {
            return function(firstOperand, secondOp)
        }
    }
            
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
