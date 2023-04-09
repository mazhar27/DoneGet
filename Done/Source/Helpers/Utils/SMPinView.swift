//
//  SMPinView.swift
//  Done
//
//  Created by Mazhar Hussain on 02/06/2022.
//

import Foundation
import UIKit

protocol SMPin {}
protocol SMPinTextFieldDeleteDelegate: AnyObject {
    func textFieldDidDelete(smPinTextField: SMPinTextField)
}
protocol SMPinViewDelegate: AnyObject {
    func textFieldIsTyping(smPinTextField: SMPinTextField)
}

/** Pin styled textfield. You can add additional feature if you want. */
class SMPinTextField: UITextField, SMPin {
    weak var deleteDelegate: SMPinTextFieldDeleteDelegate?
    
    override func deleteBackward() {
        let currentText = self.text
        super.deleteBackward()
        
        self.text = currentText
        deleteDelegate?.textFieldDidDelete(smPinTextField: self)
    }
}

class SMPinButton: UIButton, SMPin {}

/**
 1. Create UIView in storyboard.
 2. Assign **SMPinView** to it.
 3. Now add textfields as much you want for your app.
 4. Order you textfields in ascending order and assign tags from **Attribute Inspector**.
 5. Get your value with `getPinViewText()` method.
 6. That's it. 👍
 */
class SMPinView: UIView, UITextFieldDelegate {
    
    //MARK:- Properties
    
    fileprivate var smPinTextFields: [SMPinTextField]?
    weak var delegate: SMPinViewDelegate?
    @IBInspectable public var fontSize: CGFloat = 30
    
    
    //MARK:- Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.semanticContentAttribute = .forceLeftToRight
        //setNecessaryDelegate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.semanticContentAttribute = .forceLeftToRight
        //setNecessaryDelegate()
    }
    
    
    
    //MARK:- Overrides
    
    override public func layoutSubviews() {
        /*  User can update */
        self.semanticContentAttribute = .forceLeftToRight
        setNecessaryDelegate()
        
        super.layoutSubviews()
    }
    
    
    
    //MARK:- Private Helper Methods
    
    private func setNecessaryDelegate() {
        let pinTFs = self.subviews.compactMap{$0 as? SMPin}
        pinTFs.forEach {
            if let smPinTF = $0 as? SMPinTextField {
//                smPinTF.tintColor = .gray
                smPinTF.delegate = self
                smPinTF.deleteDelegate = self
                smPinTF.textAlignment = .center
                smPinTF.font = UIFont.systemFont(ofSize: self.fontSize)
                smPinTF.keyboardType = .asciiCapableNumberPad
                if #available(iOS 12.0, *) {
                    smPinTF.textContentType = .oneTimeCode
                } else {
                    // Fallback on earlier versions
                }
                smPinTF.addTarget(self, action: #selector(pinTFChanged), for: .editingChanged)
                smPinTF.addTarget(self, action: #selector(pinTFChanged1), for: .editingDidEnd)
            }else if let smPinButton = $0 as? SMPinButton {
                smPinButton.addTarget(self, action: #selector(smPinButtonHandler), for: .touchUpInside)
            }
        }
        smPinTextFields = pinTFs.compactMap{$0 as? SMPinTextField}
    }
    
    @objc private func pinTFChanged(sender: SMPinTextField) {
        guard let smPinTFs = smPinTextFields else {return}
        let textCount = Int(sender.text?.count ?? 0)
       
        if textCount >= 1 {
            /*
             *  Was empty text and user has typed something.
             *  so, goto next text fields
             */
            sender.borderColor = UIColor.blueThemeColor
            let lastCharacter = (sender.text ?? "").last ?? " "
            sender.text = String(lastCharacter)
            
            
            if sender.tag >= smPinTFs.count {
                /*
                 *  index over flow
                 */
                sender.resignFirstResponder()
            }else{
                smPinTFs[sender.tag].becomeFirstResponder()
            }
        }else{
            /*
             *  Backspace clicked on middle
             */
            sender.borderColor = UIColor.lightGrayThemeColor
        }
        
        delegate?.textFieldIsTyping(smPinTextField: sender)
    }
    
    /**
     *  SMPinButton click handler
     *  Basically it is backspace button
     */
    @objc private func smPinButtonHandler(sender: SMPinButton) {
        guard let smPinTFs = smPinTextFields else {return}
        if let activeTF = getActiveTextField() {
            activeTF.deleteBackward()
        }else{
            smPinTFs.last?.text = ""
            smPinTFs.last?.becomeFirstResponder()
        }
    }
    
    @objc private func pinTFChanged1(sender: SMPinTextField) {
        guard smPinTextFields != nil else {return}
        let textCount = Int(sender.text?.count ?? 0)
        if textCount == 0 {
            sender.borderColor = UIColor.init(hexString: "#ACACAC")
        }
    }
    
    
    
    
    
    
    //MARK:- Public Helper Methods
    
    /**
     *  Returns string of current text fields
     */
    func getPinViewText() -> String {
        guard let pinTFs = smPinTextFields else {return ""}
        let value = pinTFs.reduce("", {$0 + ($1.text ?? "")})
        return value
    }
    
    /**
     *  Return if all text fields are filled or not.
     */
    func isAllTextFieldTyped() -> Bool {
        guard let pinTFs = smPinTextFields else {return false}
        let filledValues = pinTFs.filter{!($0.text?.isEmpty ?? true)}
        return filledValues.count == pinTFs.count
    }
    
    /**
     *  Makes first SMPinTextField first responder.
     */
    func makeFirstTextFieldResponder() {
        smPinTextFields?.first?.becomeFirstResponder()
    }
    
    /**
     *  Ends all responder.
     */
    func resignAllResponder() {
        self.endEditing(true)
    }
    
    /**
     *  Clear all textFields
     */
    func clearAllText() {
        smPinTextFields?.forEach{ $0.text = ""}
    }
    
    /**
     *  Get active SMPinTextTield
     */
    func getActiveTextField() -> SMPinTextField? {
        return smPinTextFields?.filter{$0.isFirstResponder}.first
    }
    
}

extension SMPinView: SMPinTextFieldDeleteDelegate {
    func textFieldDidDelete(smPinTextField: SMPinTextField) {
        guard let smPinTFs = smPinTextFields else {return}
        
        /*  Previous  */
        let previousTag = smPinTextField.tag - 2
        let previousIndex = previousTag<0 ? 0 : previousTag
        /*  let previousText = Int(smPinTFs[previousIndex].text ?? "0") ?? 0  */
        
        /*  Current  */
        let currentIndex = smPinTextField.tag - 1
        let currentText = Int(smPinTFs[currentIndex].text ?? "0") ?? 0
        
        if currentText > 0 {
            /*
             *  There is text in this textfield. So only need to clear
             */
            smPinTFs[currentIndex].text = ""
        }else{
            /*
             *  Means, the text count is zero and need to send back to previous textfield
             */
            smPinTFs[previousIndex].becomeFirstResponder()
            smPinTFs[previousIndex].text = ""
            smPinTFs[currentIndex].text = ""
        }
        
        delegate?.textFieldIsTyping(smPinTextField: smPinTextField)
    }
    
}

