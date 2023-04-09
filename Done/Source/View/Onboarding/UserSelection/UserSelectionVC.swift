//
//  UserSelectionVC.swift
//  Done
//
//  Created by Mazhar Hussain on 02/06/2022.
//

import UIKit
import Localize_Swift

class UserSelectionVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var continueLbl: UILabel!
    @IBOutlet weak var providerBtn: UIButton!
    @IBOutlet weak var customerBtn: UIButton!
    @IBOutlet weak var customerOuterVu: UIView!
    @IBOutlet weak var customerLbl: UILabel!
    @IBOutlet weak var providerOuterVu: UIView!
    
    @IBOutlet weak var providerLbl: UILabel!
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loopThroughSubViewAndAlignTextfieldText(subviews: self.view.subviews)
        self.loopThroughSubViewAndAlignLabelText(subviews: self.view.subviews)
        
        initialSetup()
    }
    private func initialSetup(){
        customerBtn.setTitle("", for: .normal)
        providerBtn.setTitle("", for: .normal)
        continueLbl.text = "Continue as".localized()
        customerLbl.text = "Customer".localized()
        providerLbl.text = "Service Provider".localized()
    }
   
    
    //MARK: - IBActions
    
    @IBAction func selectionBtnTpd(_ sender: UIButton) {
        if sender.tag == 0{
            customerOuterVu.backgroundColor = UIColor.blueThemeColor
            customerLbl.textColor = UIColor.white
            providerOuterVu.backgroundColor = UIColor.white
            providerLbl.textColor = UIColor.blueThemeColor
            UserDefaults.userType = .customer
            UserDefaults.isLogined = false
        }else{
            providerOuterVu.backgroundColor = UIColor.blueThemeColor
            providerLbl.textColor = UIColor.white
            customerOuterVu.backgroundColor = UIColor.white
            customerLbl.textColor = UIColor.blueThemeColor
            UserDefaults.userType = .provider
        }
        
        if let _ = UserDefaults.phoneNumber {
            performSegue(withIdentifier: "loginSegue", sender: self)
        }else {
            performSegue(withIdentifier: "phoneVerifySegue", sender: self)
        }

    }
}
