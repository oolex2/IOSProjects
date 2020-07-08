import XCTest
@testable import Homework_24

final class TestCalculatorOperation: XCTestCase {
    
    func test_givenOperands_whenAdding_thenSuccessful(_ object: CalculatorOperation) {
        
        let operand1 = Operand(component: 10)
        let operand2 = Operand(component: 5)
        
        object.addOperand(operand1)
        object.addOperand(operand2)

        XCTAssertFalse(object.operands.isEmpty)
    }
    
    func test_givenOperands_whenOperationPlus_thenRightResult() {
        
        let object = CalculatorOperation()
        
        test_givenOperands_whenAdding_thenSuccessful(object)
        
        object.prepareForOperation(.plus)
        XCTAssertEqual(object.operationResult(), 15)
    }
    
    func test_givenOperands_whenOperationMinus_thenRightResult() {
        
        let object = CalculatorOperation()
        
        test_givenOperands_whenAdding_thenSuccessful(object)
        
        object.prepareForOperation(.minus)
        XCTAssertEqual(object.operationResult(), 5)
    }
    
    func test_givenOperands_whenOperationMultiply_thenRightResult() {
        
        let object = CalculatorOperation()
        
        test_givenOperands_whenAdding_thenSuccessful(object)
        
        object.prepareForOperation(.multiply)
        XCTAssertEqual(object.operationResult(), 50)
    }

    func test_givenOperands_whenOperationDivide_thenRightResult() {
        
        let object = CalculatorOperation()
        
        test_givenOperands_whenAdding_thenSuccessful(object)
        
        object.prepareForOperation(.divide)
        XCTAssertEqual(object.operationResult(), 2)
        
        let lastOperand = Operand(component: 0)
        object.addOperand(lastOperand)
        object.prepareForOperation(.divide)
        XCTAssertEqual(object.operationResult(), 0)
        
    }
    
    func test_givenOperands_whenOperationNil_thenResultZero() {
        
        let object = CalculatorOperation()
        
        test_givenOperands_whenAdding_thenSuccessful(object)
        
        object.prepareForOperation(nil)
        XCTAssertEqual(object.operationResult(), 0)
    }
    
    func test_givenNoOperands_whenNoOperation_thenResultZero() {
        
        let object = CalculatorOperation()
        
        test_givenOperands_whenAdding_thenSuccessful(object)
        
        object.removeOperands()
        XCTAssertEqual(object.operationResult(), 0)
    }
    
    func test_givenFunction_whenDisplayString_thenEmptyString() {
        
        let object = CalculatorOperation()
        
        XCTAssertEqual(object.displayString(), "")
    }
}
