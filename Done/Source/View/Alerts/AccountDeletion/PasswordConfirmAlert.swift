//
//  PasswordConfirmAlert.swift
//  Do-ne
//
//  Created by Mazhar Hussain on 19/05/2022.
//  Copyright © 2022 Dtech. All rights reserved.
//

import UIKit
import Localize_Swift

protocol deleteAccountDelegate: AnyObject {
    func deleteAcc(password: String)
}
class PasswordConfirmAlert: UIView, UITextFieldDelegate{
    
    
    @IBOutlet weak var codeTextField: OTPCodeTextField!
    
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var backBt: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var OTPCode = ""
    weak var delegate: deleteAccountDelegate?
    let mainString = "By Verifying Password, this account will no longer be available. All data including wallet in the account will be permanently deleted. You can register yourself as a New user again using your previous number"
    let mainStringArabic = "من خلال التحقق من كلمة المرور ، لن يكون هذا الحساب متاحًا بعد الآن. سيتم حذف جميع البيانات بما في ذلك المحفظة في الحساب نهائيًا. يمكنك تسجيل نفسك كمستخدم جديد مرة أخرى باستخدام رقمك السابق"
    let stringToColor = "no longer be available"
    let stringToColorAr = "متاحًا بعد الآن"
    
    func setupView(){
        
        var range = (mainString as NSString).range(of: stringToColor)
        var range2 = (mainString as NSString).range(of: "permanently deleted")
        var mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "#017DC5"), range: range)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "#017DC5"), range: range2)
        descLbl.attributedText = mutableAttributedString
        if Localize.currentLanguage() == "ar"{
            range = (mainStringArabic as NSString).range(of: stringToColorAr)
            range2 = (mainStringArabic as NSString).range(of: "الحساب نهائيًا")
            mutableAttributedString = NSMutableAttributedString.init(string: mainStringArabic)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "#017DC5"), range: range)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "#017DC5"), range: range2)
            descLbl.attributedText = mutableAttributedString
        }
        
        if UserDefaults.userType == .customer{
            deleteBtn.setTitle("Delete Account".localized(), for: .normal)
        }else{
            deleteBtn.setTitle("Send Delete Request".localized(), for: .normal)
        }
        deleteBtn.backgroundColor = UIColor.init(hexString: "#9A9A9A")
        
        deleteBtn.isEnabled = false
        deleteBtn.setTitleColor(UIColor.white, for: .disabled)
        backBt.setTitle("Whoops ! Go Back".localized(), for: .normal)
        configureOTPField()
    }
    private func configureOTPField() {
        codeTextField.defaultCharacter = ""
        codeTextField.configure()
        codeTextField.didEnterLastDigit = { [weak self] code in
            self?.OTPCode = code
            self?.deleteBtn.isEnabled = true
            self?.deleteBtn.backgroundColor = UIColor.buttonRedColor
            
        }
    }
    func dismissView() {
        UIView.animate(
            withDuration: 0.4,
            delay: 0.04,
            animations: {
                self.alpha = 0
            }, completion: { (complete) in
                self.removeFromSuperview()
            })
    }
    
    
    
    @IBAction func closeBtnTpd(_ sender: Any) {
        self.dismissView()
    }
    @IBAction func deleteBtnTpd(_ sender: Any) {
        self.dismissView()
        delegate?.deleteAcc(password: OTPCode)
        
    }
    @IBAction func backBtTpd(_ sender: Any) {
        self.dismissView()
    }
}
