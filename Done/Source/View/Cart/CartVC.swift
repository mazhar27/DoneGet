//
//  CartVC.swift
//  Done
//
//  Created by Mazhar Hussain on 15/06/2022.
//

import UIKit
import Combine
import EzPopup
import WSTagsField
import Localize_Swift

class CartVC: BaseViewController {
    
    
    
    @IBOutlet weak var viewCouponBtn: UIButton!
    @IBOutlet weak var addNewServiceLbl: UILabel!
    @IBOutlet weak var scrollContentVu: NSLayoutConstraint!
    @IBOutlet weak var scrollVu: UIScrollView!
    @IBOutlet weak var applyCouponLbl: UILabel!
    @IBOutlet weak var inviceImgVu: UIImageView!
    @IBOutlet weak var tagsOuterVu: UIView!
    @IBOutlet weak var tbvuHeightCons: NSLayoutConstraint!
    @IBOutlet weak var tagsVuHeightCons: NSLayoutConstraint!
    @IBOutlet weak var tagsVu: UIView!
    
    @IBOutlet weak var reviewPaymntBtn: UIButton!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var addnewServicesBtn: UIButton!
    @IBOutlet weak var selectedServicesLbl: UILabel!
    @IBOutlet weak var totalAmountTitleLbl: UILabel!
    @IBOutlet weak var upperVu: UIView!
    @IBOutlet weak var lowerVu: UIView!
    @IBOutlet weak var tableVu: UITableView!
    @IBOutlet weak var emptyCartVu: UIView!
    
    @IBOutlet weak var noServiceLabel: UILabel!
    @IBOutlet weak var noServiceLabelInner: UILabel!
    
    @IBOutlet weak var applyButton: UIButton!
    
    var viewModel = CartVM()
    var localCartData = [Services]()
    var extraPayments : Extras?
    private var bindings = Set<AnyCancellable>()
    var wallet : Wallet?
    var comefromSideMenu : Bool = false
    var tagsField = WSTagsField()
    var couponData = [String]()
    var deleteServiceIndex = 0
    var totalScrollHeight = 0
    var bannersAndPromotionsDate : [BanerData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButtonItem()
        localization()
       
        initialSetup()
        gettingAlldata()

        showCartCoupons()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel()
     }
    override func viewDidAppear(_ animated: Bool) {
//        if localCartData.count == 0{
//            self.emptyCartSetup()
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewModel = CartVM()
    }
    private func gettingAlldata(){
      
        viewModel.getCouponResult(firstTime: true, coupons: ["0"])
        
        
    }
    deinit{
        tagsField.layerBoundsObserver = nil
        print("cart vc deinitialized")
    }
    private func localization(){
        self.title = "My Cart".localized()
        self.applyButton.setTitle("Apply".localized(), for: .normal)
        self.reviewPaymntBtn.setTitle("Review payments and checkouts".localized(), for: .normal)
        self.noServiceLabel.text = "No Services Found".localized()
        self.noServiceLabelInner.text = "No Services Found".localized()
        self.selectedServicesLbl.text = "Selected Services".localized()
        self.addNewServiceLbl.text = "Add New Service".localized()
        self.totalAmountTitleLbl.text = "Total Amount".localized()
        self.applyCouponLbl.text = "Apply a Coupon".localized()
        self.viewCouponBtn.setTitle("View Coupons".localized(), for: .normal)
    }
    private func setupScroll(height: CGFloat){
        scrollVu.contentSize = CGSize(width: self.view.frame.width, height: height)
        scrollContentVu.constant = height
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
    func showCartCoupons() {
        if  let cartCoupons = UserDefaults.couponCodes{
        for i in cartCoupons {
            if i != "0"{
            self.tagsField.addTag(i)
            }
        }
            DispatchQueue.main.async { [weak self] in
                self?.tagsVuHeightCons.constant = (self?.tagsField.contentSize.height ?? 31) + 20
                self?.calculateScrollHeight()
                    }
        }
        self.tagsField.placeholder = self.tagsField.tags.count == 0 ?  "Add Multiple Coupons".localized() : ""

    }

    
    override func btnBackAction() {
        if comefromSideMenu{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    private func initialSetup(){
        if let cart = UserDefaults.cartData {
           emptyCartVu.isHidden = true
            localCartData = cart
            if localCartData.count == 0{
                emptyCartSetup()
            }
        }else{
            emptyCartSetup()
        }
       
        let nib1 = UINib(nibName: "CartTVC", bundle: nil)
        let nib2 = UINib(nibName: "CartFooter", bundle: nil)

        let nib5 = UINib(nibName: "TagsCVC", bundle: nil)
        
      tableVu.register(nib1, forCellReuseIdentifier: "CartTVC")
       tableVu.register(nib2, forCellReuseIdentifier: "CartFooter")

       tableVu.register(nib5, forCellReuseIdentifier: "TagsCVC")
        tableVu.separatorStyle = .none
        tableVu.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        tableVu.isScrollEnabled = false
        addWSTagField()
        getbannerData()
     }
    func getbannerData(){
        if let data = UserDefaults.standard.data(forKey: "banners") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let decodedData = try decoder.decode([BanerData].self, from: data)
                self.bannersAndPromotionsDate = decodedData
            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }
        if self.bannersAndPromotionsDate?.count == 0 || self.bannersAndPromotionsDate == nil{
            viewCouponBtn.isHidden = true
           
        }
        
    }
    private func tableVuDelegate(){
        tableVu.delegate = self
        tableVu.dataSource = self
        tableVu.reloadData()
    }
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
                   
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &bindings)
        viewModel.$message.sink { [weak self] message in
            if message.count != 0 {
//                self?.showAlert("Done", message)
                
                self?.showAlert(title: message[1], descText: message[0], showButtons: false, height: 300, iconName: "infoIconPopUp")
                
               
            }
        }.store(in: &bindings)
      
        viewModel.couponResult
            .sink{ [weak self] completion in
                switch completion {
                case .failure(let error):
                    // Error can be handled here (e.g. alert)
                    DispatchQueue.main.async {
                        self?.showAlert("Done".localized(), error.localizedDescription)
                    }
                    return
                case .finished:
                   print("anything")
                    return
                }
            } receiveValue: { [weak self] couponData in

                print(couponData)
                if let services = couponData.services{
                    self?.localCartData = services
                    UserDefaults.cartData = services
                    
                    self?.calculateScrollHeight()
                    self?.extraPayments = couponData.extras
                   
                    self?.tableVuDelegate()
                    self?.amountLbl.text = "SAR " + (couponData.extras?.discounted_total ?? "0")
                    self?.wallet = couponData.wallet
                }
            }.store(in: &bindings)
    }
    
