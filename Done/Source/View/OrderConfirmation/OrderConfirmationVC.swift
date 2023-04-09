//
//  OrderConfirmationVC.swift
//  Done
//
//  Created by Mazhar Hussain on 17/06/2022.
//

import UIKit
import EzPopup
import Localize_Swift

class OrderConfirmationVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var viewOrderBtn: UIButton!
    @IBOutlet weak var orderIDTitleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    
    //MARK: - Variables
    
    var orderId = ""
    var isSuccess = true
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButtonItem()
        if isSuccess == false{
            showAlert(title: "Credit card transaction not successful. Your order has been placed successfully on cash".localized(), descText: "", showButtons: false, height: 250, iconName: "infoIcon")
        }
        initialSetup()
        
        // Do any additional setup after loading the view.
    }
    //MARK: - Helping Methods
    
    func initialSetup(){
        self.title = "Order Placed".localized()
        orderIdLbl.text = orderId
        orderIDTitleLbl.text = "Order ID".localized()
        descLbl.text = "Your order has been placed. Your Provider will soon accept your order".localized()
        viewOrderBtn.setTitle("View Orders".localized(), for: .normal)
    }
    private func showAlert(title: String,descText:String, showButtons: Bool, height:CGFloat,iconName: String){
        let storyboard = getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(generalPopUPVC.self) else {
            return
        }
        numberVC.descLblText = descText
        numberVC.titleLblTxt = title
        numberVC.showButtonView = showButtons
        numberVC.imageName = iconName
        
        let popupVC = PopupViewController(contentController: numberVC, popupWidth: UIScreen.main.bounds.width - 20, popupHeight: height)
        present(popupVC, animated: true)
    }
    //MARK: - IBActions
    override func btnBackAction() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    
    
    @IBAction func viewOrdersBtnTpd(_ sender: Any) {
        let VCs = self.navigationController?.viewControllers    //VCs = [A, B, C, D]
        
        let vcA  = VCs?[0]    //vcA = A
        //finally
        
        // OR
        let storyboard = getMainStoryboard()
        guard let VC = storyboard.instantiateViewController(MyOrdersVC.self) else {
            return
        }
        self.navigationController?.viewControllers = [vcA!,VC] //done
        
        //        self.navigationController.setViewControllers([vcA], animated: true)
    }
    
}
