//
//  CheckOutVC.swift
//  Done
//
//  Created by Mazhar Hussain on 16/06/2022.
//

import UIKit
import Combine
import Localize_Swift

class CheckOutVC: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var creditCardOptionHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var creditCardLbl: UILabel!
    @IBOutlet weak var paymentOuterVuHeightCons: NSLayoutConstraint!
    @IBOutlet weak var serviceOnDelieveryLbl: UILabel!
    @IBOutlet weak var creditOptionOuterVu: UIView!
    @IBOutlet weak var placeOrderBtn: UIButton!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var totalAmountTitleLbl: UILabel!
    @IBOutlet weak var termsLbl: UILabel!
    @IBOutlet weak var orderSummaryLbl: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var noteTitleLbl: UILabel!
    @IBOutlet weak var homeLbl: UILabel!
    @IBOutlet weak var creditCardImgVu: UIImageView!
    @IBOutlet weak var yourLocationLbl: UILabel!
    @IBOutlet weak var homeTitleLbl: UILabel!
    @IBOutlet weak var creditCardBtn: UIButton!
    @IBOutlet weak var SORImgVu: UIImageView!
    @IBOutlet weak var serviceOnDelieveryBtn: UIButton!
    @IBOutlet weak var scrollContentVu: NSLayoutConstraint!
    @IBOutlet weak var scrollVu: UIScrollView!
    @IBOutlet weak var tblVu: UITableView!
    @IBOutlet weak var paymentMethodOuterVu: UIView!
    @IBOutlet weak var mapVu: UIView!
    @IBOutlet weak var mapOuterVu: UIView!
    
    //MARK: - Variable
    let viewModel =  CheckOutViewModel()
    var staticScrollHeight = 960
    var localCartData = [Services]()
   
    private var bindings = Set<AnyCancellable>()
    var orderDetails : Order_details?
    var extraPayments : Extras?
    var wallet : Wallet?
    var orderType = "1"
    
    //MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Localization()
        addLeftBarButtonItem()
        self.title = "Checkout".localized()
        initialSetup()
       
        bindViewModel()

        // Do any additional setup after loading the view.
    }
    deinit {
        print("checkout deinit called")
    }
    override func viewWillLayoutSubviews() {
       
        let totalScrollHeight = staticScrollHeight + (localCartData.count * 130)
        setupScroll(height: CGFloat(totalScrollHeight))
       
    }
    override func viewWillAppear(_ animated: Bool) {
      
    }
    private func Localization(){
        yourLocationLbl.text = "Your Location".localized()
        noteTitleLbl.text = "Note to provider".localized()
        paymentMethodLbl.text = "Payment Method".localized()
        serviceOnDelieveryLbl.text = "Cash on Service".localized()
        orderSummaryLbl.text = "Order Summary".localized()
        totalAmountTitleLbl.text = "Total Amount".localized()
        creditCardLbl.text = "Credit/Debit Card".localized()
        placeOrderBtn.setTitle("Place Order".localized(), for: .normal)
        termsLbl.text = "By completing this order, I agree to Privacy Policy and Terms & Conditions".localized()
        
        
    }
    func moveTocontroller(){
        let storyboard = getMainStoryboard()
        if orderType == "1"{
        guard let VC = storyboard.instantiateViewController(OrderConfirmationVC.self) else {
            return
        }
            VC.orderId = orderDetails?.order_number ?? ""
        show(VC, sender: self)
        }else{
            guard let VC = storyboard.instantiateViewController(PaymentVC.self) else {
                return
            }
                VC.orderNumber = orderDetails?.order_number ?? ""
            VC.amount = orderDetails?.amount ?? ""
            show(VC, sender: self)
        }
    }
    func clearOrdersData(){
        UserDefaults.cartData = nil
    }
    private func bindViewModel() {
       viewModel.orderResult
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
            } receiveValue: { [weak self] orderData in
                if let details = orderData.order_details{
                    self?.orderDetails = details
                    self?.clearOrdersData()
                    self?.moveTocontroller()
                }
                
               
               
                
            }.store(in: &bindings)
        
        
    }
    
    
    
    private func initialSetup(){
      
        self.amountLbl.text = "SAR " + (extraPayments?.discounted_total ?? "0")
        if let wallet1 = wallet{
            let discountedAmount = Double(extraPayments?.discounted_total ?? "0") ?? 0
            if wallet1.balance! >= discountedAmount{
                creditOptionOuterVu.isHidden = true
                creditCardOptionHeightCons.constant = 0
                paymentOuterVuHeightCons.constant = 70
                serviceOnDelieveryLbl.text = "Cash through wallet".localized()
            }
        }
        if let cart = UserDefaults.cartData {
            localCartData = cart
            homeLbl.text = localCartData[0].address_title
        }
        setupShadows()
       let nib1 = UINib(nibName: "CartTVC", bundle: nil)
        let nib2 = UINib(nibName: "CheckOutFooter", bundle: nil)
     self.tblVu.register(nib1, forCellReuseIdentifier: "CartTVC")
        self.tblVu.register(nib2, forCellReuseIdentifier: "CheckOutFooter")
        tblVu.separatorStyle = .none
       tblVu.delegate = self
        tblVu.dataSource = self
       
    }
    
    private func setupScroll(height: CGFloat){
        scrollVu.contentSize = CGSize(width: self.view.frame.width, height: height)
        scrollContentVu.constant = height
    }
   
    private func setupShadows(){
        mapOuterVu.layer.masksToBounds = false
        mapOuterVu.cornerRadius = 10
        mapOuterVu.borderWidth = 0.5
        mapOuterVu.borderColor = UIColor.white
        mapOuterVu.layer.shadowRadius = 1
        mapOuterVu.layer.shadowOpacity = 1
        mapOuterVu.layer.shadowColor = UIColor.init(hexString: "D9D6D6").cgColor
        mapOuterVu.layer.shadowOffset = CGSize(width: 0 , height:0)
        paymentMethodOuterVu.layer.masksToBounds = false
        paymentMethodOuterVu.cornerRadius = 10
        paymentMethodOuterVu.borderWidth = 0.5
        paymentMethodOuterVu.borderColor = UIColor.white
        paymentMethodOuterVu.layer.shadowRadius = 1
        paymentMethodOuterVu.layer.shadowOpacity = 1
        paymentMethodOuterVu.layer.shadowColor = UIColor.init(hexString: "D9D6D6").cgColor
        paymentMethodOuterVu.layer.shadowOffset = CGSize(width: 0 , height:0)
        
    }
    //MARK: - Button Actions

    @IBAction func paymentMethodBtnTpd(_ sender: UIButton) {
        if sender.tag == 1{
            sender.isSelected = true
            serviceOnDelieveryBtn.isSelected = false
            SORImgVu.image = UIImage(named: "circleUnfilled")
            creditCardImgVu.image = UIImage(named: "circleFilled")
            orderType = "2"
        }else{
            sender.isSelected = true
            creditCardBtn.isSelected = false
            creditCardImgVu.image = UIImage(named: "circleUnfilled")
            SORImgVu.image = UIImage(named: "circleFilled")
            orderType = "1"
        }
    }
    
    @IBAction func placeOrderBtnTpd(_ sender: Any) {
        viewModel.placeOrder(extraPayment: extraPayments!, orderType: orderType)
    }
}
//MARK: - TableView Delegates

extension CheckOutVC: UITableViewDelegate, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localCartData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTVC", for: indexPath) as! CartTVC
        cell.closeBtn.isHidden = true
        cell.editBtn.isHidden = true
        cell.selectionStyle = .none
        cell.configureCell(item: localCartData[indexPath.row])
       return cell
      
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "CheckOutFooter") as! CheckOutFooter
        if let extra = extraPayments{
            footerCell.configureCell(item: extra, walletBalance: String(wallet?.balance ?? 0))
        }
       
        return footerCell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 185
    }
   
    
}



