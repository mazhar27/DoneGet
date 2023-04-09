//
//  MyOrdersVC.swift
//  Done
//
//  Created by Mazhar Hussain on 20/06/2022.
//

import UIKit
import Combine
import Localize_Swift

class MyOrdersVC: BaseViewController {
    
    //    MARK: - IBOutlets
    
    @IBOutlet weak var tableVu: UITableView!
    @IBOutlet weak var collectionVu: UICollectionView!
    
    //    MARK: - Variables
    var selectedTag : Int?
    let viewModel = MyOrdersVM()
    var ordertype = orderType.pending
    private var bindings = Set<AnyCancellable>()
    var ordersData = [Orders]()
    var jobsData = [Jobs]()
    var links : Links?
    var currentPage = 1
    var lastPage = 0
    var status = "1"
    var isLoadingList  = false
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButtonItem()
        self.title = "My Orders".localized()
        initialSetup()
        setupForProvider()
        callingApi()
        bindViewModel()
   }
    
    deinit{
        print("orders vc deinitialized")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    //MARK: - Helping Methods
    
    private func callingApi(){
        if UserDefaults.userType == .provider{
            viewModel.getAllProviderJobs(status: status, page: "1")
        }else{
            viewModel.getAllServices(status: "1", page: "1")
        }
    }
    private func tbvuDelegate(){
        
        tableVu.reloadData()
    }
    func setupForProvider(){
        if UserDefaults.userType == .provider{
            switch ordertype {
            case .pending:
                selectedTag = 0
                status  = "1"
                viewModel.items[selectedTag!].isSelected = true
            case .accepted:
                selectedTag = 1
                status  = "2"
                viewModel.items[selectedTag!].isSelected = true
            case .completed:
                selectedTag = 2
                status  = "4"
                viewModel.items[selectedTag!].isSelected = true
            case .failed:
                selectedTag = 3
                status  = "3"
                viewModel.items[selectedTag!].isSelected = true
            }
        }else{
            viewModel.items[0].isSelected = true
        }
    }
    func initialSetup(){
        viewModel.getItems()
        let nib1 = UINib(nibName: "OrdersTVC", bundle: nil)
        self.tableVu.register(nib1, forCellReuseIdentifier: "OrdersTVC")
        tableVu.separatorStyle = .none
        tableVu.showsVerticalScrollIndicator = false
        tableVu.delegate = self
        tableVu.dataSource = self
        let nib = UINib(nibName: "SegmentCVC", bundle: nil)
        collectionVu?.register(nib, forCellWithReuseIdentifier: "SegmentCVC")
        collectionVu.dataSource = self
        collectionVu.delegate = self
        collectionVu.showsHorizontalScrollIndicator = false
        collectionVu.isPagingEnabled = true
        collectionvuLayout()
    }
    func collectionvuLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (collectionVu.frame.width - 30) / 4, height: 40)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionVu!.collectionViewLayout = layout
    }
    
    private func bindViewModel() {
        viewModel.ordersResult
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
            } receiveValue: { [weak self] ordersData in
                if let links = ordersData.links {
                    self?.lastPage = links.last_page ?? 0
                }
                if let orders = ordersData.orders {
                    if ((self?.isLoadingList) == true){
                        self?.ordersData.append(contentsOf: orders)
                    }else{
                        self?.ordersData = orders
                    }
                    
                    self?.isLoadingList = false
                    self?.tableVu.reloadData()
                }
            }.store(in: &bindings)
        
        // getting provider jobs data
        viewModel.providerJobsResult
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
            } receiveValue: { [weak self] jobsdata in
                if let links = jobsdata.links {
                    self?.lastPage = links.last_page ?? 0
                }
                if let jobs = jobsdata.jobs {
                    if ((self?.isLoadingList) == true){
                        self?.jobsData.append(contentsOf: jobs)
                    }else{
                        self?.jobsData = jobs
                    }
                    self?.isLoadingList = false
                    self?.tableVu.reloadData()
                }
            }.store(in: &bindings)
    }
    
}


//MARK: - UICollectionView Delegate

