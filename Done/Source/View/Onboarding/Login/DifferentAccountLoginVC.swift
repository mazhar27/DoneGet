//
//  DifferentAccountLoginVC.swift
//  Done
//
//  Created by Mazhar Hussain on 06/06/2022.
//

import UIKit
import Localize_Swift

class DifferentAccountLoginVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var loginDifferentAccLbl: UILabel!
    @IBOutlet weak var mobileNumLbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var dontHaveAccLbl: UILabel!
    @IBOutlet weak var enterPinLbl: UILabel!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var tf4: SMPinTextField!
    @IBOutlet weak var tf3: SMPinTextField!
    @IBOutlet weak var tf2: SMPinTextField!
    @IBOutlet weak var tf1: SMPinTextField!
    @IBOutlet weak var forgotPinBtn: UIButton!
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

        // Do any additional setup after loading the view.
    }
    
    private func initialSetup(){
        loginDifferentAccLbl.text = "Logging in with different account?".localized()
        mobileNumLbl.text = "Mobile Number".localized()
        enterPinLbl.text = "Enter 4 digit pin".localized()
        proceedBtn.setTitle("Proceed".localized(), for: .normal)
        dontHaveAccLbl.text = "Don’t have an account?".localized()
        signUpBtn.setTitle("Sign Up".localized(), for: .normal)
      
    }
    
    //MARK: - IBActions
    
    @IBAction func proceedBtnTpd(_ sender: Any) {
    }
    @IBAction func forgotPinBtnTpd(_ sender: Any) {
    }
    
    @IBAction func signUpBtnTpd(_ sender: Any) {
    }
    
    
    

}


