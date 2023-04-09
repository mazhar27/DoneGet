//
//  AddLocationVC.swift
//  Done
//
//  Created by Mazhar Hussain on 09/06/2022.
//

import UIKit
import Localize_Swift
import GoogleMaps
import GooglePlaces
import Combine

class AddLocationVC: BaseViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var outerVuHeightCons: NSLayoutConstraint!
    @IBOutlet weak var workBtnImgVu: UIImageView!
    @IBOutlet weak var homeBtnImgVu: UIImageView!
    @IBOutlet weak var workBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var homeLbl: UILabel!
    @IBOutlet weak var workLbl: UILabel!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var othherBtnImgVu: UIImageView!
    @IBOutlet weak var secondHomeTF: UITextField!
    @IBOutlet weak var otherLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var streetTF: UITextField!
    @IBOutlet weak var missingStreetLbl: UILabel!
    @IBOutlet weak var floorTF: UITextField!
    @IBOutlet weak var noteProviderTF: UITextField!
    @IBOutlet weak var addNewAddressLbl: UILabel!
    @IBOutlet weak var adddressOuterVu: UIView!
    @IBOutlet weak var outerVu: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var otherOuterVu: UIView!
    @IBOutlet weak var otherOuterVuHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var addALabel: UILabel!
    //MARK: - Variables
    var address = ""
    var addressName = ""
    var selectedLocation: CLLocationCoordinate2D?
    let viewModel =  AddLocationViewModel()
    private var cancellables = Set<AnyCancellable>()
    var currentAddress : CustomerAddress?
    var dataPassClousure:((_ isDismesed: Bool)->Void)?
    var isAddressEditing = false
    var addressId = 0
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.languageLocalization()
        initialSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        bindViewModel()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Call the roundCorners() func right there.
        outerVu.roundCorners(corners: [.topLeft, .topRight], radius: 30.0)
    }
   
    
    
    private func initialSetup(){
      
        if isAddressEditing{
            addNewAddressLbl.text = "Update new Address".localized()
        }
        outerVuHeightCons.constant = 560
        secondHomeTF.delegate = self
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        adddressOuterVu.layer.masksToBounds = false
        otherOuterVuHeightCons.constant = 0
        otherBtn.isSelected = false
        saveBtn.isEnabled = false
        saveBtn.backgroundColor = .gray
        saveBtn.setTitleColor(UIColor.white, for: .disabled)
        addressLbl.text = address
        if let address = currentAddress{
            saveBtn.isEnabled = true
            saveBtn.backgroundColor = UIColor.blueThemeColor
            streetTF.text = address.street
            floorTF.text = address.floor
            noteProviderTF.text = address.providerNote
            if address.addressName == "Home" {
                otherBtn.isSelected = false
                otherOuterVuHeightCons.constant = 0
                outerVuHeightCons.constant = 560
                othherBtnImgVu.image = UIImage(named: "otherUnfilled")
                homeBtnImgVu.image = UIImage(named: "homeIconFilled")
                workBtnImgVu.image = UIImage(named: "workIcon")
                addressName = "Home"
            }else if address.addressName == "Work"{
                otherBtn.isSelected = false
                outerVuHeightCons.constant = 560
                otherOuterVuHeightCons.constant = 0
                othherBtnImgVu.image = UIImage(named: "otherUnfilled")
                homeBtnImgVu.image = UIImage(named: "homeIcon")
                workBtnImgVu.image = UIImage(named: "workIconFilled")
                addressName = "Work"
            }else{
                otherBtn.isSelected = true
                outerVuHeightCons.constant = 600
                otherOuterVuHeightCons.constant = 40
                othherBtnImgVu.image = UIImage(named: "otherFilled")
                secondHomeTF.text = address.addressName
                addressName = address.addressName ?? ""
                
            }
        }
        
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
                    if let address = self?.currentAddress{
                        self?.saveAddress(address: address)
                    }
                    self?.dismiss(animated: true) { [weak self] in
                        self?.dataPassClousure?(true)
                    }
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &cancellables)
    }
    private func languageLocalization(){
        secondHomeTF.placeholder = "e.g. My Second Home".localized()
        addNewAddressLbl.text = "Add a new Address".localized()
        missingStreetLbl.text = "We're missing your street".localized()
        addNewAddressLbl.text = "Add a Label".localized()
        homeLbl.text = "Home".localized()
        workLbl.text = "Work".localized()
        otherLbl.text = "Other".localized()
        self.addALabel.text = "Add a Label".localized()
        saveBtn.setTitle("Save and Continue".localized(), for: .normal)
        self.streetTF.placeholder = "Street".localized()
        self.floorTF.placeholder = "Floor / Unit #".localized()
        self.noteProviderTF.placeholder = "Note to Provider (Optional)".localized()
        if Localize.currentLanguage() == "ar"{
            self.streetTF.textAlignment = .right
            self.floorTF.textAlignment = .right
            self.noteProviderTF.textAlignment = .right
            self.secondHomeTF.textAlignment = .right
        }else{
            self.streetTF.textAlignment = .left
            self.floorTF.textAlignment = .left
            self.noteProviderTF.textAlignment = .left
            self.secondHomeTF.textAlignment = .left
        }
    }
    
    @IBAction func closeBtnTpd(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveBtnTpd(_ sender: Any) {
        var address = CustomerAddress(addressId: addressId, addressTitle: address, addressName: addressName, addressDetail: "", longitude: String(selectedLocation!.longitude), latitude: String(selectedLocation!.latitude), street: streetTF.text ?? "", floor: floorTF.text ?? "", providerNote: noteProviderTF.text ?? "")
        currentAddress = address
        if UserDefaults.userType == .customer{
            isAddressEditing ? viewModel.updateAddress(address) : viewModel.saveAddress(address)
        }else{
            if let addressList = UserDefaults.addressesGuest{
                if !isAddressEditing{ address.addressId = addressList.count + 1 }
            }
            saveAddressGuest(address: address)
        }
        
    }
    
    @IBAction func otherCloseBtnTpd(_ sender: Any) {
        outerVuHeightCons.constant = 560
        otherOuterVuHeightCons.constant = 0
    }
    
    private func saveAddress(address: CustomerAddress){
        if var addressList = UserDefaults.addresses {
            if isAddressEditing{
                let indexFound = addressList.firstIndex{$0.addressId == addressId}!
                addressList[indexFound] = address
            }else{
                addressList.append(address)
            }
            UserDefaults.addresses = addressList
        } else {
            UserDefaults.addresses = [address]
        }
    }
    private func saveAddressGuest(address: CustomerAddress){
        if var addressList = UserDefaults.addressesGuest {
            if isAddressEditing{
                let indexFound = addressList.firstIndex{ $0.addressId == addressId}!
                addressList[indexFound] = address
            }else{
                
                addressList.append(address)
            }
            UserDefaults.addressesGuest = addressList
        } else {
            UserDefaults.addressesGuest = [address]
        }
        self.dismiss(animated: true) { [weak self] in
            self?.dataPassClousure?(true)
        }
    }
    
    @IBAction func otherBtnTpd(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            otherBtn.isSelected = false
            outerVuHeightCons.constant = 560
            otherOuterVuHeightCons.constant = 0
            
            othherBtnImgVu.image = UIImage(named: "otherUnfilled")
            homeBtnImgVu.image = UIImage(named: "homeIconFilled")
            workBtnImgVu.image = UIImage(named: "workIcon")
            addressName = "Home"
            saveBtn.isEnabled = true
            saveBtn.backgroundColor = UIColor.blueThemeColor
        case 1:
            otherBtn.isSelected = false
            outerVuHeightCons.constant = 560
            otherOuterVuHeightCons.constant = 0
            
            othherBtnImgVu.image = UIImage(named: "otherUnfilled")
            homeBtnImgVu.image = UIImage(named: "homeIcon")
            workBtnImgVu.image = UIImage(named: "workIconFilled")
            addressName = "Work"
            saveBtn.isEnabled = true
            saveBtn.backgroundColor = UIColor.blueThemeColor
        case 2:
            homeBtnImgVu.image = UIImage(named: "homeIcon")
            workBtnImgVu.image = UIImage(named: "workIcon")
            saveBtn.isEnabled = false
            saveBtn.backgroundColor = .gray
            if otherBtn.isSelected{
                otherBtn.isSelected = false
                outerVuHeightCons.constant = 560
                otherOuterVuHeightCons.constant = 0
                othherBtnImgVu.image = UIImage(named: "otherUnfilled")
            }else{
                otherBtn.isSelected = true
                outerVuHeightCons.constant = 600
                otherOuterVuHeightCons.constant = 40
                othherBtnImgVu.image = UIImage(named: "otherFilled")
                if secondHomeTF.text != ""{
                    saveBtn.isEnabled = true
                    saveBtn.backgroundColor = UIColor.blueThemeColor
                }
                
            }
        default:
            print("anything")
        }
        
    }
}

//MARK: - UITextFieldDelegate

extension AddLocationVC: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == secondHomeTF && textField.text?.count != 0{
            saveBtn.isEnabled = true
            saveBtn.backgroundColor = UIColor.blueThemeColor
            addressName = textField.text!
        }else{
            saveBtn.isEnabled = false
            saveBtn.backgroundColor = .gray
        }
    }
}


