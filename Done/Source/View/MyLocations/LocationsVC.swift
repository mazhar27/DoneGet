//
//  LocationsVC.swift
//  Done
//
//  Created by Mazhar Hussain on 22/06/2022.
//

import UIKit
import Combine

class LocationsVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var addLocationBtn: UIButton!
    @IBOutlet weak var infoImgVu: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var tableVu: UITableView!
    @IBOutlet weak var upperVuHeightCons: NSLayoutConstraint!
    @IBOutlet weak var locationLimitLabel: UILabel!
    
    //    MARK: - Variables
    
    var localAddresses = [CustomerAddress]()
    let viewModel =  LocationsViewModel()
    private var bindings = Set<AnyCancellable>()
    var deleteAddressTag = 0
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLocationBtn.setTitle("Add location".localized(), for: .normal)
        initialSetup()
        bindViewModel()
        
        // Do any additional setup after loading the view.
    }
    private func initialSetup(){
        addLeftBarButtonItem()
        self.title = "My Locations".localized()
        self.locationLimitLabel.text = "Add up-to maximum 5 addresses".localized()
        infoImgVu.image = UIImage(named: "infoIcon")!.withRenderingMode(.alwaysTemplate)
        infoImgVu.tintColor = .white
        let nib = UINib(nibName: "LocationcTVC", bundle: nil)
        self.tableVu.register(nib, forCellReuseIdentifier: "LocationcTVC")
        tableVu.separatorStyle = .none
        tableVu.delegate = self
        tableVu.dataSource = self
        getLocalAddresses()
        
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
            case .loaded(_):
                DispatchQueue.main.async { [weak self] in
//                    self?.showAlert("Done", message, .success)
                    self?.deleteAddress()
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &bindings)
   }
    func deleteAddress(){
        localAddresses.remove(at:deleteAddressTag)
      
        UserDefaults.addresses = localAddresses
       
        if localAddresses.count <= 5{
            upperVuHeightCons.constant = 50
        }
        
        tableVu.reloadData()
    }
    func getLocalAddresses() {
        localAddresses.removeAll()
        if let addresses = UserDefaults.addresses {
            localAddresses = addresses
        }
        if localAddresses.count != 0{
            if localAddresses.count >= 5{
                upperVuHeightCons.constant = 0
            }
           tableVu.reloadData()
        }else{
            upperVuHeightCons.constant = 50
        }
        
    }
    
    
    @IBAction func closeBtnTpd(_ sender: Any) {
        upperVuHeightCons.constant = 0
    }
    
    @IBAction func addLocationBtnTpd(_ sender: Any) {
        let storyboard = getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(MapVC.self) else {
            return
        }
        show(numberVC, sender: self)
    }
}

//MARK: - UITableView Delegate

extension LocationsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localAddresses.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationcTVC", for: indexPath) as! LocationcTVC
        cell.configureCell(addressObject: localAddresses[indexPath.row])
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTpd(sender:)), for: .touchUpInside)
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editBtnTpd(sender:)), for: .touchUpInside)
        
        return cell
    }
    @objc func deleteBtnTpd(sender: UIButton){
        deleteAddressTag = sender.tag
       viewModel.deleteAddress(addressID: String(localAddresses[sender.tag].addressId ?? 0))
        
       
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
    
}
