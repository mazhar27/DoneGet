//
//  HomeVC.swift
//  Done
//
//  Created by Mazhar Hussain on 13/06/2022.
//

import UIKit
import Localize_Swift
import Combine
import SDWebImage

class HomeVC: BaseViewController{
    
    //MARK: - IBOutlets
    @IBOutlet weak var selectCatgegoryLbl: UILabel!
    @IBOutlet weak var whatYouLookingLbl: UILabel!
    @IBOutlet weak var tableVu: UITableView!
    @IBOutlet weak var collectionVu: UICollectionView!
    @IBOutlet weak var pager: UIPageControl!
    @IBOutlet weak var carousel: iCarousel!
    
    @IBOutlet weak var carousalHeightCons: NSLayoutConstraint!
    @IBOutlet weak var pagerHeightCons: NSLayoutConstraint!
    @IBOutlet weak var scrollContentVuHeightCons: NSLayoutConstraint!
    @IBOutlet weak var scrollVu: UIScrollView!
    //MARK: - Variables
    
    let viewModel =  HomeViewModel()
//    var items = ["bannerIcon","bannerIcon","bannerIcon"]
     var servicesData = [Main_services]()
    var selectedServiceIndex = 0
    var bannersAndPromotionsDate : [BanerData]?
    
    private var bindings = Set<AnyCancellable>()
   
  
    //MARK: - Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pager.numberOfPages = 0
        
        getbannerData()
        
        self.languageLocalization()
        setupScroll(height: 500)
        viewModel.getAllServices()
        addRightBarButtonItems()
        addLeftBarButtonItem()
        carousel.delegate = self
        carousel.dataSource = self
        carousel.type = .linear
        carousel.isPagingEnabled = true
        carousel.bounces = false
        initialSetup()
        bindViewModel()
        if UserDefaults.userType == .guest{
        addRightBarButtonItems(disabledNotif: true)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionvuLayout()
   }
    override func viewDidAppear(_ animated: Bool) {
        setBadge()
    }
    override func viewDidDisappear(_ animated: Bool) {
//        viewModel.servicesResult.cancel
    }
    
    override func viewWillLayoutSubviews() {
        
   }
    
    override func btnCartAction() {
        let storyboard = getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(CartVC.self) else {
            return
        }
        numberVC.comefromSideMenu = true
        show(numberVC, sender: self)
    }
    override func btnNotificationAction() {
        let storyboard = getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(NotificationsVC.self) else {
            return
        }
        show(numberVC, sender: self)
    }
    deinit {
        print("homevc deinit called")
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
            pagerHeightCons.constant = 0
            carousalHeightCons.constant = 0
        }
        
    }
    
    func initialSetup(){
//        self.title = "Home".localized()
        let nib = UINib(nibName: "CategoryCVC", bundle: nil)
        collectionVu?.register(nib, forCellWithReuseIdentifier: "CategoryCVC")
        collectionVu.showsHorizontalScrollIndicator = false
        collectionVu.isPagingEnabled = true
        let nib1 = UINib(nibName: "ServicesTVC", bundle: nil)
        tableVu.register(nib1, forCellReuseIdentifier: "ServicesTVC")
        tableVu.separatorStyle = .none
        tableVu.isScrollEnabled = false
        
        
    }
    func dataSources(){
        collectionVu.dataSource = self
        collectionVu.delegate = self
        tableVu.delegate = self
        tableVu.dataSource = self
        collectionVu.reloadData()
        tableVu.reloadData()
        
        
    }
    private func languageLocalization(){
        selectCatgegoryLbl.text = "Select your Category".localized()
        whatYouLookingLbl.text = "What are you looking for?".localized()
    }
    
    private func setupScroll(height: Int){
        let staticHeight = 450
        let totalScrollHeight = staticHeight + height
        scrollVu.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(totalScrollHeight))
        scrollContentVuHeightCons.constant = CGFloat(totalScrollHeight)
    }
    private func bindViewModel() {
        viewModel.servicesResult
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
            } receiveValue: { [weak self] services in
                
                if services.count > 0 {
                    self?.servicesData = services
                    self?.servicesData[0].isSelected = true
                    self?.title = self?.servicesData[0].service_title
                    self?.dataSources()
                    let height = ((self?.servicesData[self?.selectedServiceIndex ?? 0].sub_services?.count ?? 0) * 75)
                    self?.setupScroll(height: height)
                  
                    
                }
            }.store(in: &bindings)
        
        
    }
    //MARK: - UICollectionView FlowLayout
    func collectionvuLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (collectionVu.frame.width - 30) / 3, height: collectionVu.frame.height)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionVu!.collectionViewLayout = layout
    }
}

extension HomeVC:iCarouselDataSource, iCarouselDelegate{
    func numberOfItems(in carousel: iCarousel) -> Int {
        if self.bannersAndPromotionsDate != nil {
            self.pager.numberOfPages = self.bannersAndPromotionsDate!.count
            return self.bannersAndPromotionsDate!.count
        }else{
            self.pager.numberOfPages = 0
            return 0
        }
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let bannerView = Bundle.main.loadNibNamed("BannerView", owner: HomeVC?.self, options: nil)?.first as! BannerView
        var itemView: UIImageView
        itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: carousel.frame.width, height:  carousel.frame.height))

