//
//  generalPopUPVC.swift
//  Done
//
//  Created by Mazhar Hussain on 25/08/2022.
//

import UIKit
import Localize_Swift
protocol generalPopupDelegate: AnyObject {
    func ButtonTpd(isYesTpd:Bool)
    
}

class generalPopUPVC: UIViewController {
    
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var imgVuHeightCons: NSLayoutConstraint!
    @IBOutlet weak var imgVuWidthCons: NSLayoutConstraint!
    @IBOutlet weak var titleLblTopCons: NSLayoutConstraint!
    @IBOutlet weak var buttonsHeightCons: NSLayoutConstraint!
    @IBOutlet weak var twoButtonsOuterVu: UIView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageVu: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    
    weak var delegate: generalPopupDelegate?
    var showButtonView = false
    var descLblText = ""
    var titleLblTxt = ""
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        yesBtn.setTitle("Yes".localized(), for: .normal)
        noBtn.setTitle("No".localized(), for: .normal)
    }
    
    private func initialSetup(){
        imageVu.image = UIImage(named: imageName)
        descLbl.text = descLblText
        titleLbl.text = titleLblTxt
        descLbl.adjustsFontSizeToFitWidth = true
        descLbl.minimumScaleFactor = 0.5
        // Do any additional setup after loading the view.
        if showButtonView{
            twoButtonsOuterVu.isHidden = false
            buttonsHeightCons.constant = 50
            closeBtn.isHidden = true
        }else{
            twoButtonsOuterVu.isHidden = true
            buttonsHeightCons.constant = 0
        }
        if titleLbl.text == ""{
            titleLblTopCons.constant = 0
        }
        if imageName == "coupSuccess" || imageName == "Coupon" {
            imgVuWidthCons.constant = 100
            imgVuHeightCons.constant = 74
        }
        
    }
    @IBAction func yesBtnTpd(_ sender: UIButton) {
        if sender.tag == 1{
            self.dismiss(animated: true)
        }else{
            self.dismiss(animated: true)
            delegate?.ButtonTpd(isYesTpd: true)
        }
    }
    
    @IBAction func closeBtnTpd(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
