//
//  TimeSlotVC.swift
//  Done
//
//  Created by Dtech Mac on 08/09/2022.
//

import UIKit
import Combine
import Localize_Swift

class TimeSlotVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var manageSlotsLbl: UILabel!
    @IBOutlet weak var selectDateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var swipeLbl: UILabel!
    
    //MARK: - Variables
    
    var currentSelected = 0
    var dateDataArray = [String]()
    let viewModel = TimeSlotViewModel()
    private var bindings = Set<AnyCancellable>()
    var providerTimeSlots = [Slots]()
    var selectedSlotIndex = 0
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        Localization()
        initailSetup()
        collectionvuLayout()
        viewModel.getAllProviderTimeSlots(date: dateDataArray[0])
        self.tabBarItem.title = "Time Slots".localized()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    
    //MARK: - Helping Methods
    
    func initailSetup() {
        dateDataArray = viewModel.gettingDateData()
        let nib1 = UINib(nibName: "TimeSlotCVC", bundle: nil)
        self.collectionV.register(nib1, forCellWithReuseIdentifier: "TimeSlotCVC")
        let nib2 = UINib(nibName: "TimeSlotTVC", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: "TimeSlotTVC")
        setCurrentDate()
    }
    private func Localization(){
        titleLbl.text = "Manage Time Slots".localized()
        selectDateLbl.text = "Select Date".localized()
        manageSlotsLbl.text = "Manage Time Slots".localized()
        swipeLbl.text = "Swipe".localized()
    }
    func setCurrentDate(){
        let dateString = dateDataArray[currentSelected]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else {
            return
        }
        dateLbl.text = DateFormatter.monthYYYY.string(from: date)
    }
    private func bindViewModel() {
        viewModel.timeSlotsResult
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
            } receiveValue: { [weak self] providerData in
                
                if let data = providerData.slots{
                    self?.providerTimeSlots = data
                }
                self?.tableView.reloadData()
                
                
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
                    //                    self?.deleteAddress()
                    let bookingStatus = self?.providerTimeSlots[self?.selectedSlotIndex ?? 0].booking_status
                    if bookingStatus == 1{
                        self?.providerTimeSlots[self?.selectedSlotIndex ?? 0].booking_status = 0
                    }else{
                        self?.providerTimeSlots[self?.selectedSlotIndex ?? 0].booking_status = 1
                    }
                    self?.reloadRow()
                    
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &bindings)
        
        
    }
    
    //MARK: - UICollectionViewFlowLayout
    
    func collectionvuLayout(){
        collectionV.dataSource = self
        collectionV.delegate = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (collectionV.frame.width - 30) / 4, height: 80)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        collectionV!.collectionViewLayout = layout
    }
    
    func reloadRow(){
        tableView.reloadRows(at: [IndexPath(row: selectedSlotIndex, section: 0)], with: .none)
    }
    
    
}
//MARK: - UIColletionView Delegates

extension TimeSlotVC:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dateDataArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCVC", for: indexPath) as! TimeSlotCVC
        cell.outerView.backgroundColor = currentSelected == indexPath.row ? UIColor.blueThemeColor : UIColor.white
        
        if currentSelected == indexPath.row
        {
            cell.lblTitleDay.textColor = UIColor.white
            cell.lblTitleDayNumber.textColor = UIColor.white
            let indexPath1 = IndexPath(item: currentSelected, section: 0)
            collectionV.reloadItems(at: [indexPath1])
        }
        else
        {
            cell.lblTitleDay.textColor = UIColor.blueThemeColor
            cell.lblTitleDayNumber.textColor = UIColor.blueThemeColor
        }
        cell.configureCell(item: dateDataArray[indexPath.item])
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        currentSelected = indexPath.row
        viewModel.getAllProviderTimeSlots(date: dateDataArray[indexPath.item])
        self.collectionV.reloadData()
        setCurrentDate()
    }
    
    
}
//MARK: - UITableView Delegates

extension TimeSlotVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if providerTimeSlots.count == 0 {
            self.tableView.setEmptyMessage("No data found".localized())
        } else {
            self.tableView.restore()
        }
        return providerTimeSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSlotTVC", for: indexPath) as! TimeSlotTVC
        cell.btnSwitch.tag = indexPath.row
        cell.selectionStyle = .none
        cell.btnSwitch.addTarget(self, action: #selector(switchBtnTpd(sender:)), for: .valueChanged)
        cell.configureCell(item: providerTimeSlots[indexPath.row])
        return cell
    }
    @objc func switchBtnTpd(sender: UISwitch){
        selectedSlotIndex = sender.tag
        let slotID =  String(providerTimeSlots[sender.tag].slot_id ?? 0)
        var status = ""
        if sender.isOn{
            status = "1"
        }else{
            status = "0"
        }
        viewModel.changeTimeSlot(slotId:slotID, date: dateDataArray[currentSelected], status: status)
    }
    
    
}

