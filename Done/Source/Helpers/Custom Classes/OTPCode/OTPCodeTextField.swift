//
//  OTPCodeTextField.swift
//  Done
//
//  Created by Mazhar Hussain on 6/17/22.
//

import Foundation

class OTPCodeTextField: UITextField {
    
    var didEnterLastDigit: ((String) -> Void)?
    
    var defaultCharacter = "-"
    
    private var isConfigured = false
    
    private var digitLabels = [UILabel]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    func configure(with slotCount: Int = 4) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: slotCount)
        self.semanticContentAttribute = .forceLeftToRight

        addSubview(labelsStackView)
        
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
    }

    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    
    private func createLabelsStackView(with count: Int, _ font: UIFont = UIFont.Poppins(.semibold, size: 40), _ fontColor: UIColor = UIColor.buttonThemeColor) -> UIStackView {
        let stackView = UIStackView()
        stackView.semanticContentAttribute = .forceLeftToRight
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        for _ in 1 ... count {
            let label = UILabel()
            label.semanticContentAttribute = .forceLeftToRight
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = font
            label.isUserInteractionEnabled = true
            label.text = defaultCharacter
            label.textColor = fontColor
            label.layer.borderWidth = 1
            label.layer.borderColor =  UIColor(hexString: "ACACAC").cgColor
            label.layer.cornerRadius = 5
            if defaultCharacter == "*"{
                label.textColor = UIColor.lightGrayThemeColor
            }
            
            stackView.addArrangedSubview(label)
            digitLabels.append(label)
        }
        
        return stackView
    }
    
    @objc
    private func textDidChange() {
        
        guard let text = self.text, text.count <= digitLabels.count else { return }
        print("text \(text) :: \(digitLabels.count)")
        
        for i in (0 ..< digitLabels.count).reversed() {
            print("loop index \(i)")
            let currentLabel = digitLabels[i]
            
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                print("text index  \(index)")
                currentLabel.text = String(text[index])
                setLabelBorder(currentLabel, "007DC6")
            } else {
                currentLabel.text = defaultCharacter
                setLabelBorder(currentLabel, "ACACAC")
            }
        }
        didEnterLastDigit?(text)
        
//        if text.count == digitLabels.count {
//            didEnterLastDigit?(text)
//        }
//        if text.count == 0{
//            didEnterLastDigit?(text)
//        }
    }
    
    private func setLabelBorder(_ label: UILabel, _ borderColor: String) {
        label.layer.borderColor =  UIColor(hexString: borderColor).cgColor
    }
}

extension OTPCodeTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters =
            CharacterSet(charactersIn: "0123456789").inverted
        
        if  (string.rangeOfCharacter(from: invalidCharacters) == nil) {
            guard let characterCount = textField.text?.count else { return false }
            return characterCount < digitLabels.count || string == ""
        }
        return false
    }
}
