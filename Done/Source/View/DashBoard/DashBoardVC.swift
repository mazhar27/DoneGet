//
//  DashBoardVC.swift
//  Done
//
//  Created by Mazhar Hussain on 07/06/2022.
//

import UIKit
import GoogleMaps
import Localize_Swift
import Combine
import EzPopup
class DashBoardVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var savedLocationLbl: UILabel!
    @IBOutlet weak var noSavedLocationLbl: UILabel!
    @IBOutlet weak var addNewLocationBtn: UIButton!
    @IBOutlet weak var viewMApBtn: UIButton!
    @IBOutlet weak var aroundYouLbl: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var noAddressOuterVu: UIView!
    @IBOutlet weak var tableVu: UITableView!
    @IBOutlet weak var addLocationBtn: UIButton!
    @IBOutlet weak var mapVu: UIView!
    @IBOutlet weak var searchOuterVu: UIView!
    
    @IBOutlet weak var addLocationLabel: UILabel!
    //    MARK: - Variables
    
    var localAddresses = [CustomerAddress]()
    weak var marker : GMSMarker?
    var mapView = GMSMapView()
    var selectedTag : Int?
    let viewModel =  DashboardViewModel()
    private var bindings = Set<AnyCancellable>()
    var deleteAddressTag = 0
    var isDeleteCustomer = false
    var selectedLocation: CLLocationCoordinate2D?
    var additionalInvoice = 0
    
    //MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.languaugeLocalization()
        
        if  UserDefaults.LoginUser == nil{
            UserDefaults.userType = .guest
        }
        //MARK: Todo this will be uncommented
        LocationManager.sharedInstance.delegate = self
        LocationManager.sharedInstance.startUpdatingLocation()
        addMenuIcon(title: UserDefaults.LoginUser?.name ?? "Guest".localized())
        addRightBarButtonItems()
        
        initialSetup()
        if UserDefaults.userType == .customer{
            bindViewModel()
        }else{
            addRightBarButtonItems(disabledNotif: true)
        }
        //        UserDefaults.cartData = nil
        
        //        setUpGoogleMaps(lat: -33.86, long: 151.20)
        NoProviderFlow()
        bindViewModelBanners()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
        getAddress()
        if UserDefaults.userType == .customer{
            viewModel.getAddresses()
        }else{
            getLocalAddressesGuest()
        }
        viewModel.getSiteSettings()
        viewModel.getBannersAndPromotions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.view.addSubview(mapVu)
        //MARK: Todo this will be uncommented
        //        setUpGoogleMaps(lat: -33.86, long: 151.20)
      
            setBadge()
        
       
        
    }
    private func NoProviderFlow(){
        if UserDefaults.comigFromNoProvider == true && UserDefaults.userType == .customer{
            let storyboard = getMainStoryboard()
                   guard let numberVC = storyboard.instantiateViewController(NoProviderVC.self) else {
                       return
                   }
        
             let popupVC = PopupViewController(contentController: numberVC, popupWidth: UIScreen.main.bounds.width - 20, popupHeight: 450)
            present(popupVC, animated: true)
        }
        
    }
    
    private func initialSetup(){
       
        proceedBtn.isHidden = true
        searchTF.addTarget(self, action: #selector(searchTFAction), for: UIControl.Event.touchDown)
        searchTF.placeholder = "Search location".localized()
        addLocationBtn.setTitle("", for: .normal)
        searchOuterVu.layer.masksToBounds = false
        let nib = UINib(nibName: "AddressTVC", bundle: nil)
        tableVu.register(nib, forCellReuseIdentifier: "AddressTVC")
        tableVu.separatorStyle = .none
        tableVu.showsVerticalScrollIndicator = false
        tableVu.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        
    }
    @objc func searchTFAction(textField: UITextField) {
        let storyboard = getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(MapVC.self) else {
            return
        }
        numberVC.selectedLocation = self.selectedLocation
        show(numberVC, sender: self)
        
    }
    override func btnCartAction() {
        let storyboard = getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(CartVC.self) else {
            return
        }
        numberVC.comefromSideMenu = true
        show(numberVC, sender: self)
    }
    
    override func didTappedSidMenu() {
        self.callBackClousure = {[weak self] (isDismesed) -> Void in
            print("called after menu closed")
            self?.openAccountDeletionAlert()
        }
        super.didTappedSidMenu()
        
    }
    deinit {
        print("dashboard deinit called")
    }
    
    private func languaugeLocalization(){
        self.proceedBtn.setTitle("Proceed with Services".localized(), for: .normal)
        savedLocationLbl.text = "Saved Locations".localized()
        noSavedLocationLbl.text = "No Saved Locations".localized()
        addLocationBtn.setTitle("Add location".localized(), for: .normal)
        addLocationLabel.text = "Add location".localized()
        addNewLocationBtn.setTitle("Add New Location".localized(), for: .normal)
        aroundYouLbl.text = "Around You".localized()
        viewMApBtn.setTitle("View Map".localized(), for: .normal)
        if Localize.currentLanguage() == "ar"{
            searchTF.textAlignment = .right
            
        }else{
            searchTF.textAlignment = .left
        }
    }
    
    private func bindViewModel() {
        viewModel.$message.sink { [weak self] message in
            if message != ""{
                self?.showAlert("Done", message)
                self?.logout()
            }
        }.store(in: &bindings)
        
        
        viewModel.$state.sink { [weak self] (state) in
            switch state {
            case .noInternet(let noInternetMsg):
                DispatchQueue.main.async {
                    self?.showAlert("Done", noInternetMsg, .warning)
                }
                break
            case .loading:
                print("Loading")
                break
            case .error(let error):
                DispatchQueue.main.async {
                    self?.showAlert("Done", error)
                }
                break
            case .loaded(let message):
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert("Done", message, .success)
                    self?.deleteAddress()
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &bindings)
        
        viewModel.customerAddressesResult
            .sink{ [weak self] completion in
                switch completion {
                case .failure:
                    // Error can be handled here (e.g. alert)
                    self?.proceedBtn.isHidden = true
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] addresses in
                
                if addresses.count > 0 {
                    print(addresses)
                    UserDefaults.addresses = addresses
                    self?.getLocalAddresses()
                    
                }
            }.store(in: &bindings)
        
        viewModel.settingsResult
            .sink{  completion in
                switch completion {
                case .failure:
                    // Error can be handled here (e.g. alert)
                    
                    return
                case .finished:
                    return
                }
            } receiveValue: { settingdata in
                
                //                self.additionalInvoice = settingdata.
                adminPhone = settingdata.whatsapp_number ?? "+966508883408"
                additionalInvoiceCount = settingdata.additional_count ?? 0
            }.store(in: &bindings)
        
       
    }
    func bindViewModelBanners(){
        viewModel.bannersAndPromotionsResults
            .sink{  completion in
                switch completion {
                case .failure:
                    // Error can be handled here (e.g. alert)
                    
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] bannersData in
                if bannersData.count == 0 {
                    let defaults = UserDefaults.standard
                    defaults.removeObject(forKey: "banners")
                    defaults.synchronize()
                }else{
                    self?.isNeedToShowBanners(bannerData: bannersData)
                }
                
            }.store(in: &bindings)
    }
    func isNeedToShowBanners(bannerData : [BanerData]) -> () {
        
        if let data = UserDefaults.standard.data(forKey: "banners") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode Note
                let decodedData = try decoder.decode([BanerData].self, from: data)
                if bannerData.count != decodedData.count{
                    self.saveBannerData(bannerData: bannerData)
                    self.gotoBannerView()
                }else{
                    
                    for (index , banner) in bannerData.enumerated(){
                        if banner.id != bannerData[index].id{
                            self.saveBannerData(bannerData: bannerData)
                            self.gotoBannerView()
                            break
                        }else{
                            self.saveBannerData(bannerData: bannerData)
                        }
                    }
                }
                
            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }else{
            self.saveBannerData(bannerData: bannerData)
            self.gotoBannerView()
        }
    }
    private func saveBannerData(bannerData : [BanerData]) -> () {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            // Encode Note
            let data = try encoder.encode(bannerData)
            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "banners")
            UserDefaults.standard.synchronize()
        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
    }
    private func gotoBannerView() -> () {
        
        let storyboard = getMainStoryboard()
        guard let bannerVC = storyboard.instantiateViewController(BannerAndPromotionsViewController.self) else {
            return
        }
        bannerVC.modalPresentationStyle = .overCurrentContext
        bannerVC.modalTransitionStyle = .coverVertical
        present(bannerVC, animated: true)
        
    }

    private func getAddress(){
        LocationManager.sharedInstance.getCurrentAddress { [weak self] place in
            self?.marker?.title = place?.name
        }
    }
    
    
    private func setUpGoogleMaps(lat: Double,long: Double){
      
//        let camera = GMSCameraPosition.camera(withLatitude: (LocationManager.sharedInstance.lastLocation?.coordinate.latitude) ?? 31, longitude: (LocationManager.sharedInstance.lastLocation?.coordinate.longitude) ?? 31, zoom: 16.0)
        let camera = GMSCameraPosition.camera(withLatitude: (lat), longitude: (long) , zoom: 16.0)
        mapView = GMSMapView.map(withFrame: mapVu.frame, camera: camera)
        mapView.frame = CGRect(x: 0, y: 0, width: mapView.frame.width, height: mapView.frame.height)
        mapVu.addSubview(mapView)
        
        // Creates a marker in the center of the map.
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        marker.title = placeName
        mapView.selectedMarker = marker1
        marker1.map = mapView
//        marker?.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
////        marker?.title = "Sydney"
////        marker?.snippet = "Australia"
//        marker?.map = mapView
        
        self.mapView.delegate = self
        
        
    }
    
    @objc private func menuTapped() {
        print("menuTapped")
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
    
    
    func getLocalAddresses() {
        localAddresses.removeAll()
        if let addresses = UserDefaults.addresses {
            localAddresses = addresses
        }
        if localAddresses.count != 0{
            localAddresses.count >= 5 ? (addNewLocationBtn.isHidden = true) : (addNewLocationBtn.isHidden = false)
            noAddressOuterVu.isHidden = true
            proceedBtn.isHidden = false
//            proceedBtn.isEnabled = false
            proceedBtn.backgroundColor = .gray
            tableVu.delegate = self
            tableVu.dataSource = self
            tableVu.reloadData()
        }else{
            noAddressOuterVu.isHidden = false
            proceedBtn.isHidden = true
            
        }
        
    }
    
    func getLocalAddressesGuest() {
        localAddresses.removeAll()
        if let addresses = UserDefaults.addressesGuest {
            localAddresses = addresses
        }
        if localAddresses.count != 0{
            if localAddresses.count >= 5{
                addNewLocationBtn.isHidden = true
            }
            noAddressOuterVu.isHidden = true
            proceedBtn.isHidden = false
//            proceedBtn.isEnabled = false
            proceedBtn.backgroundColor = .gray
            tableVu.delegate = self
            tableVu.dataSource = self
            tableVu.reloadData()
        }else{
            noAddressOuterVu.isHidden = false
            proceedBtn.isHidden = true
           
        }
  }
    
    func openAccountDeletionAlert() {
        let AccountDeletionAlert = Bundle.main.loadNibNamed("PasswordConfirmAlert", owner: DashBoardVC?.self, options: nil)?.first as! PasswordConfirmAlert
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
    
    
    //MARK: - IBActions
    override func btnNotificationAction() {
        let storyboard = getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(NotificationsVC.self) else {
            return
        }
        show(numberVC, sender: self)
    }
    
    @IBAction func proceedBtnTpd(_ sender: Any) {
        if proceedBtn.backgroundColor != .gray{
            if viewModel.checkCartEmpty(){
                let storyboard = getMainStoryboard()
                guard let numberVC = storyboard.instantiateViewController(HomeVC.self) else {
                    return
                }
                show(numberVC, sender: self)
            }else{
                showAlert(title: "There's some change in location, are you sure you want to empty the cart?".localized(), descText: "", showButtons: true, height: 300, iconName: "infoIcon")
            }
        }
        
    }
    
    @IBAction func viewMapBtnTpd(_ sender: Any) {
        let storyboard = getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(MapVC.self) else {
            return
        }
        numberVC.selectedLocation = self.selectedLocation
        show(numberVC, sender: self)
      
       
    }
    @IBAction func addLocationBtnTpd(_ sender: Any) {
        let storyboard = getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(MapVC.self) else {
            return
        }
        //        numberVC.isLocationAddedClousure = {[weak self] (isDismesed) -> Void in
        //            self?.viewModel.getAddresses()
        //        }
        numberVC.selectedLocation = self.selectedLocation
        show(numberVC, sender: self)
    }
 }

//MARK: - UITableView Delegate

extension DashBoardVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localAddresses.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTVC", for: indexPath) as! AddressTVC
        cell.configureCell(addressObject: localAddresses[indexPath.row])
        cell.selectionBtn.tag = indexPath.row
        cell.selectionBtn.addTarget(self, action: #selector(selectionBtnTpd(sender:)), for: .touchUpInside)
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTpd(sender:)), for: .touchUpInside)
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editBtnTpd(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        let titleLabel = UILabel(frame: CGRect(x:40,y: 5 ,width:350,height:50))
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont(name: "Poppins", size: 12)
        if localAddresses.count != 5{
            titleLabel.text  = "You can add up-to Maximum 5 locations".localized()
        }
        vw.addSubview(titleLabel)
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if localAddresses.count >= 5{
            return 0
        }else{
            return 60
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    @objc func deleteBtnTpd(sender: UIButton){
        deleteAddressTag = sender.tag
        if UserDefaults.userType == .customer{
            viewModel.deleteAddress(addressID: String(localAddresses[sender.tag].addressId ?? 0))
        }else{
            deleteAddress()
        }
        
    }
    @objc func selectionBtnTpd(sender: UIButton){
        if let selectedAddressTag = selectedTag{
            if sender.tag == selectedAddressTag{
                localAddresses[selectedAddressTag].isSelected.toggle()
            }else{
                localAddresses[selectedTag!].isSelected = false
                selectedTag = sender.tag
                localAddresses[selectedTag!].isSelected = true
            }
        }else{
            selectedTag = sender.tag
            localAddresses[selectedTag!].isSelected = true
        }
        SessionModel.shared.location = localAddresses[sender.tag]
        proceedBtn.isEnabled = true
        proceedBtn.backgroundColor = .blueThemeColor
        let lat = Double(localAddresses[sender.tag].latitude ?? "0") ?? 0.0
        let long = Double(localAddresses[sender.tag].longitude ?? "0") ?? 0.0
        self.mapView.clear()
        self.mapView.removeFromSuperview()
        setUpGoogleMaps(lat: lat, long: long)
        tableVu.reloadData()
    }
    @objc func editBtnTpd(sender: UIButton){
        let storyboard = getMainStoryboard()
        guard let VC = storyboard.instantiateViewController(MapVC.self) else {
            return
        }
        VC.isAddressEditing = true
        VC.addressId = localAddresses[sender.tag].addressId ?? 0
        VC.currentAddress = localAddresses[sender.tag]
        show(VC, sender: self)
        
    }
    func deleteAddress(){
        localAddresses.remove(at:deleteAddressTag)
        if UserDefaults.userType == .customer{
            UserDefaults.addresses = localAddresses
        }else{
            UserDefaults.addressesGuest = localAddresses
        }
        if localAddresses.count == 0{
            noAddressOuterVu.isHidden = false
            proceedBtn.isHidden = true
        }
        localAddresses.count >= 5 ? (addNewLocationBtn.isHidden = true) : (addNewLocationBtn.isHidden = false)
        
        tableVu.reloadData()
    }
    
    
}

extension DashBoardVC: LocationServiceDelegate{//
    func tracingLocation(currentLocation: CLLocation) {
        LocationManager.sharedInstance.lastLocation = currentLocation
        setUpGoogleMaps(lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude)
        self.selectedLocation = currentLocation.coordinate
        LocationManager.sharedInstance.stopUpdatingLocation()
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        print("An error occured")
        
    }
    
    func trackingCurrentAddress(address: String) {
        print("current address is \(address)")
        
    }
    
    
}

extension DashBoardVC: deleteAccountDelegate{
    func deleteAcc(password: String) {
        print(password)
        viewModel.deleteCustomerAccount(pin: password)
        
    }
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
}

extension DashBoardVC: generalPopupDelegate{
    func ButtonTpd(isYesTpd: Bool) {
       
        if isYesTpd{
            UserDefaults.cartData = nil
            setBadge()
        }
    }
    
    
}
//MARK: - GMS Delegates
extension DashBoardVC: GMSMapViewDelegate {
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
//
//        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
////        selectedLocation = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
//
//
//        self.mapView.clear()
//        self.mapView.removeFromSuperview()
//        self.selectedLocation = coordinate
////        self.getTappedLocationAddress(coords: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
//        setUpGoogleMaps(lat: coordinate.latitude, long: coordinate.longitude)
////        self.getAddressFromGoogleAPI(coords: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
//    }
}






