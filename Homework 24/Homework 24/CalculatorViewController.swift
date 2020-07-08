import UIKit

final class CalculatorViewController: UIViewController {
    
    @IBOutlet public var inputTextFiled: UITextField! = UITextField()
    @IBOutlet private var buttons: [UIButton]!
    @IBOutlet private var okButtonTaped: UIButton! = UIButton()
    
    private let calculatorOperation = CalculatorOperation()
    public var operand = 0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAppearence()
        view.isAccessibilityElement = true
    }
    
    // MARK: - Actions
    
    @IBAction public func buttonPressed(_ sender: UIButton) {
        
        let currentButtonTag = sender.tag
        
        if let input = InputCode(rawValue: currentButtonTag) {
            
            if input.isNumber {
                
                configureNumbers(currentButtonTag: currentButtonTag)
            }
            
            if  input.isOperation {
                
                configureOperation(input: input)
            }
            
            if input.isConfirmButton {
                
                configureConfirmButton()
            }
            
            if input == .clear {
                
                configureClearButton()
            }
        }
    }
    
    @IBAction public func didChangeText(_ sender: UITextField) {
        
        if let inputText = sender.text {
            
            operand = Int(inputText) ?? 0
        }
    }
    
    // MARK: - Private
    
    private func configureNumbers(currentButtonTag: Int) {
        
        if operand != .zero {
            
            if  operand < Int.max / 10 - 10 {
                
                operand = operand * 10 + currentButtonTag
            }
        } else {
            
            operand = currentButtonTag
        }
        
        inputTextFiled.text = "\(operand)"
    }
    
    private func configureOperation(input: InputCode) {

        calculatorOperation.addOperand(Operand(component: operand))

        operand = 0
        
        if let operation = input.operation {
            
            calculatorOperation.prepareForOperation(operation)
        }
        okButtonTaped.isUserInteractionEnabled = true
    }
    
    private func configureConfirmButton() {
        
        calculatorOperation.addOperand(Operand(component: operand))
        
        if calculatorOperation.operationResult() != 0 {
            
            inputTextFiled.text = calculatorOperation.operationResult().description
            
        }
        
        operand = calculatorOperation.operationResult()
        configureTextFild()
        
        calculatorOperation.removeOperands()
        
        okButtonTaped.isUserInteractionEnabled = false
    }
    
    private func configureTextFild() {
        
        inputTextFiled.layer.borderWidth = 2
        
        if calculatorOperation.operationResult() < 0 {
            
            inputTextFiled.layer.borderColor = UIColor.red.cgColor
        } else {
            
            inputTextFiled.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    private func configureClearButton() {
        
        inputTextFiled.text = calculatorOperation.displayString()
        operand = .zero
        calculatorOperation.removeOperands()
    }
    
    //MARK: - StyleAppearance
    
    private func styleAppearence() {
        
        buttons.forEach {
            (button) in
            
            let tag = button.tag
            if let inputCodeTypeInst = InputCode(rawValue: tag) {
                
                button.setTitle(inputCodeTypeInst.title, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.setTitleColor(.black, for: .selected)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
                
                button.backgroundColor = .lightGray
                button.layer.cornerRadius = 3
                if inputCodeTypeInst.isControlInput {
                    
                    button.backgroundColor = .darkGray
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
                }
                
                if inputCodeTypeInst.isConfirmButton {
                    
                    button.backgroundColor = .orange
                }
            }
        }
    }
}
