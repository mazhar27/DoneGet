//
//  ConfirmPaymentVC.swift
//  Done
//
//  Created by Mazhar Hussain on 23/06/2022.
//

import UIKit
import Localize_Swift
protocol PushPaymentController: AnyObject {
    func ButtonTpd(isYesTpd:Bool, balanceamount:String)
    func addInvoiceData(amount: String, invoiceID: String)
   
}


class ConfirmPaymentVC: BaseViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var paymentMethodTitleLbl: UILabel!
    @IBOutlet weak var creditCardTitleLbl: UILabel!
    @IBOutlet weak var topUpAmountLbl: UILabel!
    @IBOutlet weak var topUpAmountTitleLbl: UILabel!
    @IBOutlet weak var confirmPaymentTitleLbl: UILabel!
    @IBOutlet weak var outerVu: UIView!
    
    weak var delegate : PushPaymentController?
    var amount = ""
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.Localization()
            
        topUpAmountLbl.text = "SAR " + amount

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        outerVu.roundCorners(corners: [.topLeft, .topRight], radius: 35)
    }
    
    //MARK: - IBActions

    @IBAction func closeBtnTpd(_ sender: Any) {
        self.dismiss(animated: true)
//        delegate?.ButtonTpd(isYesTpd: true, balanceamount: amount)
    }
    private func Localization(){
        confirmPaymentTitleLbl.text = "Confirm Payment Method".localized()
        topUpAmountTitleLbl.text = "Top Up Amount".localized()
        paymentMethodTitleLbl.text = "Payment Method".localized()
        creditCardTitleLbl.text = "Credit/Debit Card".localized()
        continueBtn.setTitle("Continue".localized(), for: .normal)
    }
    
    @IBAction func continueBtnTpd(_ sender: Any) {
//        let storyboard = getMainStoryboard()
//        guard let numberVC = storyboard.instantiateViewController(PaymentVC.self) else {
//            return
//        }
//        numberVC.amount = amount
//        numberVC.comefromWallet = true
//        show(numberVC, sender: self)
        
        self.dismiss(animated: true)
        delegate?.ButtonTpd(isYesTpd: true, balanceamount: amount)
    }
}
