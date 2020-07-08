import XCTest
@testable import Homework_24

final class TestCalculatorViewController: XCTestCase {
    
    func test_givenViewController_whenCreating_thenCreated() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard
            .instantiateViewController(withIdentifier: "CalculatorViewController")
        XCTAssertNotNil(viewController)
        
        return viewController
        
    }
    
    func test_givenAllButtons_whenAllTaping_thenTextFieldTextNotNil() {
        
        let viewController = test_givenViewController_whenCreating_thenCreated() as! CalculatorViewController
        
        for i in 0...15 {
            
            let button =  UIButton()
            button.tag = i
            
            viewController.buttonPressed(button)
            
        }
        
        XCTAssertNotNil(viewController.inputTextFiled.text)
    }
    
    func test_givenButtons_whenMinus_thenTextFieldRed() {
        
        let viewController = test_givenViewController_whenCreating_thenCreated() as! CalculatorViewController
        
        let button =  UIButton()
        button.tag = 3
        viewController.buttonPressed(button)
        button.tag = 13
        viewController.buttonPressed(button)
        button.tag = 8
        viewController.buttonPressed(button)
        button.tag = 10
        viewController.buttonPressed(button)
        
        XCTAssertEqual(viewController.inputTextFiled.layer.borderColor, UIColor.red.cgColor)
    }
    
    func test_givenTexField_whenChangingText_thenTextDidChange() {
        
        let viewController = test_givenViewController_whenCreating_thenCreated() as! CalculatorViewController
        
        let textField = UITextField()
        
        textField.text = "20"
        viewController.didChangeText(textField)
        
        if let text = textField.text {
            
            XCTAssertEqual(String(viewController.operand), text)
        }
        
        textField.text = "word"
        viewController.didChangeText(textField)
        XCTAssertEqual(viewController.operand, 0)
    }
}

