//
//  ProviderProfileVC.swift
//  Done
//
//  Created by Dtech Mac on 05/09/2022.
//

import UIKit
import Combine
import SDWebImage
import Localize_Swift
protocol editDelegate: AnyObject {
    func providerEnterInformation(image: String, name:String,email: String,phoneNumber:String)
}
struct ProfileSection{
    var headerTitle : String?
    var data : [Any]?
    var type : String?
    var isExpandable : Bool = false
    var isExpanded : Bool = false
}
enum ProfileSectionType : String {
    case info = "infoCell",header = "HeaderCell",categoryItem = "CategoriesCell",subHeader = "subCategoriesHeaderCell",subCategory = "subCategoriesCell",logOut = "logOutCell"
}
class ProviderProfileVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var providerImageView: UIImageView!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var btnEng: UIButton!
    @IBOutlet weak var btnAr: UIButton!
    @IBOutlet weak var myProfileTitleLbl: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    //MARK: this is for dynamic sections
    
    
    var sections : [ProfileSection] = [ProfileSection]()
    var isExpandable = false
    var getHeader = [Sub_services]()
    var Category = [Categories]()
    var hideItem = changeItem.provider
    let viewModel =  ProviderProfileViewModel()
    private var bindings = Set<AnyCancellable>()
    var providerProfileData: ProfileInnerData?
    var selectedProviderService :Main_services?
    var selectedServiceIndex = 0
    var servicesData = [Main_services]()
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        //self.tableView.reloadData()
        bindViewModel()
        viewModel.getUserProfile()
        self.tabBarItem.title = "Profile".localized()
        self.editProfileBtn.setTitle("Edit Profile".localized(), for: .normal)
        self.myProfileTitleLbl.text = "My Profile".localized()
    }
    deinit{
        print("Profile vc deinitialized")
    }
    override func viewWillAppear(_ animated: Bool) {
        if Localize.currentLanguage() == "ar" {
            self.setLanguageButtons(isEng: false)
            
        }else{
            self.setLanguageButtons(isEng: true)
        }
        super.viewWillAppear(false)
    }
    
    func  initialSetup() {
        let nib1 = UINib(nibName: "InfoCell", bundle: nil)
        let nib2 = UINib(nibName: "HeaderCell", bundle: nil)
        let nib3 = UINib(nibName: "CategoriesCell", bundle: nil)
        let nib4 = UINib(nibName: "subCategoriesCell", bundle: nil)
        let nib5 = UINib(nibName: "subCategoriesHeaderCell", bundle: nil)
        let nib6 = UINib(nibName: "logOutCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "InfoCell")
        self.tableView.register(nib2, forCellReuseIdentifier: "HeaderCell")
        self.tableView.register(nib3, forCellReuseIdentifier: "CategoriesCell")
        self.tableView.register(nib4, forCellReuseIdentifier: "subCategoriesCell")
        self.tableView.register(nib5, forCellReuseIdentifier: "subCategoriesHeaderCell")
        self.tableView.register(nib6, forCellReuseIdentifier: "logOutCell")
    }
    func setLanguageButtons(isEng : Bool){
        if isEng{
            btnEng.backgroundColor = UIColor.blueThemeColor
            btnEng.setTitleColor(UIColor.white, for: .normal)
            btnEng.tintColor = UIColor.white
            btnAr.backgroundColor = UIColor.white
            btnAr.setTitleColor(UIColor.blueThemeColor, for: .normal)
            btnAr.tintColor = UIColor.blueThemeColor
            
        }else{
            btnAr.backgroundColor = UIColor.blueThemeColor
            btnAr.setTitleColor(UIColor.white, for: .normal)
            btnAr.tintColor = UIColor.white
            btnEng.backgroundColor = UIColor.white
            btnEng.setTitleColor(UIColor.blueThemeColor, for: .normal)
            btnEng.tintColor = UIColor.blueThemeColor
            btnEng.borderColor = UIColor.blueThemeColor
            btnEng.borderWidth = 1
            
        }
    }
    func addSection() -> (){
        if let providerName =  self.providerProfileData?.company_name{
            self.providerNameLabel.text = providerName
        }else{
            self.providerNameLabel.text = "Ali Raza"
        }
        if let providerprofileImage = self.providerProfileData?.logo_image{
            self.providerImageView.sd_setImage(with: URL(string:providerprofileImage) , completed: nil)
            
        }else{
            self.providerImageView.image = UIImage(named: "providerPlaceholder")
        }
        let infoCellSection : ProfileSection = ProfileSection(headerTitle: "", data: [self.providerProfileData], type: ProfileSectionType.info.rawValue, isExpandable: false)
        self.sections.append(infoCellSection)
        
        let headerSection : ProfileSection = ProfileSection(headerTitle: "View Services".localized(), data: [""], type: ProfileSectionType.header.rawValue, isExpandable: false)
        self.sections.append(headerSection)
        
        let horizontalServicesSection : ProfileSection = ProfileSection(headerTitle: "", data: self.providerProfileData?.provider_services, type: ProfileSectionType.categoryItem.rawValue, isExpandable: true,isExpanded: false)
        self.sections.append(horizontalServicesSection)
        
        if self.providerProfileData?.provider_services != nil && self.providerProfileData!.provider_services!.count > 0 {// selected first services as default
            self.selectedProviderService = self.providerProfileData!.provider_services!.first
            
        }
        self.addSelectedServicesSubSections()
   }
    func addSelectedServicesSubSections(isExpanded : Bool = false) -> () {
        if self.selectedProviderService != nil && self.selectedProviderService?.sub_services != nil && self.selectedProviderService!.sub_services!.count > 0{
            for subService in self.selectedProviderService!.sub_services! {
                let subHeaderSection : ProfileSection = ProfileSection(headerTitle: subService.sub_service_title, data: subService.categories, type: ProfileSectionType.subHeader.rawValue, isExpandable: true,isExpanded: isExpanded)
                self.sections.append(subHeaderSection)
                
            }
        }
        let logOutSection : ProfileSection = ProfileSection(headerTitle: "", data: [""], type: ProfileSectionType.logOut.rawValue, isExpandable: false)
        
        self.sections.append(logOutSection)
    }
    private func bindViewModel() {
        viewModel.providerProfileResult
            .sink{ [weak self] completion in
                switch completion {
                case .failure(let error):
                    // Error can be handled here (e.g. alert)
                    DispatchQueue.main.async {
                        self?.showAlert("Done", error.localizedDescription)
                    }
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] PdrProfileData in
                
                print("PdrProfileData \(PdrProfileData)")
                
                self?.providerProfileData = PdrProfileData
                self?.addSection()
                self?.tableView.reloadData()
                
            }.store(in: &bindings)
        viewModel.$state.sink { [weak self] (state) in
            switch state {
            case .noInternet(let noInternetMsg):
                DispatchQueue.main.async {
                    self?.showAlert("Done", noInternetMsg, .warning)
                }
                break
            case .error(let error):
                DispatchQueue.main.async {
                    self?.showAlert("Done", error)
                }
                break
            case .loaded(let message):
                DispatchQueue.main.async {
                    self?.showAlert("Done", message, .success)
                    self?.logout()
                }
                break
            default:
                break
            }
            
        }.store(in: &bindings)
        viewModel.$message.sink { [weak self] message in
            if message != ""{
                self?.showAlert("Done", message)
                self?.logout()
            }
        }.store(in: &bindings)
        
    }
    //    func deleteAccount(password: String) {
    //        print(password)
    //        viewModel.deleteCustomerAccount(pin: password)
    //
    //    }
    private func logout() {
        UserDefaults.userType = .guest
        UserDefaults.UserPin = nil
        UserDefaults.isLogined = false
        UserDefaults.LoginUser = nil
        UserDefaults.cartData = nil
        UserDefaults.couponCodes = nil
        
        KeychainHelper.standard.delete(Constants.Strings.token)
        setRootViewController(storyboard: Storyboards.onBoarding, identifier: "RoleSelectionNavigator")
    }
    func moveToProfileVC(){
        
        let storyBoard : UIStoryboard = getMainStoryboard()
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        nextViewController.delegate = self
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func btnEidtProfile(_ sender: UIButton) {
        
        moveToProfileVC()
    }
    
    @IBAction func btnLanguageSelect(_ sender: AnyObject) {
        if sender.tag == 0{
            //            btnEng.backgroundColor = UIColor.blueThemeColor
            //            btnEng.setTitleColor(UIColor.white, for: .normal)
            //            btnEng.tintColor = UIColor.white
            //            btnAr.backgroundColor = UIColor.white
            //            btnAr.setTitleColor(UIColor.blueThemeColor, for: .normal)
            //            btnAr.tintColor = UIColor.blueThemeColor
            Localize.setCurrentLanguage("en")
            
        }else{
            
            //            btnAr.backgroundColor = UIColor.blueThemeColor
            //            btnAr.setTitleColor(UIColor.white, for: .normal)
            //            btnAr.tintColor = UIColor.white
            //            btnEng.backgroundColor = UIColor.white
            //            btnEng.setTitleColor(UIColor.blueThemeColor, for: .normal)
            //            btnEng.tintColor = UIColor.blueThemeColor
            Localize.setCurrentLanguage("ar")
        }
        UserDefaults.hasAppLanguageChanged = true
    }
    
    func openAccountDeletionAlert() {
        var AccountDeletionAlert = Bundle.main.loadNibNamed("PasswordConfirmAlert", owner: DashBoardVC?.self, options: nil)?.first as! PasswordConfirmAlert
        AccountDeletionAlert.alpha = 0
        AccountDeletionAlert.alpha = 0
        UIView.animate(
            withDuration: 0.4,
            delay: 0.04,
            animations: { [weak self] in
                AccountDeletionAlert.alpha = 1
                AccountDeletionAlert.frame = CGRect(x: 0, y: 0, width: (self?.view.frame.width)!, height: (self?.view.frame.height)!)
                //                self.AccountDeletionAlert.setLayout()
                AccountDeletionAlert.delegate = self
                AccountDeletionAlert.setupView()
                self?.view.addSubview(AccountDeletionAlert)
            })
    }
}
extension ProviderProfileVC:UITableViewDataSource,UITableViewDelegate , SecondVCDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count//6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = self.sections[section]
        print("current section \(currentSection.type!) : \(currentSection.isExpandable) :: \(currentSection.isExpanded)")
        if currentSection.isExpandable && !currentSection.isExpanded {
            return 0
        }else{
            if currentSection.type == ProfileSectionType.categoryItem.rawValue {// it is horizontal collection view
                if currentSection.data != nil &&  currentSection.data!.count > 0{
                    return 1
                }else{
                    return 0
                }
            }else if currentSection.type == ProfileSectionType.subHeader.rawValue{
                return (self.sections[section].data!.count + 1)// 1 for header cell
                
            }else{
                return self.sections[section].data!.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.sections[indexPath.section].type == ProfileSectionType.info.rawValue {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            cell1.configureInfoCell(profileInfo: self.providerProfileData! )
            return cell1
            
        }else if self.sections[indexPath.section].type == ProfileSectionType.header.rawValue {
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            
            if self.sections[indexPath.section].isExpanded {
                cell2.forwardIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                
            }else{
                cell2.forwardIcon.transform = .identity
                if Localize.currentLanguage() == "ar"{
                    cell2.forwardIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }
                
            }
            return cell2
            
        }else if self.sections[indexPath.section].type == ProfileSectionType.categoryItem.rawValue{
            
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCell
            cell3.setCellContent(serviceData: (self.providerProfileData?.provider_services)!, selectedService: self.selectedProviderService!)
            cell3.collectionSelectionDelegate = self
            cell3.collectionV.reloadData()
            return cell3
            
        }else if self.sections[indexPath.section].type == ProfileSectionType.subHeader.rawValue{
            if indexPath.row == 0 { // it is sub header cell
                let cell4 = tableView.dequeueReusableCell(withIdentifier: "subCategoriesHeaderCell", for: indexPath) as! subCategoriesHeaderCell
                
                if let data = sections[indexPath.section].headerTitle{
                    cell4.configurHeaderCell(header:data)
                }
                return cell4
            }else{ // it is subcategory cell
                let cell5 = tableView.dequeueReusableCell(withIdentifier: "subCategoriesCell", for: indexPath) as! subCategoriesCell
                cell5.configureSubCategoryCell(categoryCell:self.sections[indexPath.section].data![indexPath.row - 1] as! Categories)// 1
                return cell5
            }
        }else if self.sections[indexPath.section].type == ProfileSectionType.logOut.rawValue{
            
            let cell6 = tableView.dequeueReusableCell(withIdentifier: "logOutCell", for: indexPath) as! logOutCell
            cell6.actionHelp.addTarget(self, action: #selector(btnHelp(sender:)), for: .touchUpInside)
            cell6.actionLogOut.addTarget(self, action: #selector(btnlogOut(sender:)), for: .touchUpInside)
            cell6.actionDelete.addTarget(self, action: #selector(deleteBtnTpd(sender:)), for: .touchUpInside)
            return cell6
        }
        return UITableViewCell()
    }
    @objc func btnlogOut(sender: UIButton){
        viewModel.logout()
        
    }
    @objc func deleteBtnTpd(sender: UIButton){
        self.openAccountDeletionAlert()
        
    }
    @objc func btnHelp(sender: UIButton){
        self.openHelpSupport()
        
    }
    func didSelectDataAt(_ index: Int) {
        print("didSelectDataAt \(index)")
        self.selectedProviderService = self.providerProfileData!.provider_services![index]
        var newSections : [ProfileSection] = [ProfileSection]()
        
        for (index,item) in self.sections.enumerated(){
            print("inner ")
            if item.type == ProfileSectionType.subHeader.rawValue || item.type == ProfileSectionType.logOut.rawValue{
                print("index is \(index)")
                //self.sections.remove(at: index)
            }else{
                newSections.append(item)
            }
        }
        self.sections.removeAll()
        self.sections = newSections
        
        self.addSelectedServicesSubSections(isExpanded: true)
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? HeaderCell else { return }
        
        for (index,item) in self.sections.enumerated(){
            
            if item.type == ProfileSectionType.header.rawValue || item.type == ProfileSectionType.subHeader.rawValue || item.type == ProfileSectionType.categoryItem.rawValue{
                
                if self.sections[index].isExpanded {
                    self.sections[index].isExpanded = false
                    
                }else{
                    self.sections[index].isExpanded = true
                    
                }
            }
            self.tableView.reloadData()
        }
        
    }
    
}
extension ProviderProfileVC: editDelegate{
    func providerEnterInformation(image: String, name: String, email: String, phoneNumber: String) {
        providerProfileData?.name = name
        providerProfileData?.email = email
        providerProfileData?.logo_image = image
        providerProfileData?.phone = phoneNumber
        providerNameLabel.text = name
        self.providerImageView.sd_setImage(with: URL(string:image) , completed: nil)
        tableView.reloadData()
        
        
    }
    
    
}

extension ProviderProfileVC: deleteAccountDelegate{
    func deleteAcc(password: String) {
        viewModel.deleteProviderAccount(pin: password)
    }
    
    
}