    func calculateScrollHeight(){
        var height = CGFloat((localCartData.count * 125) + 180)
       tbvuHeightCons.constant = height
        height = height + 120 + (tagsField.contentSize.height ) + 20
     setupScroll(height: height)
    }
    private func emptyCartSetup(){
        upperVu.isHidden = true
        lowerVu.isHidden = true
        tableVu.isHidden = true
        emptyCartVu.isHidden = false
        inviceImgVu.isHidden = true
        applyCouponLbl.isHidden = true
        tagsOuterVu.isHidden = true
        viewCouponBtn.isHidden = true
    }
    func deleteService(){
        localCartData.remove(at: deleteServiceIndex)
               UserDefaults.cartData = localCartData
        if  let cartCoupons = UserDefaults.couponCodes{
            viewModel.getCouponResult(firstTime: true, coupons: cartCoupons)
        }else{
            viewModel.getCouponResult(firstTime: true, coupons: ["0"])
        }
        if localCartData.count == 0{
            emptyCartSetup()
        }else{
               tableVu.reloadData()
        }
    }
    private func moveToCOntroller(){
        if UserDefaults.userType != .guest {
            let storyboard = getMainStoryboard()
            guard let numberVC = storyboard.instantiateViewController(CheckOutVC.self) else {
                return
            }
            numberVC.extraPayments = extraPayments
            numberVC.wallet = wallet
            show(numberVC, sender: self)
        }else{
            UserDefaults.userType = .customer
            let storyboard = getOnboardingStoryboard()
        if let _ = UserDefaults.phoneNumber {
          guard let numberVC = storyboard.instantiateViewController(LoginVC.self) else {
                return
            }
           show(numberVC, sender: self)
        }else {
          guard let numberVC = storyboard.instantiateViewController(VerifyPhoneVC.self) else {
                  return
              }
             show(numberVC, sender: self)
        }
        }

    }
    func handlingGuestUser(){
        UserDefaults.userType = .customer
        let storyboard = getOnboardingStoryboard()
    if let _ = UserDefaults.phoneNumber {
      guard let numberVC = storyboard.instantiateViewController(LoginVC.self) else {
            return
        }
       show(numberVC, sender: self)
    }else {
      guard let numberVC = storyboard.instantiateViewController(VerifyPhoneVC.self) else {
              return
          }
         show(numberVC, sender: self)
    }
    }
  
