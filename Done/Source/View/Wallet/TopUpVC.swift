//
//  TopUpVC.swift
//  Done
//
//  Created by Mazhar Hussain on 23/06/2022.
//

import UIKit
import Localize_Swift

class TopUpVC: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var enterAmountLbl: UILabel!
    @IBOutlet weak var selectAmountTitleLbl: UILabel!
    
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var sarLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var currentBalanceLbl: UILabel!
    @IBOutlet weak var currentBalanceTitleLbl: UILabel!
    @IBOutlet weak var addFundsBtn: UIButton!
    @IBOutlet weak var collectionVu: UICollectionView!
    @IBOutlet weak var amountOuterVu: UIView!
    
    //    MARK: - Variables
    
    let viewModel = TopUpVM()
    var selectedTag : Int?
    var amount = ""
    var walletBalance = ""
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButtonItem()
        self.Localization()
        initialSetup()
    }
    
    func initialSetup(){
        //        addFundsBtn.isEnabled = false
        self.title = "Top Up".localized()
        addFundsBtn.isEnabled = false
        addFundsBtn.backgroundColor = .gray
        addFundsBtn.setTitleColor(UIColor.white, for: .disabled)
        currentBalanceLbl.text = "SAR " + walletBalance
        amountOuterVu.layer.masksToBounds = false
        viewModel.getItems()
        let nib = UINib(nibName: "ProvidersDetailsCVC", bundle: nil)
        collectionVu?.register(nib, forCellWithReuseIdentifier: "ProvidersDetailsCVC")
        collectionVu.dataSource = self
        collectionVu.delegate = self
        collectionVu.showsHorizontalScrollIndicator = false
        collectionVu.isPagingEnabled = true
        collectionvuLayout()
//        amountTF.delegate = self
        amountTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
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
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text != ""{
            addFundsBtn.isEnabled = true
            amount = textField.text!
            addFundsBtn.backgroundColor = UIColor.blueThemeColor
            
        }else{
            addFundsBtn.isEnabled = false
            addFundsBtn.backgroundColor = .gray
           
        }
    }
    private func Localization(){
        currentBalanceTitleLbl.text = "Current Wallet Balance".localized()
        enterAmountLbl.text = "Enter Amount".localized()
        descLbl.text = "Top Up should be min SAR 200".localized()
        selectAmountTitleLbl.text = "Or Select an amount".localized()
        addFundsBtn.setTitle("Add Funds to Wallet".localized(), for: .normal)
        if Localize.currentLanguage() == "ar"{
            amountTF.textAlignment = .right
        }else{
            amountTF.textAlignment = .left
        }
    }
    
    
    //MARK: - IBActions
    
    @IBAction func addFundsBtnTpd(_ sender: Any) {
        let amounInt = Int(amount) ?? 0
        if amounInt > 0{
        let storyboard = getMainStoryboard()
        guard let vc = storyboard.instantiateViewController(ConfirmPaymentVC.self) else {
            return
        }
        vc.amount = amount
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: true)
//        show(vc, sender: self)

    }else{
        self.showAlert("Done", "Please enter the amount greater than zero".localized(), .error)
    }
}
}


//MARK: - UICollectionView Delegate

extension TopUpVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProvidersDetailsCVC",for: indexPath) as! ProvidersDetailsCVC
        cell.configureTopUp(item: viewModel.items[indexPath.item])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionVu.frame.width - 30) / 3, height: 45)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        addFundsBtn.isEnabled = true
        if let selected = selectedTag{
            if indexPath.item == selectedTag{
                viewModel.items[selected].isSelected.toggle()
            }else{
                viewModel.items[selected].isSelected = false
                selectedTag = indexPath.item
                viewModel.items[indexPath.item].isSelected = true
            }
        }else{
            selectedTag = indexPath.item
            viewModel.items[selectedTag!].isSelected = true
        }
        amount = viewModel.items[indexPath.item].title
        amountTF.text = viewModel.items[indexPath.item].title
        addFundsBtn.isEnabled = true
        addFundsBtn.backgroundColor = UIColor.blueThemeColor
        collectionVu.reloadData()
    }
    
}

//MARK: - UITextField Delegate
extension TopUpVC: UITextFieldDelegate{
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {

        if textField.text != ""{
            addFundsBtn.isEnabled = true
            amount = textField.text!
            addFundsBtn.backgroundColor = UIColor.blueThemeColor

        }else{
            addFundsBtn.isEnabled = false
            addFundsBtn.backgroundColor = .gray

        }
        return true
    }
    
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != ""{
            addFundsBtn.isEnabled = true
            amount = textField.text!
            addFundsBtn.backgroundColor = UIColor.blueThemeColor
            
        }else{
            addFundsBtn.isEnabled = false
            addFundsBtn.backgroundColor = .gray
           
        }
    }
}

extension TopUpVC: PushPaymentController{
    func ButtonTpd(isYesTpd: Bool, balanceamount: String) {
        let storyboard = getMainStoryboard()
               guard let numberVC = storyboard.instantiateViewController(PaymentVC.self) else {
                   return
               }
               numberVC.amount = balanceamount
               numberVC.comefromWallet = true
               show(numberVC, sender: self)
        
    }
    
    func addInvoiceData(amount: String, invoiceID: String) {
        print("nothing")
    }
    
    
    
    
}