extension MyOrdersVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SegmentCVC",for: indexPath) as! SegmentCVC
        cell.configureCell(item: viewModel.items[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionVu.frame.width - 30) / 4, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let selected = selectedTag{
            if indexPath.item == selectedTag{
                viewModel.items[selected].isSelected = true
            }else{
                
                viewModel.items[selected].isSelected = false
                selectedTag = indexPath.item
                viewModel.items[indexPath.item].isSelected = true
            }
        }else{
            viewModel.items[0].isSelected = false
            selectedTag = indexPath.item
            viewModel.items[selectedTag!].isSelected = true
        }
        switch indexPath.item{
        case 0:
            isLoadingList = false
            ordertype = orderType.pending
            if UserDefaults.userType == .customer{
                viewModel.getAllServices(status: "1", page: "1")
            }else{
                viewModel.getAllProviderJobs(status: "1", page: "1")
            }
            status = "1"
            
        case 1:
            isLoadingList = false
            ordertype = orderType.accepted
            status = "2"
            if UserDefaults.userType == .customer{
                viewModel.getAllServices(status: "2", page: "1")
            }else{
                viewModel.getAllProviderJobs(status: "2", page: "1")
            }
        case 2:
            ordertype = orderType.completed
            isLoadingList = false
            status = "4"
            if UserDefaults.userType == .customer{
                viewModel.getAllServices(status: "4", page: "1")
            }else{
                viewModel.getAllProviderJobs(status: "4", page: "1")
            }
        case 3:
            ordertype = orderType.failed
            isLoadingList = false
            status = "3"
            if UserDefaults.userType == .customer{
                viewModel.getAllServices(status: "3", page: "1")
            }else{
                viewModel.getAllProviderJobs(status: "3", page: "1")
            }
        default:
            ordertype = orderType.pending
        }
      collectionVu.reloadData()
        //        tableVu.reloadData()
        
    }
    
}

//MARK: - UITableView Delegate

extension MyOrdersVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.userType == .provider{
            if jobsData.count == 0 {
                self.tableVu.setEmptyMessage("No data found".localized())
            } else {
                self.tableVu.restore()
            }
            return jobsData.count
        }else{
            if ordersData.count == 0 {
                self.tableVu.setEmptyMessage("No data found".localized())
            } else {
                self.tableVu.restore()
            }
            return ordersData.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UserDefaults.userType == .provider && ordertype == .pending{
            return 240
        }else{
            return 280
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height )){
            if currentPage < lastPage && !isLoadingList{
                isLoadingList = true
                currentPage += 1
                if UserDefaults.userType == .provider{
                    viewModel.getAllProviderJobs(status: status, page: String(currentPage))
                }else{
                    viewModel.getAllServices(status: status, page: String(currentPage))
                }
            }
        }
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !isLoadingList && indexPath.row == ordersData.count - 2 {
            if currentPage < lastPage && !isLoadingList{
                isLoadingList = true
               currentPage += 1
                if UserDefaults.userType == .provider{
                    viewModel.getAllProviderJobs(status: status, page: String(currentPage))
                }else{
                    viewModel.getAllServices(status: status, page: String(currentPage))
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTVC", for: indexPath) as! OrdersTVC
        cell.selectionStyle = .none
        if UserDefaults.userType == .provider{
            cell.configureCellProvider(type: ordertype, item: jobsData[indexPath.item])
        }else{
            cell.configureCell(type: ordertype, item: ordersData[indexPath.item])
        }
        cell.inviceBtn.tag = indexPath.row
        cell.inviceBtn.addTarget(self, action: #selector(invoiceBtnTpd(sender:)), for: .touchUpInside)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserDefaults.userType == .provider{
            let storyboard = getProviderStoryboard()
            guard let VC = storyboard.instantiateViewController(JobDetailsVC.self) else {
                return
            }
            VC.delegate = self
            VC.type = ordertype
            VC.jobID = String(jobsData[indexPath.row].order_service_id ?? 0)
            show(VC, sender: self)
        }
    }
    @objc func invoiceBtnTpd(sender: UIButton){
        
        if ordertype == orderType.completed{
            let storyboard = getMainStoryboard()
            guard let VC = storyboard.instantiateViewController(InvoiceVC.self) else {
                return
            }
            VC.invoiceUrl = ordersData[sender.tag].invoice_url ?? ""
            VC.addInvoiceUrl = ordersData[sender.tag].additional_invoice ?? ""
            
            show(VC, sender: self)
       }
    }
}
extension MyOrdersVC: JobStstusUpdate{
    func jobStatusChange(type: orderType) {
        self.ordertype = type
        viewModel.items[selectedTag!].isSelected = false
        setupForProvider()
        collectionVu.reloadData()
        callingApi()
    }
}




