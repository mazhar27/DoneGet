//
//  NotificationsVC.swift
//  Done
//
//  Created by Mazhar Hussain on 21/06/2022.
//

import UIKit
import Combine

class NotificationsVC: BaseViewController {
    
    
    @IBOutlet weak var tableVu: UITableView!
    
    //    MARK: - Variables
    
    let viewModel = NotificationsVM()
    var notificationsModel : NotificationsModel?
    private var bindings = Set<AnyCancellable>()
    var notificationsData = [NotificationsData]()
    var notificationsDataNew = [NotificationsData]()
    //    var notifsDict = [:]
    var keysArray = [""]
    var groupData = [NotificationDataGrouped]()
    var currentPage = 1
    var lastPage = 0
    var isLoadingList  = false
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        if UserDefaults.userType == .customer{
            viewModel.getAllNotifications(page: "1")
        }
        bindViewModel()
        addLeftBarButtonItem()
        
        // Do any additional setup after loading the view.
    }
    deinit{
        print("notificaions deiitialized")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(false)
        if UserDefaults.userType == .provider{
            notificationsData = [NotificationsData]()
            notificationsModel?.data = [NotificationsData]()
            notificationsDataNew = [NotificationsData]()
           groupData = [NotificationDataGrouped]()
            self.navigationController?.navigationBar.topItem?.title = "Notifications".localized()
            viewModel.getAllNotifications(page: "1")
            
        }
    }
    //MARK: - Helping methods
    
    func initialSetup(){
        
        self.title = "Notifications".localized()
        let nib1 = UINib(nibName: "NotificationsTVC", bundle: nil)
        self.tableVu.register(nib1, forCellReuseIdentifier: "NotificationsTVC")
        tableVu.separatorStyle = .none
        tableVu.showsVerticalScrollIndicator = false
        tableVu.delegate = self
        tableVu.dataSource = self
        
        
    }
    private func bindViewModel() {
        viewModel.notificationsResult
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
            } receiveValue: { [weak self] notificationsdata in
                self?.notificationsModel = notificationsdata
                //                if let data = notificationsdata.data{
                //                self?.notificationsData = data
                //                    self?.groupedDateWise()
                //                }
                 if let links = notificationsdata.meta {
                    self?.lastPage = links.last_page ?? 0
                }
                if let data = notificationsdata.data {
                    if ((self?.isLoadingList) == true){
                        self?.notificationsDataNew = data
                        self?.notificationsData.append(contentsOf: data)
                        self?.groupedDateWise()
                    }else{
                        self?.notificationsDataNew = data
                        self?.notificationsData = data
                        self?.groupedDateWise()
                    }
                }
                self?.isLoadingList = false
                self?.tableVu.reloadData()
             }.store(in: &bindings)
    }
    func groupedDateWise(){
        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        for (index, element) in notificationsDataNew.enumerated(){
            
            var dateConv = dateFormatter.date(from: element.created_at ?? "")
            dateConv = Calendar.current.date(byAdding: .day, value: 1, to: dateConv!)!
            notificationsDataNew[index].date = dateConv ?? Date()
            print(notificationsDataNew[index].date)
        }
        notificationsModel?.data = notificationsDataNew
        let grouped = notificationsModel?.data?.sliced(by: [.year, .month, .day], for: \.date)
        for (key, value) in grouped! {
            print("key is - \(key) and value is - \(value)")
            let group = NotificationDataGrouped(date: key, notificationData: value)
            
            groupData.append(group)
            groupData = groupData.sorted(by: { ($0.date).compare($1.date) == .orderedDescending })
        }
   }
    //MARK: - IBActions
    
    override func btnBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: - UITableView Delegate

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupData[section].notificationData.count
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        //        return groupData.count
        if groupData.count == 0 {
            self.tableVu.setEmptyMessage("No data found".localized())
        } else {
            self.tableVu.restore()
        }
        return groupData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVC", for: indexPath) as! NotificationsTVC
        cell.selectionStyle = .none
        cell.configureCell(item: groupData[indexPath.section].notificationData[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableVu.frame.width, height: 40))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 20, width: headerView.frame.width-20, height: headerView.frame.height-10)
        label.translatesAutoresizingMaskIntoConstraints = false
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        let myString = formatter.string(from: groupData[section].date) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd MMMM yyyy"
        let myStringDate = formatter.string(from: yourDate!)
        label.text = myStringDate
        label.font = UIFont.init(name: "Poppins-SemiBold", size: 14)
        label.textColor = UIColor.black
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo:headerView.leadingAnchor , constant: 20),
            label.trailingAnchor.constraint(equalTo:headerView.trailingAnchor , constant: -20),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 0)
        ])
        return headerView
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height )){
            if currentPage < lastPage && !isLoadingList{
                isLoadingList = true
                currentPage += 1
                viewModel.getAllNotifications(page: String(currentPage))
            }
        }
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !isLoadingList && indexPath.row == groupData.count - 2 {
            if currentPage < lastPage && !isLoadingList{
                isLoadingList = true
                currentPage += 1
                viewModel.getAllNotifications(page: String(currentPage))
            }
        }
    }
}

extension Array {
    func sliced(by dateComponents: Set<Calendar.Component>, for key: KeyPath<Element, Date>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = Calendar.current.dateComponents(dateComponents, from: cur[keyPath: key])
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        
        return groupedByDateComponents
    }
}

