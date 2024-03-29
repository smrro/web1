//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 송은규 on 2023/06/26.
//

import Foundation

class CalculatorBrain {
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(Double.pi),
        "e" : Operation.Constant(M_E),
        "™️": Operation.UnaryOperation({-$0}),
        "⎷" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "✖️" : Operation.BinaryOperation({$0 * $1}),
        "➗" : Operation.BinaryOperation({$0 / $1}),
        "➕" : Operation.BinaryOperation({$0 + $1}),
        "➖" : Operation.BinaryOperation({$0 - $1}),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let foo):
                accumulator = foo(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
                }
            }
        }
    
        private func executePendingBinaryOperation()
        {
            if pending != nil {
                accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
                pending = nil
            }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram as AnyObject
        } set {
            clear()
            if let  arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operaion = op as? String {
                        performOperation(symbol: Operation)
                    }
                }
            }
        }
    }
    
    var clear {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
