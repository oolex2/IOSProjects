import UIKit

typealias DisplayOperationValue = String

final class CalculatorOperation {

  private (set) var operands: [Operand] = []
  private (set) var operation: Operation?

  func addOperand(_ operand: Operand)  {
    
    operands.append(operand)
  }

  func removeOperands() {
        
        operands.removeAll()
  }
    
  func prepareForOperation(_ operation: Operation?) {
    
    self.operation = operation
  }
    
  func operationResult() -> Int {
    
    guard let firstOperand = operands.first else { return 0 }
    let firstOperandValue = firstOperand.component
    guard let secondOperand = operands.last else { return 0 }
    let secondOperandValue = secondOperand.component
    
    switch operation {
        
    case .divide:
        if secondOperandValue == 0 {
            
            return 0
        }
        
        return firstOperandValue / secondOperandValue
        
    case .multiply:
        return firstOperandValue * secondOperandValue
    case .plus:
        return firstOperandValue + secondOperandValue
    case .minus:
        return firstOperandValue - secondOperandValue
    case .none:
        return 0
    }
  }

  func displayString() -> DisplayOperationValue {

    return String.empty
  }
}
