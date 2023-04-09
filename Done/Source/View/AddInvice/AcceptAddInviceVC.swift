//
//  AcceptAddInviceVC.swift
//  Done
//
//  Created by Mazhar Hussain on 22/06/2022.
//

import UIKit
import Combine
import Localize_Swift

class AcceptAddInviceVC: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var outerMainVuHeightCons: NSLayoutConstraint!
    @IBOutlet weak var creditCardVuHeightCons: NSLayoutConstraint!
    @IBOutlet weak var SODHeightCos: NSLayoutConstraint!
    @IBOutlet weak var creditCardOuterVu: UIView!
    @IBOutlet weak var serviceOnDelieveryOuterVu: UIView!
    @IBOutlet weak var creditCardBtn: UIButton!
    @IBOutlet weak var addAmountBtn: UIButton!
    @IBOutlet weak var creditRadioImg: UIImageView!
    @IBOutlet weak var addAmountRadioImg: UIImageView!
    @IBOutlet weak var paynowBtn: UIButton!
    @IBOutlet weak var creditCardLbl: UILabel!
    @IBOutlet weak var additionalAmountLbl: UILabel!
    @IBOutlet weak var paymentMethodTItleLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var totalAmountTitleLbl: UILabel!
    @IBOutlet weak var walletBalanceLbl: UILabel!
    @IBOutlet weak var walletBalanceTitleLbl: UILabel!
    @IBOutlet weak var couponDisLbl: UILabel!
    @IBOutlet weak var couponDiscountTitleLbl: UILabel!
    @IBOutlet weak var vatLbl: UILabel!
    @IBOutlet weak var vatTitleLbl: UILabel!
    @IBOutlet weak var addAmountLbl: UILabel!
    @IBOutlet weak var addAmountTitleLbl: UILabel!
    @IBOutlet weak var addInviceTitleLbl: UILabel!
    @IBOutlet weak var outerVu: UIView!
    
    //MARK: - Variables
   
    let viewModel = AcceptInvoiceViewModel()
   private var bindings = Set<AnyCancellable>()
    var deletedIndex : Int?
    var paymentType = 0
    var invoiceID = ""
    var addinvoiceData: addInvoiceDataToSend?
    weak var delegate : PushPaymentController?
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        Localization()
        setUpUI()
        bindViewModel()
      }
    override func viewDidLayoutSubviews() {
        outerVu.roundCorners(corners: [.topLeft, .topRight], radius: 35)
    }
    //MARK: - Helping Methods
    private func bindViewModel() {
    
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
                    self?.dismiss(animated: true)
                    if self?.paymentType == 0{
                        self?.delegate?.ButtonTpd(isYesTpd: true, balanceamount: self?.invoiceID ?? "")
                    }
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &bindings)
    }
    private func Localization(){
        addInviceTitleLbl.text = "Additional Invoice".localized()
        addAmountTitleLbl.text = "Additional Amount".localized()
        vatTitleLbl.text = "VAT".localized()
        couponDiscountTitleLbl.text = "Coupon Discount".localized()
        walletBalanceTitleLbl.text = "Wallet Balance".localized()
        totalAmountTitleLbl.text = "Total Amount".localized()
        paymentMethodTItleLbl.text = "Payment Method".localized()
        creditCardLbl.text = "Credit/Debit Card".localized()
        paynowBtn.setTitle("Pay Now".localized(), for: .normal)
        additionalAmountLbl.text = "Cash on Service".localized()
    }
    
    private func setUpUI(){
        guard let invoice = addinvoiceData else { return }
        addAmountLbl.text = "SAR " + invoice.additionalAmount
        vatLbl.text = "SAR " + invoice.VAT
        couponDisLbl.text = "SAR " + invoice.couponData
        totalAmountLbl.text = "SAR " + invoice.totalAmount
        walletBalanceLbl.text = "SAR " + invoice.walletBalance
        let walletBlnc = Double(invoice.walletBalance) ?? 0.0
        if walletBlnc >= Double(invoice.totalAmount) ?? 0.0{
            creditCardOuterVu.isHidden = true
            creditCardVuHeightCons.constant = 0
            outerMainVuHeightCons.constant = 458
            additionalAmountLbl.text = "Cash through wallet".localized()
            paymentType = 0
           
        }
    }
    private func moveToController(){
        let storyboard = getMainStoryboard()
        guard let VC = storyboard.instantiateViewController(PaymentVC.self) else {
            return
        }
       show(VC, sender: self)
        
    }
   
//MARK: - IBActions
    @IBAction func payNowBtTpd(_ sender: Any) {
        guard let invoice = addinvoiceData else { return }
        if paymentType == 0{
            viewModel.changeAddInviceStatus(status: "2", addCostId: invoiceID, transactionID: "")
        }else{
            self.dismiss(animated: true)
            delegate?.addInvoiceData(amount: invoice.totalAmount, invoiceID: invoiceID)
        }
    }
   @IBAction func closeBtnTpd(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func paymentMethodsBtnTpd(_ sender: UIButton) {
        if sender.tag == 0{
            paymentType = 0
            addAmountBtn.isSelected = true
            creditCardBtn.isSelected = false
            addAmountRadioImg.image = UIImage(named: "circleFilled")
            creditRadioImg.image = UIImage(named: "circleUnfilled")
        }else{
            paymentType = 1
            creditCardBtn.isSelected = true
            addAmountBtn.isSelected = false
            creditRadioImg.image = UIImage(named: "circleFilled")
            addAmountRadioImg.image = UIImage(named: "circleUnfilled")
        }
    }
}


