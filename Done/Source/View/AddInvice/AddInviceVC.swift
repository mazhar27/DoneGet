//
//  AddInviceVC.swift
//  Done
//
//  Created by Mazhar Hussain on 22/06/2022.
//

import UIKit
import Combine
import Localize_Swift


class AddInviceVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tbvu: UITableView!
    
   //MARK: - Variables
    
    let viewModel = AddInvoiceViewModel()
    var addInvoiceData = [AdditionalInvoiceData]()
    private var bindings = Set<AnyCancellable>()
    var deletedIndex : Int?
    
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButtonItem()
        initialSetup()
        viewModel.getInvoiceSummary()
        bindViewModel()
        
        // Do any additional setup after loading the view.
    }
    //MARK: - Helping Methods
    
    private func initialSetup(){
        self.title = "Additional Invoice".localized()
        let nib = UINib(nibName: "addInvoiceTVC", bundle: nil)
        self.tbvu.register(nib, forCellReuseIdentifier: "addInvoiceTVC")
        tbvu.separatorStyle = .none
        tbvu.delegate = self
        tbvu.dataSource = self
    }
    private func bindViewModel() {
        viewModel.addInvoiceResult
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
            } receiveValue: { [weak self] invicedata in
                self?.addInvoiceData = invicedata
                
                self?.tbvu.reloadData()
            }.store(in: &bindings)
        
        viewModel.$state.sink { [weak self] (state) in
            switch state {
            case .noInternet(let noInternetMsg):
                DispatchQueue.main.async {
                    self?.showAlert("Done".localized(), noInternetMsg, .warning)
                }
                if let index = self?.deletedIndex{
                    self?.addInvoiceData.remove(at: index)
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
                    self?.viewModel.getInvoiceSummary()
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &bindings)
    }
    private func moveToPaymentController(amount: String, invoiceID: String){
        let storyboard = getMainStoryboard()
        guard let VC = storyboard.instantiateViewController(PaymentVC.self) else {
            return
        }
        VC.amount = amount
        VC.orderNumber = invoiceID
        VC.isAdditionalInvoiceFlow = true
        VC.additionalPaymentSucceded = { [weak self] paymentId in
            self?.viewModel.changeAddInviceStatus(status: "2", addCostId: "", transactionID: String(paymentId))
        }
        show(VC, sender: self)
        
    }
    private func moveToSuccessController(orderID: String){
        let storyboard = getMainStoryboard()
        guard let VC = storyboard.instantiateViewController(TopUpSuccessVC.self) else {
            return
        }
        VC.comeFromInvoice = true
        VC.orderNumber = orderID
        show(VC, sender: self)
        
    }
    
}

//MARK: - UITableView Delegates



extension AddInviceVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addInvoiceData.count == 0 {
            self.tbvu.setEmptyMessage("No data found".localized())
        } else {
            self.tbvu.restore()
        }
        return addInvoiceData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addInvoiceTVC", for: indexPath) as! addInvoiceTVC
        cell.selectionStyle = .none
        cell.configureCell(item: addInvoiceData[indexPath.row])
        cell.acceptBtn.tag = indexPath.row
        cell.acceptBtn.addTarget(self, action: #selector(acceptBtnTpd(sender:)), for: .touchUpInside)
        cell.rejectBtn.tag = indexPath.row
        cell.rejectBtn.addTarget(self, action: #selector(rejectBtnTpd(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func acceptBtnTpd(sender: UIButton){
        let invoice = addInvoiceDataToSend(additionalAmount: addInvoiceData[sender.tag].additional_price ?? "", VAT: addInvoiceData[sender.tag].vat_amount ?? "", couponData: addInvoiceData[sender.tag].discount_amount ?? "", walletBalance: String(addInvoiceData[sender.tag].wallet_amount ?? 0.0), totalAmount: addInvoiceData[sender.tag].total_amount ?? "")
        let storyboard = getMainStoryboard()
        guard let vc = storyboard.instantiateViewController(AcceptAddInviceVC.self) else {
            return
        }
        vc.addinvoiceData = invoice
        vc.invoiceID = String(addInvoiceData[sender.tag].additional_cost_id ?? 0)
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
   @objc func rejectBtnTpd(sender: UIButton){
        deletedIndex = sender.tag
        viewModel.changeAddInviceStatus(status: "3", addCostId: String(addInvoiceData[sender.tag].additional_cost_id ?? 0), transactionID: "")
    }
    
    
}
//MARK: - Protocols Delegates

extension AddInviceVC: PushPaymentController{
    func ButtonTpd(isYesTpd: Bool, balanceamount: String) {
        print("nothing")
        if isYesTpd{
            moveToSuccessController(orderID: balanceamount)
        }
    }
    func addInvoiceData(amount: String, invoiceID: String) {
        moveToPaymentController(amount: amount, invoiceID: invoiceID)
        
    }
    
    
    
    
}
