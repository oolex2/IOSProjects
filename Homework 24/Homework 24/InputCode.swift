import UIKit

enum InputCode: Int, CaseIterable {
    
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ok
    case clear
    case plus
    case minus
    case multiply
    case divide
    
    var isNumber: Bool {
        
        switch self {
            
        case .zero,
             .one,
             .two,
             .three,
             .four,
             .five,
             .six,
             .seven,
             .eight,
             .nine:
            return true
            
        default:
            return false
        }
    }
    
    var isOperation: Bool {
        
        switch self {
            
        case .plus,
             .minus,
             .multiply,
             .divide:
            return true
            
        default:
            return false
        }
    }
    
    var isControlInput: Bool {
        
        switch self {
            
        case .ok,
             .clear,
             .plus,
             .minus,
             .multiply,
             .divide:
            return true
            
        default:
            return false
        }
    }
    
    var isConfirmButton: Bool {
        
        return self == .ok
    }
    
    var operation: Operation? {
        
        switch self {
            
        case .plus:
            return Operation.plus
        case .minus:
            return Operation.minus
        case .multiply:
            return Operation.multiply
        case .divide:
            return Operation.divide
            
        default:
            return nil
        }
    }
    
    var title: String {
        
        switch self {
            
        case .zero:
            return NSLocalizedString("zero", comment: "zero")
        case .one:
            return NSLocalizedString("one", comment: "one")
        case .two:
            return NSLocalizedString("two", comment: "two")
        case .three:
            return NSLocalizedString("three", comment: "three")
        case .four:
            return NSLocalizedString("four", comment: "four")
        case .five:
            return NSLocalizedString("five", comment: "five")
        case .six:
            return NSLocalizedString("six", comment: "six")
        case .seven:
            return NSLocalizedString("seven", comment: "seven")
        case .eight:
            return NSLocalizedString("eight", comment: "eight")
        case .nine:
            return NSLocalizedString("nine", comment: "nine")
        case .ok:
            return NSLocalizedString("ok", comment: "ok")
        case .clear:
            return NSLocalizedString("clear", comment: "clear")
        case .plus:
            return NSLocalizedString("plus", comment: "plus")
        case .minus:
            return NSLocalizedString("minus", comment: "minus")
        case .multiply:
            return NSLocalizedString("multiply", comment: "multiply")
        case .divide:
            return NSLocalizedString("divide", comment: "divide")
        }
    }
}
