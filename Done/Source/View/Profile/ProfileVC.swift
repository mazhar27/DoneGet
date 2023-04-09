//
//  ProfileVC.swift
//  Done
//
//  Created by Mazhar Hussain on 24/06/2022.
//

import UIKit
import Localize_Swift
import Combine
import SDWebImage

class ProfileVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var updatePictureOuterVu: UIView!
    @IBOutlet weak var emailVerificationLbl: UILabel!
    @IBOutlet weak var codeTextField: OTPCodeTextField!
    @IBOutlet weak var updatePictureBtn: UIButton!
    @IBOutlet weak var confirmChangesBtn: UIButton!
    @IBOutlet weak var pinTitleLbl: UILabel!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var mobileTitleLbl: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailTitleLbl: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var fullNameTitleLbl: UILabel!
    @IBOutlet weak var arBtn: UIButton!
    @IBOutlet weak var engBtn: UIButton!
    @IBOutlet weak var profileImgVu: UIImageView!
    @IBOutlet weak var btnOuterV: UIView!
    @IBOutlet weak var btnUpdeteProfile: UIButton!
    @IBOutlet weak var btnOuterHeight: NSLayoutConstraint!
    @IBOutlet weak var btnProfileCenter: NSLayoutConstraint!
    //    MARK: - Variables
//    var titleText = ""
//    var data = ""
//    var controllerTitle = ""
    let viewModel =  ProfileViewModel()
    private var bindings = Set<AnyCancellable>()
    var CustomerProfileData: ProfileData?
    var buttonIndex = 0
    let imagePicker = UIImagePickerController()
    var profileImage : UIImage?
    var imageUploaded = false
    weak var delegate : editDelegate?
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        self.Localization()
        configureOTPField()
       bindViewModel()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
