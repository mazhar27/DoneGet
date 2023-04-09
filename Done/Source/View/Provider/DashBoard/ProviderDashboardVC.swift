//
//  ProviderDashboardVC.swift
//  Done
//
//  Created by Mazhar Hussain on 05/09/2022.
//

import UIKit
import Localize_Swift
import Combine

class ProviderDashboardVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var logoImgVu: UIImageView!
    @IBOutlet weak var welcomeBackLbl: UILabel!
    @IBOutlet weak var helloLbl: UILabel!
    @IBOutlet weak var collectionVu: UICollectionView!
    
    //    MARK: - Variables
    
    let viewModel = ProviderDashboardViewModel()
    private var bindings = Set<AnyCancellable>()
    var providerStatsData : ProviderDashboardData?
    
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        viewModel.getSiteSettings()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        viewModel.getAllProviderStats()
    }
    
    //MARK: - Helping Methods
    
    private func initialSetup(){
        logoImgVu.layer.borderWidth = 1.0
        logoImgVu.layer.masksToBounds = false
        logoImgVu.layer.borderColor = UIColor.white.cgColor
        logoImgVu.layer.cornerRadius = logoImgVu.frame.size.width / 2
        logoImgVu.clipsToBounds = true
        let nib = UINib(nibName: "ProviderDashCVC", bundle: nil)
        collectionVu?.register(nib, forCellWithReuseIdentifier: "ProviderDashCVC")
        collectionVu.delegate = self
        collectionVu.dataSource = self
        collectionvuLayout()
        self.localization()
    }
    func collectionvuLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: (collectionVu.frame.width - 50) / 2, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        collectionVu!.collectionViewLayout = layout
    }
    private func localization(){
        welcomeBackLbl.text = "Welcome back to your dashboard".localized()
        self.tabBarItem.title = "Dashboard".localized()
    }
    func setUpUI(){
        let imageUrl = URL(string: providerStatsData?.logo_image ?? "")
        logoImgVu.sd_setImage(with: imageUrl,
                              placeholderImage: UIImage(named: ""))
        helloLbl.attributedText = viewModel.getAttributedTitle(title: providerStatsData?.company_name ?? "John Doe")
        
    }
    private func bindViewModel() {
        viewModel.providerStatsResult
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
            } receiveValue: { [weak self] providerData in
                self?.providerStatsData = providerData
                self?.setUpUI()
                self?.collectionVu.reloadData()
            }.store(in: &bindings)
        
        viewModel.settingsResult
            .sink{ [weak self] completion in
                switch completion {
                case .failure:
                    // Error can be handled here (e.g. alert)
                  
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] settingdata in
                
//                self.additionalInvoice = settingdata.
               adminPhone = settingdata.whatsapp_number ?? "+966508883408"
              
            }.store(in: &bindings)
    }
    private func moveToController(status: String, ordertype: orderType){
        let storyboard = getMainStoryboard()
        guard let VC = storyboard.instantiateViewController(MyOrdersVC.self) else {
            return
        }
        VC.ordertype = ordertype
        VC.status = status
        show(VC, sender: self)
    }
}

//MARK: - UICollectionView Delegate

extension ProviderDashboardVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return providerStatsData?.stats?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProviderDashCVC",for: indexPath) as! ProviderDashCVC
        if let providersStats = providerStatsData?.stats{
            cell.configureCell(item: providersStats[indexPath.item])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionVu.frame.width - 50) / 2, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let jobtype = providerStatsData?.stats?[indexPath.item].job_type ?? ""
        switch jobtype{
        case "1":
            moveToController(status: jobtype, ordertype: orderType.pending)
        case "2":
            moveToController(status: jobtype, ordertype: orderType.accepted)
        case "3":
            moveToController(status: jobtype, ordertype: orderType.failed)
        case "4":
            moveToController(status: jobtype, ordertype: orderType.completed)
        default:
            print("nothing")
            
        }
    }
    
    
}

