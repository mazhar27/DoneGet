//
//  TremsConditionsView.swift
//  Do-ne
//
//  Created by Muhammad Usman Zia on 27/02/2020.
//  Copyright © 2020 Dtech. All rights reserved.
//

import UIKit
import Localize_Swift
import WebKit

protocol TremsConditionsDelegate: AnyObject {
    func acceptTrems(checkAccept: Bool)
}

class TremsConditionsView: UIView,WKNavigationDelegate {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btn_Accept: UIButton!
    @IBOutlet weak var btn_Decline: UIButton!
    @IBOutlet weak var contentWebKit: WKWebView!
    var comingFromTermsCondition = true
    weak var delegate: TremsConditionsDelegate!
    
    //MARK: - Helping Methods
    func dismissView() {
        self.endEditing(true)
        UIView.animate(
            withDuration: 0.4,
            delay: 0.04,
            animations: {
                self.alpha = 0
            }, completion: { (complete) in
                //            self.removeFromSuperview()
            })
    }
    func setLayout()
    {
        let urlString  = Localize.currentLanguageLocaleName == "ar" ?
        "https://do-net.com/terms-and-conditions-ar" :
        "https://do-net.com/terms-and-conditions-en"
        let url = URL(string: urlString)!
        
        if self.comingFromTermsCondition == true{
            btn_Accept.setTitle("Accept".localized(), for: .normal)
            btn_Decline.setTitle("Decline".localized(), for: .normal)
            lbl_Title.text = "Terms and Conditions".localized()
            contentWebKit.navigationDelegate = self
            contentWebKit.load(URLRequest(url: url))
            contentWebKit.allowsBackForwardNavigationGestures = false
        }
        else {
            lbl_Title.text = "Privacy Policy".localized()
            contentWebKit.navigationDelegate = self
            contentWebKit.load(URLRequest(url: url))
            contentWebKit.allowsBackForwardNavigationGestures = false
        }
    }
    
    func loadView()
    {
        
    }
    
    //MARK: - Button Actions
    @IBAction func btnAccept(_ sender: Any) {
        delegate.acceptTrems(checkAccept: true)
        self.dismissView()
    }
    
    @IBAction func btnDecline(_ sender: Any) {
        delegate.acceptTrems(checkAccept: false)
        self.dismissView()
    }
    @IBAction func btnClose(_ sender: Any) {
        self.dismissView()
    }
}