//        self.navigationController?.navigationBar.isHidden = true
        viewModel.getUserProfile()
        configureCell(type: .provider)
    }
    
    private func initialSetup(){
      
        profileImgVu.layer.borderWidth = 1.0
        profileImgVu.layer.masksToBounds = false
        profileImgVu.layer.borderColor = UIColor.white.cgColor
        profileImgVu.layer.cornerRadius = profileImgVu.frame.size.width / 2
        profileImgVu.clipsToBounds = true
        nameTF.isUserInteractionEnabled = false
        emailTF.isUserInteractionEnabled = false
        mobileTF.isUserInteractionEnabled = false
        
        
    }
    private func Localization(){
        updatePictureBtn.setTitle("Change Picture".localized(), for: .normal)
        fullNameTitleLbl.text = "Full Name".localized()
        emailTitleLbl.text = "Email".localized()
        mobileTitleLbl.text = "Mobile Number".localized()
        pinTitleLbl.text = "Login Pin".localized()
        if Localize.currentLanguage() == "ar" {
            NSLayoutConstraint(item: updatePictureOuterVu!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: profileImgVu, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
            backBtn.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
            nameTF.textAlignment = .right
            mobileTF.textAlignment = .right
            emailTF.textAlignment = .right
        
        }
    }
    private func configureOTPField() {
       
        codeTextField.defaultCharacter = "*"
        codeTextField.configure()
//        codeTextField.didEnterLastDigit = { [weak self] code in
//          print(code)
//
//        }
        codeTextField.textColor = UIColor.lightGrayThemeColor
        codeTextField.isEnabled = false
    }
    private func bindViewModel() {
        viewModel.profileResult
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
            } receiveValue: { [weak self] profile in
                self?.CustomerProfileData = profile
                self?.setProfileData()
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
            case .loaded(_):
                DispatchQueue.main.async { [weak self] in
                    if let image = self?.profileImage{
                    self?.profileImgVu.image = image
                        self?.viewModel.getUserProfile()
                }
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &bindings)
    }
    private func setProfileData(){
        nameTF.text = CustomerProfileData?.name
        emailTF.text = CustomerProfileData?.email
        mobileTF.text = CustomerProfileData?.phone
        let imageUrl = URL(string: CustomerProfileData?.image ?? "")
        if UserDefaults.userType == .customer{
        UserDefaults.LoginUser?.profileImage = CustomerProfileData?.image ?? ""
        }
        profileImgVu.sd_setImage(with: imageUrl,
                                 placeholderImage: UIImage(named: ""))
        if CustomerProfileData?.verify_email == 0{
            emailVerificationLbl.text = "(Not Verified)".localized()
            emailVerificationLbl.textColor = UIColor.init(hexString: "#DB3F3F")
        }else{
            emailVerificationLbl.text = "(Verified)".localized()
            emailVerificationLbl.textColor = UIColor.init(hexString: "#007DC6")
        }
    }
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileVC" {
            if let viewController = segue.destination as? EditProfileVC {
//                viewController.titleText = titleText
//                viewController.dataText = data
//                viewController.controllerTitle = controllerTitle
                switch buttonIndex{
                case 0:
                    viewController.titleText = "Full Name".localized()
                    viewController.dataText = nameTF.text!
                    viewController.controllerTitle = "Edit Name".localized()
                    viewController.key = "1"
                case 1:
                    viewController.titleText = "Confirm your email address".localized()
                    viewController.dataText = emailTF.text!
                    viewController.controllerTitle = "Edit Email".localized()
                    viewController.key = "2"
                case 2:
                    viewController.titleText = "Confirm your mobile number".localized()
                    viewController.dataText = mobileTF.text!
                    viewController.controllerTitle = "Edit Mobile Number".localized()
                    viewController.key = "3"
                    
                default:
                    print("")
                }
                
            }
        }
        
    }

    
    //MARK: - IBActions
    
    @IBAction func editTFBtnTpd(_ sender: UIButton) {
        buttonIndex = sender.tag
        switch sender.tag{
        case 0,1,2:
//            self.titleText = "Full Name"
//            self.data = nameTF.text!
//            self.controllerTitle = "Edit Name"
            self.performSegue(withIdentifier: "editProfileVC", sender: self)
        case 3:
            let storyboard = getMainStoryboard()
            guard let numberVC = storyboard.instantiateViewController(updatePinVC.self) else {
                return
            }
            show(numberVC, sender: self)
        default:
            print("anything")
        }
    }
    func configureCell(type:changeItem){
        switch type{
            
        case .customer:
            btnProfileCenter.constant = -50
            btnOuterHeight.constant = 120
            btnOuterV.isHidden = false
//            btnUpdeteProfile.setTitle("Update Picture", for: .normal)
        case .provider:
            btnProfileCenter.constant = -60
            btnOuterHeight.constant = 0
            btnOuterV.isHidden = true
//            btnUpdeteProfile.setTitle("Change Picture", for: .normal)
        }
    }
    @IBAction func backBtnTpd(_ sender: Any) {
        if UserDefaults.userType == .provider{
            delegate?.providerEnterInformation(image: (CustomerProfileData?.image ?? ""), name: nameTF.text!, email: emailTF.text!, phoneNumber: mobileTF.text!)
        }
    self.navigationController?.popViewController(animated: true)
            
    }
    @IBAction func languageBtnTpd(_ sender: UIButton) {
        if sender.tag == 0{
            engBtn.backgroundColor = UIColor.blueThemeColor
            engBtn.setTitleColor(UIColor.white, for: .normal)
            engBtn.tintColor = UIColor.white
            arBtn.backgroundColor = UIColor.white
            arBtn.setTitleColor(UIColor.blueThemeColor, for: .normal)
            arBtn.tintColor = UIColor.blueThemeColor
            Localize.setCurrentLanguage("en")
        }else{
            arBtn.backgroundColor = UIColor.blueThemeColor
            arBtn.setTitleColor(UIColor.white, for: .normal)
            arBtn.tintColor = UIColor.white
            engBtn.backgroundColor = UIColor.white
            engBtn.setTitleColor(UIColor.blueThemeColor, for: .normal)
            engBtn.tintColor = UIColor.blueThemeColor
            Localize.setCurrentLanguage("ar")
            
        }
        
    }
   
    
    @IBAction func updatePictureBtnTpd(_ sender: Any) {
        addImagePicker(title: "", msg: "", imagePicker: imagePicker)
    }
    @IBAction func confirmChangesBtnTpd(_ sender: Any) {
      
    }
    func saveChanges(){
        if let image = profileImage{
            imageUploaded = true
            viewModel.updateProfilePic(key: "5", images: [image])
        }
        
    }
    //    alert to open image picker
        func addImagePicker(title: String, msg: String, imagePicker: UIImagePickerController) {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ [weak self](UIAlertAction)in
                print("Camera button clicked")
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                self?.present(imagePicker, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Photos", style: .default , handler:{ [weak self] (UIAlertAction)in
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
               
                self?.present(imagePicker, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))
            
           present(alert, animated: true, completion: {
                print("completion block")
            })
        }
}

extension ProfileVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           profileImage = pickedImage
            saveChanges()
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

enum changeItem{
    case customer, provider
}
