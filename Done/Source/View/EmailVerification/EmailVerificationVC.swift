//
//  EmailVerificationVC.swift
//  Done
//
//  Created by Mazhar Hussain on 24/08/2022.
//

import UIKit
import Localize_Swift

class EmailVerificationVC: UIViewController {

    @IBOutlet weak var emailDescLbl: UILabel!
    @IBOutlet weak var viewProfileBtn: UIButton!
    @IBOutlet weak var emailVerificationLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Localization()

        // Do any additional setup after loading the view.
    }
    
    private func Localization(){
        descLbl.text = "A verification email has been sent to your email. Kindly check your inbox".localized()
        viewProfileBtn.setTitle("View Profile".localized(), for: .normal)
        emailVerificationLbl.text = "Email Verification".localized()
        
    }
    
    @IBAction func viewProfileBtnTpd(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: ProfileVC.self)
    }
   
    
}
