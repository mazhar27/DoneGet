//
//  SideMenuViewController.swift
//  Done
//
//  Created by Mazhar Hussain on 6/11/22.
//

import UIKit
import Combine
import SDWebImage
import Localize_Swift

class SideMenuViewController: BaseViewController {
    
    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var guestView: UIView!
    
    @IBOutlet weak var profileImageOuterVu: UIView!
    @IBOutlet weak var guestNameLbl: UILabel!
    @IBOutlet weak var languageOuterVu: UIView!
    @IBOutlet weak var viewProfileOuterVu: UIView!
    @IBOutlet weak var viewProfileBtn: UIButton!
    @IBOutlet weak var profileImgVu: UIImageView!
    @IBOutlet weak var prepareJobsLbl: UILabel!
    @IBOutlet weak var loginAccountBtn: UIButton!
    @IBOutlet weak var helloGuestLbl: UILabel!
    @IBOutlet weak var guestMenuImgVu: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var termsAndConditionButton: UIButton!
    
    @IBOutlet weak var copyRightLabel: UILabel!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    let viewModel =  SideMenuViewModel()
    var dataPassClousure:((_ isDismesed: Bool)->Void)?
    private var cancellables = Set<AnyCancellable>()
    var addInvoiceCount = 0
    
    @IBOutlet weak var engButton: UIButton!
    @IBOutlet weak var arButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Localization()
        self.setupUI()
        bindViewModel()
    }
    deinit {
        print("sidemenu deinit called")
    }
    private func setupUI(){
        
        if UserDefaults.userType == .customer {
            setupVuCustomer()
            registerNib()
            decorateUIData()
            nameLbl.isHidden = false
            guestNameLbl.isHidden = true
        }else{
            guestNameLbl.isHidden = false
            nameLbl.isHidden = true
            viewProfileOuterVu.isHidden = true
            tblMenu.isHidden = true
            NSLayoutConstraint(item: languageOuterVu!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: profileImgVu, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        }
        
        if Localize.currentLanguage() == "ar" {
            self.setLanguageButtons(isEng: false)
            
        }else{
            self.setLanguageButtons(isEng: true)
        }
        if Localize.currentLanguage() == "ar" && UserDefaults.userType == .customer{
            NSLayoutConstraint(item: languageOuterVu!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: profileImgVu, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 60).isActive = true
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Disappear")
        
        //        presentingViewController?.viewWillAppear(true)
        // UIApplication.statusBarBackgroundColor = .white
    }
    private func Localization(){
        self.termsAndConditionButton.setTitle("Terms & Conditions".localized(), for: .normal)
        self.privacyPolicyButton.setTitle("Privacy Policy".localized(), for: .normal)
        self.copyRightLabel.text = "DONE Copyrights Ltd. @ 2022".localized()
        self.loginAccountBtn.setTitle("Login to your account".localized(), for: .normal)
        helloGuestLbl.text = "Hello, Guest".localized()
        self.viewProfileBtn.setTitle("View Profile".localized(), for: .normal)
        self.guestNameLbl.text = "Guest".localized()
        
    }
    private func decorateUIData(){
        let imageUrl = URL(string: UserDefaults.LoginUser?.profileImage ?? "")
        profileImgVu.sd_setImage(with: imageUrl,
                                 placeholderImage: UIImage(named: ""))
        nameLbl.text = UserDefaults.LoginUser?.name
        
    }
    private func registerNib() {
        viewModel.getItems()
        let nib = UINib(nibName: "SideMenuCell", bundle: nil)
        self.tblMenu.register(nib, forCellReuseIdentifier: "SideMenuCell")
        tblMenu.separatorStyle = .none
        tblMenu.delegate = self
        tblMenu.dataSource = self
        
        
    }
    private func setupVuCustomer(){
        prepareJobsLbl.isHidden = false
        loginAccountBtn.isHidden = false
        helloGuestLbl.isHidden = false
        guestMenuImgVu.isHidden = false
        viewProfileOuterVu.isHidden = false
        tblMenu.isHidden = false
        
    }
    
    private func bindViewModel() {
        viewModel.$state.sink { [weak self] (state) in
            switch state {
            case .noInternet(let noInternetMsg):
                DispatchQueue.main.async {
                    self?.showAlert("Done".localized(), noInternetMsg, .warning)
                }
                break
            case .error(let error):
                DispatchQueue.main.async {
                    self?.showAlert("Done".localized(), error)
                }
                break
            case .loaded(let message):
                DispatchQueue.main.async {
                    self?.showAlert("Done".localized(), message, .success)
                    self?.logout()
                }
                break
            default:
                break
            }
            
        }.store(in: &cancellables)
        
        
    }
    
    private func logout() {
        UserDefaults.cartData = nil
        UserDefaults.couponCodes = nil
        UserDefaults.userType = .guest
        UserDefaults.UserPin = nil
        UserDefaults.isLogined = false
        UserDefaults.LoginUser = nil
        KeychainHelper.standard.delete(Constants.Strings.token)
        
        self.setRootViewController(storyboard: Storyboards.onBoarding, identifier: "RoleSelectionNavigator")
        
    }
    func switchRootViewController() {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: {
            self.setRootViewController(storyboard: Storyboards.onBoarding, identifier: "RoleSelectionNavigator")
        })
    }
    func privacyPolicyTapped(for isPrivacy: Bool) {
        let openTrems = Bundle.main.loadNibNamed("TremsConditionsView", owner: self, options: nil)?.first as! TremsConditionsView
        if isPrivacy {
            openTrems.comingFromTermsCondition = false
        }else{
            openTrems.comingFromTermsCondition = true
        }
        openTrems.alpha = 0
        UIView.animate(
            withDuration: 0.4,
            delay: 0.04,
            animations: {
                openTrems.alpha = 1
                openTrems.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                openTrems.setLayout()
                openTrems.delegate = self
                self.view.addSubview(openTrems)
            })
    }
    
    @IBAction func viewProfileBtnTpd(_ sender: Any) {
        let storyboard = getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(ProfileVC.self) else {
            return
        }
        show(numberVC, sender: self)
    }
    @IBAction func engButtonClickAction(_ sender: UIButton) {
        if Localize.currentLanguage() == "ar" {
            self.setSelectedLanguage(isEng: true)
        }
    }
    func setSelectedLanguage(isEng : Bool) -> () {
        self.setLanguageButtons(isEng: isEng)
        if isEng{
            
            Localize.setCurrentLanguage("en")
        }else{
            
            Localize.setCurrentLanguage("ar")
            
        }
    }
    func setLanguageButtons(isEng : Bool) -> () {
        if isEng{
            engButton.backgroundColor = UIColor.blueThemeColor
            engButton.setTitleColor(UIColor.white, for: .normal)
            engButton.tintColor = UIColor.white
            arButton.backgroundColor = UIColor.white
            arButton.setTitleColor(UIColor.blueThemeColor, for: .normal)
            arButton.tintColor = UIColor.blueThemeColor
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }else{
            arButton.backgroundColor = UIColor.blueThemeColor
            arButton.setTitleColor(UIColor.white, for: .normal)
            arButton.tintColor = UIColor.white
            engButton.backgroundColor = UIColor.white
            engButton.setTitleColor(UIColor.blueThemeColor, for: .normal)
            engButton.tintColor = UIColor.blueThemeColor
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    @IBAction func arButtonClickAction(_ sender: UIButton) {
        if Localize.currentLanguage() == "en" {
            self.setSelectedLanguage(isEng: false)
        }
    }
    @IBAction func btnLoginAccount(_sender: UIButton) {
        UserDefaults.isLogined = false
        self.setRootViewController(storyboard: Storyboards.onBoarding, identifier: "RoleSelectionNavigator")
        
    }
    
    @IBAction func privacyPolicyBtnTpd(_ sender: Any) {
        privacyPolicyTapped(for: true)
        
    }
    @IBAction func termsBtnTpd(_ sender: Any) {
        privacyPolicyTapped(for: false)
    }
    @IBAction func btnMenuDismissAction(_sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - UITableViewDelegate methods
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        cell.configureCell(item: viewModel.items[indexPath.row], row: indexPath.row)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            let storyboard = getMainStoryboard()
            guard let numberVC = storyboard.instantiateViewController(MyOrdersVC.self) else {
                return
            }
            show(numberVC, sender: self)
        case 1:
            let storyboard = getMainStoryboard()
            guard let numberVC = storyboard.instantiateViewController(CartVC.self) else {
                return
            }
            numberVC.comefromSideMenu = true
            show(numberVC, sender: self)
        case 2:
            
            let storyboard = getMainStoryboard()
            
            guard let numberVC = storyboard.instantiateViewController(AddInviceVC.self) else {
                return
            }
            show(numberVC, sender: self)
            //        case 3:
            //            let storyboard = getMainStoryboard()
            //            guard let numberVC = storyboard.instantiateViewController(LocationsVC.self) else {
            //                return
            //            }
            //            show(numberVC, sender: self)
        case 3:
            let storyboard = getMainStoryboard()
            guard let numberVC = storyboard.instantiateViewController(WalletVC.self) else {
                return
            }
            show(numberVC, sender: self)
        case 4:
            self.openHelpSupport()
        case 5:
            self.dismiss(animated: true) { [weak self] in
                self?.dataPassClousure?(true)
            }
        case 6:
            viewModel.logout()
        default:
            print("anything")
        }
    }
    
    
}
extension SideMenuViewController:TremsConditionsDelegate{
    func acceptTrems(checkAccept: Bool) {
        print(checkAccept)
    }
    
    
}