//        itemView.image = UIImage(named: items[index])
        bannerView.imgVu.sd_setImage(with: URL(string: self.bannersAndPromotionsDate![index].image!),
                          placeholderImage: UIImage(named: ""))
        itemView.cornerRadius = 10
        bannerView.promoCodeLbl.text = "#" + (bannersAndPromotionsDate?[index].name ?? "")
        if bannersAndPromotionsDate?[index].type == "recharge" || bannersAndPromotionsDate?[index].type == "signup" || bannersAndPromotionsDate?[index].type == "cashback"{
           
            if bannersAndPromotionsDate?[index].discount_type == "percentage"{
                bannerView.discountLbl.text = (bannersAndPromotionsDate?[index].discount ?? "0")  + " %" + "OFF".localized()
            }else{
                bannerView.discountLbl.text = "SAR " + (bannersAndPromotionsDate?[index].discount ?? "0")
            }
          
        }else{
            bannerView.discountLbl.text = (bannersAndPromotionsDate?[index].discount ?? "") + " %" + "OFF".localized()
        }
        
        let validFromFullDate    = bannersAndPromotionsDate?[index].valid_from ?? ""
        let validTillFullDate = bannersAndPromotionsDate?[index].valid_till ?? ""
        let fullNameArr = validFromFullDate.components(separatedBy: " ")
        let fullNameArr1 = validTillFullDate.components(separatedBy: " ")
        let validFrom    = fullNameArr[0]
        let validTill = fullNameArr1[0]
        
       
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: validFrom)  {
            bannerView.validFromLbl.text =  DateFormatter.DDmonYYYY.string(from: date)
        }
      
        if let date1 = formatter.date(from: validTill)  {
            bannerView.validTillLbl.text =  DateFormatter.DDmonYYYY.string(from: date1)
        }
        bannerView.imgVu.contentMode = .scaleAspectFill
        bannerView.descLbl.text = bannersAndPromotionsDate?[index].banner_tile ?? ""
        bannerView.setupUI()
        
        return bannerView
       
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        pager.currentPage = carousel.currentItemIndex
    }
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        print("selected index \(index)")
        self.gotoBannerView(selectedIndex : index)
    }
    private func gotoBannerView(selectedIndex : Int) -> () {
        let storyboard = getMainStoryboard()
        guard let bannerVC = storyboard.instantiateViewController(BannerAndPromotionsViewController.self) else {
            return
        }
        bannerVC.selectedIndex = selectedIndex
        bannerVC.modalPresentationStyle = .overCurrentContext
        bannerVC.modalTransitionStyle = .coverVertical
        present(bannerVC, animated: true)
        
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servicesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCVC",
                                                      for: indexPath) as! CategoryCVC
        cell.configureCell(item: servicesData[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: (collectionVu.frame.width - 30) / 3, height: self.collectionVu.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.title = servicesData[indexPath.item].service_title
      if selectedServiceIndex != indexPath.row{
            servicesData[indexPath.row].isSelected = true
            servicesData[selectedServiceIndex].isSelected = false
            let indexPath1 = IndexPath(item: selectedServiceIndex, section: 0)
            collectionVu.reloadItems(at: [indexPath])
            collectionVu.reloadItems(at: [indexPath1])
          
        }
        selectedServiceIndex = indexPath.item
        let height = ((servicesData[selectedServiceIndex].sub_services?.count ?? 0) * 75)
        self.setupScroll(height: height)
        tableVu.reloadData()
        
    }
    
    // to update the UIPageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicesData[selectedServiceIndex].sub_services?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesTVC", for: indexPath) as? ServicesTVC
        guard let cell = cell else {return UITableViewCell()}
        if let item = servicesData[selectedServiceIndex].sub_services?[indexPath.item]{
            cell.configureCell(item: item)
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SessionModel.shared.subServiceImage = (servicesData[selectedServiceIndex].sub_services?[indexPath.item].service_icon)!
        SessionModel.shared.subServiceID  = (servicesData[selectedServiceIndex].sub_services?[indexPath.item].service_id)!
        SessionModel.shared.subServiceName = (servicesData[selectedServiceIndex].sub_services?[indexPath.item].service_title)!
        SessionModel.shared.mainServiceImage = (servicesData[selectedServiceIndex].sub_services?[indexPath.item].service_icon)!
        let storyboard = getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(ServicesDetailsVC.self) else {
            return
        }
        numberVC.serviceDetails = (servicesData[selectedServiceIndex].sub_services?[indexPath.item].service_detail)!
//        numberVC.serviceID = String((servicesData[selectedServiceIndex].sub_services?[indexPath.item].service_id)!)
//        numberVC.titleLbl = String((servicesData[selectedServiceIndex].sub_services?[indexPath.item].service_title)!)
        show(numberVC, sender: self)
    }
}
extension UICollectionViewFlowLayout {

    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }
}


