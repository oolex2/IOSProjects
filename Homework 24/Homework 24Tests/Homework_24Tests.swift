import XCTest
@testable import Homework_24

final class Tests: XCTestCase {
    
    //MARK: - Tesing CalculatorOperation
    
//    func test_givenOperands_whenAdding_thenSuccessful(_ object: CalculatorOperation) {
//        
//        let operand1 = Operand(component: 10)
//        let operand2 = Operand(component: 5)
//        
//        object.addOperand(operand1)
//        object.addOperand(operand2)
//
//        XCTAssertFalse(object.operands.isEmpty)
//    }
//    
//    func test_givenOperands_whenOperationPlus_thenRightResult() {
//        
//        let object = CalculatorOperation()
//        
//        test_givenOperands_whenAdding_thenSuccessful(object)
//        
//        object.prepareForOperation(.plus)
//        XCTAssertEqual(object.operationResult(), 15)
//    }
//    
//    func test_givenOperands_whenOperationMinus_thenRightResult() {
//        
//        let object = CalculatorOperation()
//        
//        test_givenOperands_whenAdding_thenSuccessful(object)
//        
//        object.prepareForOperation(.minus)
//        XCTAssertEqual(object.operationResult(), 5)
//    }
//    
//    func test_givenOperands_whenOperationMultiply_thenRightResult() {
//        
//        let object = CalculatorOperation()
//        
//        test_givenOperands_whenAdding_thenSuccessful(object)
//        
//        object.prepareForOperation(.multiply)
//        XCTAssertEqual(object.operationResult(), 50)
//    }
//
//    func test_givenOperands_whenOperationDivide_thenRightResult() {
//        
//        let object = CalculatorOperation()
//        
//        test_givenOperands_whenAdding_thenSuccessful(object)
//        
//        object.prepareForOperation(.divide)
//        XCTAssertEqual(object.operationResult(), 2)
//        
//        let lastOperand = Operand(component: 0)
//        object.addOperand(lastOperand)
//        object.prepareForOperation(.divide)
//        XCTAssertEqual(object.operationResult(), 0)
//        
//    }
//    
//    func test_givenOperands_whenOperationNil_thenResultZero() {
//        
//        let object = CalculatorOperation()
//        
//        test_givenOperands_whenAdding_thenSuccessful(object)
//        
//        object.prepareForOperation(nil)
//        XCTAssertEqual(object.operationResult(), 0)
//    }
//    
//    func test_givenNoOperands_whenNoOperation_thenResultZero() {
//        
//        let object = CalculatorOperation()
//        
//        test_givenOperands_whenAdding_thenSuccessful(object)
//        
//        object.removeOperands()
//        XCTAssertEqual(object.operationResult(), 0)
//    }
//    
//    func test_givenFunction_whenDisplayString_thenEmptyString() {
//        
//        let object = CalculatorOperation()
//        
//        XCTAssertEqual(object.displayString(), "")
//    }
//
    
    //MARK: - Testing InputCode
    
    func test_givenObject_whenOperationNil_thenNil() {
        
        let inputCode = InputCode(rawValue: 5)
        
        let currentOperation = inputCode?.operation
        XCTAssertEqual(currentOperation, nil)
    }

    //MARK: - Testing CalculatorViewController
    
//    func test_givenViewController_whenCreating_thenCreated() -> UIViewController {
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard
//            .instantiateViewController(withIdentifier: "CalculatorViewController")
//        XCTAssertNotNil(viewController)
//
//        return viewController
//
//    }
//
//    func test_givenAllButtons_whenAllTaping_thenTextFieldTextNotNil() {
//
//        let viewController = test_givenViewController_whenCreating_thenCreated() as! CalculatorViewController
//
//        for i in 0...15 {
//
//        let button =  UIButton()
//        button.tag = i
//
//        viewController.buttonPressed(button)
//
//        }
//
//        XCTAssertNotNil(viewController.inputTextFiled.text)
//    }
//
//    func test_givenButtons_whenMinus_thenTextFieldRed() {
//
//        let viewController = test_givenViewController_whenCreating_thenCreated() as! CalculatorViewController
//
//        let button =  UIButton()
//        button.tag = 3
//        viewController.buttonPressed(button)
//        button.tag = 13
//        viewController.buttonPressed(button)
//        button.tag = 8
//        viewController.buttonPressed(button)
//        button.tag = 10
//        viewController.buttonPressed(button)
//
//        XCTAssertEqual(viewController.inputTextFiled.layer.borderColor, UIColor.red.cgColor)
//    }
//
//    func test_givenTexField_whenChangingText_thenTextDidChange() {
//
//        let viewController = test_givenViewController_whenCreating_thenCreated() as! CalculatorViewController
//
//        let textField = UITextField()
//
//        textField.text = "20"
//        viewController.didChangeText(textField)
//
//        if let text = textField.text {
//
//            XCTAssertEqual(String(viewController.operand), text)
//        }
//
//        textField.text = "word"
//        viewController.didChangeText(textField)
//        XCTAssertEqual(viewController.operand, 0)
//    }
//}
