//
//  TopUpSuccessVC.swift
//  Done
//
//  Created by Mazhar Hussain on 30/08/2022.
//

import UIKit
import Localize_Swift

class TopUpSuccessVC: BaseViewController {

    @IBOutlet weak var viewWalletBt: UIButton!
    @IBOutlet weak var descLbl: UILabel!
    var orderNumber = ""
    
    var comeFromInvoice = false
    override func viewDidLoad() {
        super.viewDidLoad()
       addLeftBarButtonItem()
//        initialSetup()
        Localization()
        // Do any additional setup after loading the view.
    }
    override func btnBackAction() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func initialSetup(){
        if comeFromInvoice{
            viewWalletBt.setTitle("View Orders".localized(), for: .normal)
            if Localize.currentLanguage() == "ar"{
                descLbl.text = "تهانينا ! اكتملت عملية دفع الفاتورة الإضافية بخصوص الأمر رقم \(orderNumber)"
            }else{
            descLbl.text = "Congratulations !Your payment for additional invoice regarding ORDER \(orderNumber) is complete"
            }
           
        }
    }
    
    private func Localization(){
        if !comeFromInvoice{
            descLbl.text = "Congratulations ! Your account has been topped up".localized()
            viewWalletBt.setTitle("View Wallet".localized(), for: .normal)
        }else{
           
            viewWalletBt.setTitle("View Orders".localized(), for: .normal)
            if Localize.currentLanguage() == "ar"{
                descLbl.text = "تهانينا ! اكتملت عملية دفع الفاتورة الإضافية بخصوص الأمر رقم \(orderNumber)"
            }else{
            descLbl.text = "Congratulations !Your payment for additional invoice regarding ORDER \(orderNumber) is complete"
            }
        }
    }
    @IBAction func viewWalletBtnTpd(_ sender: Any) {
        if UserDefaults.userType == .provider{
            self.navigationController?.popToRootViewController(animated: false)
        }else{
        if comeFromInvoice{
            let VCs = self.navigationController?.viewControllers    //VCs = [A, B, C, D]

            let vcA  = VCs?[0]    //vcA = A
            //finally
          
            // OR
            let storyboard = getMainStoryboard()
            guard let VC = storyboard.instantiateViewController(MyOrdersVC.self) else {
                return
            }
            self.navigationController?.viewControllers = [vcA!,VC] //done
        }else{
        self.navigationController?.popToViewController(ofClass: WalletVC.self)
        }
    }
    }
    

}
