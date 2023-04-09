//
//  PaymentVC.swift
//  Done
//
//  Created by Mazhar Hussain on 24/08/2022.
//

import UIKit
import WebKit
import Combine
import Localize_Swift
import SwiftSoup
import EzPopup

class PaymentVC: BaseViewController,WKNavigationDelegate{
    //MARK: - IBOutlets
    @IBOutlet weak var webVu: WKWebView!
   
    //MARK: - Variable
    let viewModel =  PaymentViewModel()
    private var bindings = Set<AnyCancellable>()
    var amount = ""
    var orderNumber = ""
    var transType = "1"
    var comefromWallet = false
    var additionalPaymentSucceded: ((Int)-> Void)?
    var isAdditionalInvoiceFlow = false
    
    //MARK: - Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = "Payment".localized()
        addLeftBarButtonItem()
        callingApi()
        bindViewModel()
//        viewModel.topUpWallet(amount: amount)
       

        // Do any additional setup after loading the view.
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
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
        numberVC.delegate = self
         let popupVC = PopupViewController(contentController: numberVC, popupWidth: UIScreen.main.bounds.width - 20, popupHeight: height)
        present(popupVC, animated: true)
    }
    private func callingApi(){
       var param : [String: Any] = ["amount":amount,"order_number":orderNumber,"type":"1","transaction_type":transType]
        if comefromWallet{
            param = ["amount":amount,"order_number":"","type":"2","transaction_type": "2"]
            
        }
        viewModel.getBankUrl(param: param)
    }
    @IBAction func backBtnTpd(_ sender: Any) {
       
        
    }
    override func btnBackAction() {
        if comefromWallet{
            showAlert(title: "Credit card transaction not successful".localized(), descText: "", showButtons: true, height: 300, iconName: "infoIcon")
        }else{
            showAlert(title: "Credit card transaction not successful. Your order has been placed successfully on cash".localized(), descText: "", showButtons: true, height: 300, iconName: "infoIcon")
        }
        
//        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func bindViewModel() {
      viewModel.bankhostedData
            .sink{ [weak self] completion in
                switch completion {
                case .failure(let error):
                    // Error can be handled here (e.g. alert)
                    DispatchQueue.main.async {
                        self?.showAlert("Done".localized(), error.localizedDescription)
                    }
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] bankData in
              print(bankData)
                self?.setLayout(urlString: bankData.gatewayUrl ?? "")
           }.store(in: &bindings)
        
        viewModel.$state.sink { [weak self] (state) in
            switch state {
            case .noInternet(let noInternetMsg):
                DispatchQueue.main.async {
                    self?.showAlert("Done".localized(), noInternetMsg, .warning)
                }
                break
            case .loading:
                print("Loading")
                break
            case .error(let error):
                DispatchQueue.main.async {
                    self?.showAlert("Done".localized(), error)
                }
                break
            case .loaded(let message):
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert("Done".localized(), message, .success)
//                    self?.deleteAddress()
                    self?.moveToControllerWallet()
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &bindings)
    }
    //MARK: - Helping Methods
    func setLayout(urlString: String) {
        if urlString != "" {
           self.webVu.load(URLRequest(url: URL(string: urlString)!))
            self.webVu.navigationDelegate = self
            self.webVu.backgroundColor = UIColor.white
            self.webVu.isOpaque = false
        }
    }
    func moveToController(isSuccess:Bool){
        let storyboard = getMainStoryboard()
        guard let VC = storyboard.instantiateViewController(OrderConfirmationVC.self) else {
            return
        }
        VC.isSuccess = isSuccess
            VC.orderId = orderNumber
        show(VC, sender: self)
    }
    func moveToControllerWallet(){
        let storyboard = getMainStoryboard()
        guard let VC = storyboard.instantiateViewController(TopUpSuccessVC.self) else {
            return
        }
       
        show(VC, sender: self)
    }
    //MARK: - Webkit and Scoll View Delegates
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Loaded")
       
        print("Did finish: \(self.webVu.url!)")
        if self.webVu.url!.absoluteString.contains("/api/v4/arb/decrypt-response") {
            print("READ JSON DATA")
            var htmlStr = ""
            webVu.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML") { innerHTML, error in
                print(innerHTML!)
                htmlStr = innerHTML as? String ?? ""
                do {
                    let html: String = htmlStr
                    let doc: Document = try SwiftSoup.parse(html)
//                    let _: Element = try doc.select("a").first()!
                    let jsonText: String = try doc.body()!.text(); // "An example link"
                    print(jsonText)
                    let dataJSON = jsonText.data(using: .utf8)!
                    do {
                        let json = try JSONSerialization.jsonObject(with: dataJSON)
                        print(json)
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(BaseModel<BankResponseData>.self, from: dataJSON)
                        print(decodedData)
                        
                        if decodedData.data?.arbResponse?.result != nil {
//                            if decodedData.data?.arbResponse?.error == nil {
                                
                                self.handleResponseResult(responseResultMessage: decodedData.data?.arbResponse?.result ?? "", paymentId: decodedData.data?.arbResponse?.paymentId ?? 0)
                                
//                            }
//                            else {
//                                self.webVu.isHidden = true
////                                if self.isAddFunds {
////                                    self.showAlertOK("Done".localized(), message: "The transaction was not successful. Please try again".localized()) { action in
////                                        self.popToController(vc: WalletVC.self)
////                                    }
////                                } else {
////                                    self.showCustomAlert(title: "Done".localized(), subTitle: "\(decodedData.data?.arbResponse?.errorText ?? "")\n\("Credit card transaction not successful. Your order has been placed successfully on cash.".localized())", isSingleButtonVisible: true)
////                                }
//                            }
                        } else {
                            self.handleResponseResult(responseResultMessage: decodedData.data?.arbResponse?.result ?? "", paymentId: decodedData.data?.arbResponse?.paymentId ?? 0)
                        }
                        
                    } catch {
                        print(error) //You should not ignore errors silently...
                    }
                } catch Exception.Error( _, let message) {
                    print(message)
                } catch {
                    print("error")
                }
            }
        }
    }
    func handleResponseResult(responseResultMessage: String, paymentId: Int) {
        if responseResultMessage == "CAPTURED" {
            print("Payment successful")
            if isAdditionalInvoiceFlow {
               additionalPaymentSucceded?(paymentId)
                navigationController?.popViewController(animated: true)
            }
            if comefromWallet{
                viewModel.topUpWallet(amount: amount)
            }else{
            self.webVu.isHidden = true
            moveToController(isSuccess: true)
            }
           
        } else {
            if isAdditionalInvoiceFlow == true{
                navigationController?.popViewController(animated: true)
            }
            if comefromWallet{
              print("top up failed")
                self.webVu.isHidden = true
                self.showAlert("Done", "The transaction was not successful. Please try again", .error)
                self.navigationController?.popToViewController(ofClass: WalletVC.self)
            }else{
            self.webVu.isHidden = true
            moveToController(isSuccess: false)
//            self.paymentFailure()
            }
        }
    }
}
// pop up delegate

extension PaymentVC: generalPopupDelegate{
    func ButtonTpd(isYesTpd: Bool) {
        if isYesTpd && comefromWallet{
            self.navigationController?.popToViewController(ofClass: TopUpVC.self)
        }
        if isYesTpd && !comefromWallet{
            moveToController(isSuccess: false)
        }
    }
}
