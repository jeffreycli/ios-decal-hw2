//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit


// results that exceed length 7, I tried to account for this in line 116-119
// ask about 4b, 4c


class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var operandA: [String] = []
    var operandB: [String] = []
    var solutionDisplay: [String] = []
    var operationPressed = false
    var operation = ""
    var equalPressed = false
    var useDouble = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func addCharacters(content: String, _ digitArray: [String]) {
        var digitArray = digitArray
        if digitArray.count < 8 {
            digitArray.append(content)
            print(digitArray)
        }
    }
    
    
    func flipSign() {
        if !operationPressed && operandA.contains("-") {
            operandA.remove(at: 0)
            updateOperandResultLabel(operandA)
        } else if !operationPressed {
            operandA.insert("-", at: 0)
            updateOperandResultLabel(operandA)
        }
        
        if operationPressed && operandB.contains("-") {
            operandB.remove(at: 0)
            updateOperandResultLabel(operandB)
        } else if operationPressed {
            operandB.insert("-", at: 0)
            updateOperandResultLabel(operandB)
        }
    }
    
    
    func clear() {
        operandA = []
        operandB = []
    }
    
    func makeStringNumber (_ operand: [String] ) -> String {
        var number = ""
        for digit in operand {
            number = number + digit
        }
        return number
    }
    
    func makeSolutionArray (_ number: String) -> [String] {
        solutionDisplay = number.characters.map {String($0)}
        return solutionDisplay
    }

    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
//        if content.characters.count > 8 {
//            return
//        } else {
//         resultLabel.text = content
//        }
        resultLabel.text = content
    }
    
    func updateOperandResultLabel(_ operand: [String]) {
        var tempArray = operand
        while tempArray.count > 8 {
            tempArray.removeLast()
        }
        updateResultLabel(makeStringNumber(operand))
    }
    
    func decimalPressed(_ operandProvided: [String]) {
        var operand = operandProvided
        print(operand)
        print(operandA)
        print(operandProvided)
        if operand.count < 8 && !operand.contains("."){
            if operand == [] {
                operand.append("0")
            }
            operand.append(".")
            updateOperandResultLabel(operand)
        }
    }
    

    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(a: String, b: String, operation: String) -> String {
        print("Calculation requested for \(a) \(operation) \(b)")
        let x = (a as NSString).doubleValue
        let y = (b as NSString).doubleValue
        var intResult: Int = 0
        var result: Double = 0.0
        var solutionIsInteger = false
        if operation == "+" {
            result = x + y
        } else if operation == "-" {
            result = x - y
        } else if operation == "*" {
            result = x * y
        } else if operation == "/" {
            if y == 0{
                print("Not a number")
            } else {
                result = x / y
            }
        }
        
        solutionIsInteger = (floor(result) == result)
        
        if !solutionIsInteger {
            return String(result)
        } else if solutionIsInteger {
            intResult = Int(result)
            return String(intResult)
        }
        return ""
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil                    else { return }
        print("The number \(sender.content) was pressed")
        // Fill me in!
        
        if !operationPressed && operandA.count < 7 {
            operandA.append(sender.content)
            updateOperandResultLabel(operandA)
        } else if operationPressed && operandB.count < 7 {
            operandB.append(sender.content)
            updateOperandResultLabel(operandB)
        }
        print("OperandA: ", operandA)
        print("OperandB: ", operandB)
        print("operationPressed: ", operationPressed)
        print("operation: ", operation)
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        // Fill me in!
        var argA: String = ""
        var argB: String = ""
        if sender.content == "+/-" {
            flipSign()
        } else if sender.content == "C" {
            clear()
            operationPressed = false
            operation = ""
            updateResultLabel("0")
        } else if operationPressed == true {
            print("operation pressed when numbers were in operands")
            argA = makeStringNumber(operandA)
            argB = makeStringNumber(operandB)
            solutionDisplay = makeSolutionArray(calculate(a: argA, b: argB, operation: operation))
            updateOperandResultLabel(solutionDisplay)
            operandA = solutionDisplay
            operandB = []
        } else if sender.content == "=" && operationPressed == true {
            argA = makeStringNumber(operandA)
            argB = makeStringNumber(operandB)
            solutionDisplay = makeSolutionArray(calculate(a: argA, b: argB, operation: operation))
            operationPressed = false
            updateOperandResultLabel(solutionDisplay)
        }
        
        if ["+", "-", "*", "/"].contains(sender.content) {
            operationPressed = true
            operation = sender.content
        }
        
        print("OperandA: ", operandA)
        print("OperandB: ", operandB)
        print("operationPressed: ", operationPressed)
        print("operation: ", operation)
    }
    
    // REQUIRED: The responder to a number or operator button being pressed. 0 or decimal pressedf
    func buttonPressed(_ sender: CustomButton) {
        if sender.content == "." {
            if !operationPressed {
                if operandA.count < 8 && !operandA.contains("."){
                    if operandA == [] {
                        operandA.append("0")
                    }
                    operandA.append(".")
                    updateOperandResultLabel(operandA)
                }
//                decimalPressed(operandA)
            } else if operationPressed {
                if operandB.count < 8 && !operandB.contains("."){
                    if operandB == [] {
                        operandB.append("0")
                    }
                    operandB.append(".")
                    updateOperandResultLabel(operandB)
                }
//                decimalPressed(operandB)
            }
        } else if sender.content == "0" {
            if !operationPressed {
                if operandA != [] {
                    operandA.append("0")
                    updateOperandResultLabel(operandA)
                }
            } else if operationPressed {
                if operandB != [] {
                    operandB.append("0")
                    updateOperandResultLabel(operandB)
                }
            }
        }
        
        print("OperandA: ", operandA)
        print("OperandB: ", operandB)
        print("operationPressed: ", operationPressed)
        print("operation: ", operation)
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