    @IBAction func reviewPaymentBtnTpd(_ sender: Any) {
        moveToCOntroller()
       
    }
    @IBAction func addNewServiceBtnTpd(_ sender: Any) {
        if comefromSideMenu{
            let VCs = self.navigationController?.viewControllers    //VCs = [A, B, C, D]

            let vcA  = VCs?[0]    //vcA = A
            let storyboard = getMainStoryboard()
            guard let VC = storyboard.instantiateViewController(HomeVC.self) else {
                return
            }
            self.navigationController?.viewControllers = [vcA!,VC] //done
            
        
        }else{
            self.navigationController?.popToViewController(ofClass: HomeVC.self)
        }
    }
    func removeCouponCode(code: String){
        if let index = couponData.firstIndex(of: code) {
            couponData.remove(at: index)
           
        } else {
            // not found
            print("Do something else")
        }
    }
    @IBAction func viewCouponsBtnTpd(_ sender: Any) {
        let storyboard = getMainStoryboard()
          guard let bannerVC = storyboard.instantiateViewController(BannerAndPromotionsViewController.self) else {
            return
          }
        bannerVC.comefromCart = true
         bannerVC.modalPresentationStyle = .overCurrentContext
          bannerVC.modalTransitionStyle = .coverVertical
          present(bannerVC, animated: true)
    }
    
    @IBAction func couponApllyBtnTpd(_ sender: Any) {
        self.view.endEditing(true)
        self.tagsField.acceptCurrentTextAsTag()
        if couponData.count == 0{
            couponData.append("0")
            viewModel.getCouponResult(firstTime: false,couponListEmpty: true, coupons: couponData)
            self.showAlert("Done".localized(), "No coupon found".localized())
        }else if couponData.count == 1{
            if couponData[0] == "0"{
                viewModel.getCouponResult(firstTime: false,couponListEmpty: true, coupons: couponData)
                self.showAlert("Done".localized(), "No coupon found".localized())
            }else{
                viewModel.getCouponResult(firstTime: false, coupons: couponData)
            }
        }else{
        viewModel.getCouponResult(firstTime: false, coupons: couponData)
        }
        
//        tagsVuHeightCons.constant = 47
//        couponData.removeAll()
//        tagsField.removeTags()
    }
    @IBAction func emptyCartBtnTpd(_ sender: Any) {
        if comefromSideMenu{
            let VCs = self.navigationController?.viewControllers    //VCs = [A, B, C, D]

            let vcA  = VCs?[0]    //vcA = A
            //finally
          
            // OR
            let storyboard = getMainStoryboard()
            guard let VC = storyboard.instantiateViewController(HomeVC.self) else {
                return
            }
            self.navigationController?.viewControllers = [vcA!,VC] //done
        }else{
            self.navigationController?.popToViewController(ofClass: HomeVC.self, animated: false)
        }
    }
    
}


