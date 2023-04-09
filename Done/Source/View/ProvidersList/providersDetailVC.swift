//
//  providersDetailVC.swift
//  Done
//
//  Created by Mazhar Hussain on 17/06/2022.
//

import UIKit
import Combine
import Localize_Swift

class providersDetailVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var reserveBtn: UIButton!
    @IBOutlet weak var imageOuterVu: UIView!
    @IBOutlet weak var imgVu: UIImageView!
    @IBOutlet weak var servicesSelectedLbl: UILabel!
    @IBOutlet weak var selectDateLbl: UILabel!
    @IBOutlet weak var serviceDescLbl: UILabel!
    @IBOutlet weak var reserveSlotBtn: UIButton!
    @IBOutlet weak var selectTimeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var serviceLbl: UILabel!
    @IBOutlet weak var dateOuterVu: UIView!
    @IBOutlet weak var collectionVuHeightCons: NSLayoutConstraint!
    @IBOutlet weak var collectionVu: UICollectionView!
    
    //    MARK: - Variables
    
    let viewModel = ProvidersDetailsVM()
    var selectedTag : Int?
    var timeslotsData = [Slots]()
    private var bindings = Set<AnyCancellable>()
    var selected_Date = ""
    var selectedDateFormated = ""
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reserveBtn.setTitle("Reserve slot".localized(), for: .normal)
        self.servicesSelectedLbl.text = "Selected Services".localized()
        self.selectDateLbl.text = "Select Date".localized()
        self.selectTimeLbl.text = "Select Time".localized()
        viewModel.getAllProvidersTimeSlots(date: DateFormatter.yyyyMMddWithDash.string(from: Date()), serviceID: String(SessionModel.shared.subServiceID), providerID: SessionModel.shared.providerID)
        addLeftBarButtonItem()
        initialSetup()
        bindViewModel()
        selected_Date = DateFormatter.yyyyMMddWithDash.string(from: Date())
        selectedDateFormated = DateFormatter.DDmonthYYYY.string(from: Date())
        // Do any additional setup after loading the view.
    }
    deinit{
        print("provider details deinitilaed")
    }
    //MARK: - Helping Methods
    
    func initialSetup(){
        imageOuterVu.layer.masksToBounds = true
        imgVu.layer.masksToBounds = true
        self.title = SessionModel.shared.providerName
        serviceLbl.text = SessionModel.shared.subServiceName
        serviceDescLbl.text = SessionModel.shared.categoryName
        dateLbl.text = DateFormatter.DDmonthYYYY.string(from: Date())
        dateOuterVu.layer.masksToBounds = false
        let nib = UINib(nibName: "ProvidersDetailsCVC", bundle: nil)
        collectionVu?.register(nib, forCellWithReuseIdentifier: "ProvidersDetailsCVC")
        collectionVu.dataSource = self
        collectionVu.delegate = self
        collectionVu.showsHorizontalScrollIndicator = false
        collectionVu.isPagingEnabled = true
        collectionvuLayout()
        let imageUrl = URL(string: SessionModel.shared.subServiceImage)
        imgVu.sd_setImage(with: imageUrl,
                          placeholderImage: UIImage(named: ""))
        reserveBtn.isEnabled = false
        reserveBtn.backgroundColor = .gray
        reserveBtn.setTitleColor(UIColor.lightGrayThemeColor, for: .disabled)
        reserveBtn.setTitleColor(UIColor.white, for: .normal)
        if Localize.currentLanguage() == "ar"{
            serviceDescLbl.textAlignment = .right
        }
    }
    func collectionvuLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (collectionVu.frame.width - 30) / 3, height: 45)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        collectionVu!.collectionViewLayout = layout
    }
    private func bindViewModel() {
        viewModel.providersResult
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
            } receiveValue: { [weak self] slots in
                if slots.count > 0 {
                    self?.timeslotsData = slots
                    self?.collectionVu.reloadData()
                }
            }.store(in: &bindings)
    }
    
    //MARK: - IBActions
    
    @IBAction func reserveSlotBtnTpd(_ sender: Any) {
        viewModel.saveCartData()
        //        print(cartdata)
        
        let storyboard = getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(CartVC.self) else {
            return
        }
        show(numberVC, sender: self)
        
    }
    @IBAction func editBtnTpd(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: HomeVC.self)
    }
    
    @IBAction func dateSelectionBtnTpd(_ sender: Any) {
        
        RPicker.selectDate {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            let date = DateFormatter.yyyyMMddWithDash.string(from: selectedDate)
            self?.selected_Date = date
            print(selectedDate)
            guard let self = self else{return}
            self.viewModel.getAllProvidersTimeSlots(date: date, serviceID: String(SessionModel.shared.subServiceID), providerID: SessionModel.shared.providerID)
            self.dateLbl.text = DateFormatter.DDmonthYYYY.string(from: selectedDate)
            self.selectedDateFormated = DateFormatter.DDmonthYYYY.string(from: selectedDate)
        }
    }
    
}

//MARK: - UICollectionView Delegate

extension providersDetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeslotsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProvidersDetailsCVC",for: indexPath) as! ProvidersDetailsCVC
        cell.configureCell(item: timeslotsData[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionVu.frame.width - 30) / 3, height: 45)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if timeslotsData[indexPath.item].status == 1{
            reserveBtn.backgroundColor = UIColor.blueThemeColor
            reserveBtn.isEnabled = true
            if let tag = selectedTag{
                if tag != indexPath.item{
                    timeslotsData[indexPath.item].isSelected = true
                    timeslotsData[tag].isSelected = false
                    let indexPath1 = IndexPath(item: tag, section: 0)
                    collectionVu.reloadItems(at: [indexPath])
                    collectionVu.reloadItems(at: [indexPath1])
                    selectedTag = indexPath.item
                    SessionModel.shared.providerTimeSlotID = timeslotsData[indexPath.item].slot_id!
                    SessionModel.shared.timeslot_dateTime = selected_Date + " " + (timeslotsData[indexPath.item].slot_time_from ?? "")
                    
                    
                }
            }else{
                selectedTag = indexPath.item
                timeslotsData[indexPath.item].isSelected = true
                collectionVu.reloadItems(at: [indexPath])
                SessionModel.shared.providerTimeSlotID = timeslotsData[indexPath.item].slot_id!
                SessionModel.shared.timeslot_dateTime = selected_Date + " " + (timeslotsData[indexPath.item].slot_time_from ?? "")
            }
            
        }
    }
    
}
