//
//  WalletVC.swift
//  Done
//
//  Created by Mazhar Hussain on 23/06/2022.
//

import UIKit
import Combine
import SwiftSoup
import Localize_Swift

class WalletVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var transactionOuterVu: UIView!
    @IBOutlet weak var transactionsLbl: UILabel!
    @IBOutlet weak var spentLbl: UILabel!
    @IBOutlet weak var viewAllOuterVuHeightCons: NSLayoutConstraint!
    @IBOutlet weak var viewAllOuterVu: UIView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var transactionTitleLbl: UILabel!
    @IBOutlet weak var spentTitleLbl: UILabel!
    @IBOutlet weak var topUpLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var balanceTitleLbl: UILabel!
    @IBOutlet weak var walletImgVu: UIImageView!
    @IBOutlet weak var tableVu: UITableView!
    
    @IBOutlet weak var transactionsLabelInViewAll: UILabel!
    @IBOutlet weak var topUpButton: UIButton!
    
    //    MARK: - Variables
    let viewModel = WalletViewModel()
    var walletData : WalletData?
    private var bindings = Set<AnyCancellable>()
    var viewAll = false
    var transactionsData = [Transactions]()
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        Localization()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    deinit{
        print("wallet vc deinitialized")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if UserDefaults.userType == .provider{
            self.navigationController?.navigationBar.topItem?.title = "My Wallet".localized()
        }else{
            self.title = "My Wallet".localized()

        }
        viewModel.getWalletSummary()
        viewModel.getTransactonSummary()
        
    }

    private func Localization(){
        self.balanceTitleLbl.text = "Balance".localized()
        self.topUpLbl.text = "Top Up".localized()
        self.spentTitleLbl.text = "SPENT".localized()
        self.transactionTitleLbl.text = "TRANSACTIONS".localized()
        self.transactionsLabelInViewAll.text = "Transactions".localized()
        self.viewAllBtn.setTitle("View All".localized(), for: .normal)
        if Localize.currentLanguage() == "ar"{
            transactionOuterVu.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            spentLbl.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transactionsLbl.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transactionTitleLbl.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            spentTitleLbl.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }else{
            transactionOuterVu.transform = .identity
            spentLbl.transform = .identity
            transactionsLbl.transform = .identity
            transactionTitleLbl.transform = .identity
            spentTitleLbl.transform = .identity
        }
    }

    
    

    private func initialSetup(){
        transactionOuterVu.layer.masksToBounds = false
//        tableVu.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        addLeftBarButtonItem()

        let nib = UINib(nibName: "TransactionsTVC", bundle: nil)
        self.tableVu.register(nib, forCellReuseIdentifier: "TransactionsTVC")
        tableVu.separatorStyle = .none
        tableVu.delegate = self
        tableVu.dataSource = self
    }
    private func bindViewModel() {
        viewModel.walletSummaryResult
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
            } receiveValue: { [weak self] walletdata in
                self?.walletData = walletdata
                self?.setUIData()
                self?.tableVu.reloadData()
            }.store(in: &bindings)
        
        viewModel.transactionsSummaryResult
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
            } receiveValue: { [weak self] walletdata in
                if let transactionsdata = walletdata.transactions{
                    self?.transactionsData = transactionsdata
                }
                
            }.store(in: &bindings)
        
        
    }
    private func setUIData(){
        balanceLbl.text = "SAR " + String(walletData?.balance ?? 0)
        spentLbl.text = "SAR " + String(walletData?.total_spent ?? 0)
        transactionsLbl.text = String(walletData?.transactions_count ?? 0)
        let dateString = walletData?.updated_at ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateString) else {
            return
        }
        dateLbl.text = DateFormatter.DDDDMMMMyyyy.string(from: date)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func viewAllBtnTpd(_ sender: Any) {
        viewAllBtn.isHidden = true
        viewAll = true
        tableVu.reloadData()
    }
    @IBAction func topUpBtnTpd(_ sender: Any) {
        let storyboard = getMainStoryboard()
        guard let numberVC = storyboard.instantiateViewController(TopUpVC.self) else {
            return
        }
        numberVC.walletBalance = String(walletData?.balance ?? 0)
        show(numberVC, sender: self)
    }
}

//MARK: - UITableView Delegate

extension WalletVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewAll{
            if transactionsData.count == 0 {
                self.tableVu.setEmptyMessage("No data found".localized())
            } else {
                self.tableVu.restore()
            }
            return transactionsData.count
        }else{
            
            if (walletData?.transactions?.count ?? 0) == 0 {
                self.tableVu.setEmptyMessage("No data found".localized())
            } else {
                self.tableVu.restore()
            }
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewAll == false{
            return walletData?.transactions?.count ?? 0
        }else{
            return transactionsData[section].details?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsTVC", for: indexPath) as! TransactionsTVC
        cell.selectionStyle = .none
        if viewAll{
            if let details = transactionsData[indexPath.section].details?[indexPath.row]{
                cell.configureCellViewAll(item: details )
            }
        }else{
            if let transac = walletData?.transactions{
                cell.configureCell(item: transac[indexPath.row])
            }
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableVu.frame.width, height: 30))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        if Localize.currentLanguage() == "ar"{
            label.frame = CGRect.init(x: -20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        }
        let dateString = transactionsData[section].date ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString)  {
            label.text =  DateFormatter.DDDDMMMMyyyy.string(from: date)
        }
        
        
        label.font = UIFont.init(name: "Poppins-SemiBold", size: 14)
        
        label.textColor = UIColor.blueThemeColor
        headerView.addSubview(label)
        return headerView
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewAll{
            return 30
        }else{
            return 0
        }
    }
    
}