extension CartVC: UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
        case 0:
            return localCartData.count
        case 1:
            return  1
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 125
        case 1:
            if indexPath.row == 0{
                return 0
            }else{
                return 47
           
            }
            
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 155
        }else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CartFooter") as? CartFooter
        guard let headerCell = headerCell else{return UIView()}
        if let payment = extraPayments{
            headerCell.configureCell(item: payment, walletBalance: String(wallet?.balance ?? 0))
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            print("")
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartTVC", for: indexPath) as? CartTVC
            guard let cell = cell else{return UITableViewCell()}
            cell.configureCell(item: localCartData[indexPath.row])
            cell.editBtn.tag = indexPath.row
            cell.editBtn.addTarget(self, action: #selector(editBtnTpd(sender:)), for: .touchUpInside)
            cell.closeBtn.tag = indexPath.row
            cell.closeBtn.addTarget(self, action: #selector(closeBtnTpd(sender:)), for: .touchUpInside)
            cell.appliedCouponBtn.tag = indexPath.row
            cell.appliedCouponBtn.addTarget(self, action: #selector(appliedCouponBtnTpd(sender:)), for: .touchUpInside)
            return cell

        default:
            return UITableViewCell()
        }
       
        
    }
    @objc func editBtnTpd(sender: UIButton){
        SessionModel.shared.cartServiceEditIndex = sender.tag
//        SessionModel.shared.subServiceImage = localCartData[sender.tag].serv
        SessionModel.shared.subServiceID  = Int(localCartData[sender.tag].service_id ?? -1)
        SessionModel.shared.subServiceName = localCartData[sender.tag].serviceName ?? ""
        SessionModel.shared.categoryID = String(localCartData[sender.tag].category_id ?? -1)
        SessionModel.shared.categoryName = localCartData[sender.tag].categoryName ?? ""
        SessionModel.shared.couponCode = localCartData[sender.tag].coupon_code ?? ""
        SessionModel.shared.couponID = localCartData[sender.tag].coupon_id ?? -1
        if comefromSideMenu{
            let storyboard = getMainStoryboard()
            guard let numberVC = storyboard.instantiateViewController(ServicesDetailsForm.self) else {
                return
            }
          show(numberVC, sender: self)
        }else{
        self.navigationController?.popToViewController(ofClass: ServicesDetailsForm.self)
        }
    }
    @objc func appliedCouponBtnTpd(sender: UIButton){
        
        let totalDiscount = (localCartData[sender.tag].discount_percentage ?? "") + "%"
        let textToshow = ("Coupon Code: ".localized() + (localCartData[sender.tag].coupon_code ?? "0") + " \n " + "Discount: ".localized() + totalDiscount)
        var iconName = ""
        if Localize.currentLanguage() == "ar"{
            iconName = "Coupon"
    }else{
        iconName = "coupSuccess"
    }
        showAlert(title: "", descText: textToshow, showButtons: false, height: 250, iconName: iconName)
    }
    @objc func closeBtnTpd(sender: UIButton){
        deleteServiceIndex = sender.tag
        showAlert(title: "Are you sure you want to delete the service?".localized(), descText: "", showButtons: true, height: 290, iconName: "deleteIconPop")
        

    }
 
    @objc func applyBtnTpd(sender: UIButton){
//        viewModel.getCouponResult(firstTime: false)
//        viewModel.tagsDataArray.removeAll()
        tableVu.reloadData()
    }
    
    
}
extension CartVC: couponsDelegate{
    func getCouponsData(coupons: [String]) {
      
        viewModel.getCouponResult(firstTime: false,coupons: coupons)
    
    }
    
    
}
// tags field

extension CartVC{
    func addWSTagField() {
//        if let coupons = UserDefaults.couponCodes{
//            tagsField.tags = coupons
//        }
        self.tagsField.frame = tagsVu.bounds
        self.tagsVu.addSubview(self.tagsField)
       self.tagsField.layer.cornerRadius = 3.0
        self.tagsField.spaceBetweenLines = 5
        self.tagsField.spaceBetweenTags = 10
        self.tagsField.layoutMargins = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        self.tagsField.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) //old padding

        self.tagsField.placeholder = self.tagsField.tags.count == 0 ?  "Add Coupons".localized() : ""
        
        self.tagsField.placeholderColor = .gray
        self.tagsField.placeholderAlwaysVisible = true
        self.tagsField.backgroundColor = .clear
        self.tagsField.textField.returnKeyType = .continue
        self.tagsVu.tintColor = UIColor.blueThemeColor
        self.tagsField.delimiter = " "
        self.tagsField.acceptTagOption = WSTagAcceptOption.space
        self.tagsField.font = UIFont.systemFont(ofSize: 14)
        textFieldEvents()
        
    }
    func textFieldEvents() {
        self.tagsField.onDidAddTag = { [weak self] field, tag in
            print("onDidAddTag", tag.text)
            if self?.couponData.count != 0{
                if self?.couponData[0] == "0"{
                    self?.couponData.remove(at: 0)
                }
            }
            self?.tagsField.placeholder = self?.tagsField.tags.count == 0 ?  "Add Multiple Coupons".localized() : ""
            self?.couponData.append(tag.text)
            DispatchQueue.main.async {
          self?.tagsVuHeightCons.constant = (self?.tagsField.contentSize.height ?? 31) + 20
                self?.calculateScrollHeight()
                        }

            print("anyth")
        }

        self.tagsField.onDidRemoveTag = {[weak self] field, tag in
            print("onDidRemoveTag", tag.text)
//            self.removeCouponCode(coupon: tag.text)
            self?.removeCouponCode(code: tag.text)
            self?.tagsField.placeholder = self?.tagsField.tags.count == 0 ?  "Add Multiple Coupons".localized() : ""

        }

        self.tagsField.onDidChangeText = {[weak self] _, text in
            if UserDefaults.userType == .guest{
                self?.handlingGuestUser()
            }
            print("onDidChangeText")
        }

        self.tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")
        }

        self.tagsField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }

        self.tagsField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }

        self.tagsField.onShouldAcceptTag = { field in
            return field.text != "OMG"
        }
    }
}

//genral popupDelegate
extension CartVC: generalPopupDelegate{
    func ButtonTpd(isYesTpd: Bool) {
        if isYesTpd{
            deleteService()
            calculateScrollHeight()
        }
    }
    
    
}


