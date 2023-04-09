//
//  JobRejectionVC.swift
//  Done
//
//  Created by Mazhar Hussain on 12/09/2022.
//

import UIKit
import Combine

protocol JobStstusUpdate: AnyObject {
    func jobStatusChange(type: orderType)
    
}

class JobRejectionVC: BaseViewController {
    
    //MARK: - IBOutlets

    @IBOutlet weak var tbvu: UITableView!
    
    //MARK: - Variables
    
    var viewModel = JobRejectionViewModel()
    var selectedIndex = 0
    var selectedText = ""
    var serviceID = ""
    var orderumber = ""
    private var bindings = Set<AnyCancellable>()
    weak var delegate : JobStstusUpdate?
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        initialSetup()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helping Methods
    
    func initialSetup(){
        selectedText = viewModel.reasonsArray[0]
        let nib1 = UINib(nibName: "UpperTVC", bundle: nil)
        self.tbvu.register(nib1, forCellReuseIdentifier: "UpperTVC")
        let nib2 = UINib(nibName: "SelectionTVC", bundle: nil)
        self.tbvu.register(nib2, forCellReuseIdentifier: "SelectionTVC")
        let nib3 = UINib(nibName: "TextFieldTVC", bundle: nil)
        self.tbvu.register(nib3, forCellReuseIdentifier: "TextFieldTVC")
        let nib4 = UINib(nibName: "SelectionButtonsTVC", bundle: nil)
        self.tbvu.register(nib4, forCellReuseIdentifier: "SelectionButtonsTVC")
        tbvu.separatorStyle = .none
        tbvu.showsVerticalScrollIndicator = false
        tbvu.delegate = self
        tbvu.dataSource = self
       
    }
    func bindViewModel(){
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
                    self?.delegate?.jobStatusChange(type: .failed)
                    self?.dismiss(animated: false)
                }
                break
            case .idle:
                print("Loading")
                break
            }
        }.store(in: &bindings)
    }
    //MARK: - UIButton Action
    
    @IBAction func closeBtnTpd(_ sender: Any) {
        self.dismiss(animated: false)
    }
    

}
//MARK: - UITableView Delegates

extension JobRejectionVC: UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return viewModel.reasonsArray.count
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 230
        case 1:
            return 30
        case 2:
            if selectedIndex == 4{
            return 45
            }else{
                return 0
            }
        case 3:
            return 50
        default:
            return 0
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpperTVC", for: indexPath) as! UpperTVC
            cell.orderNumLbl.text = "#" + orderumber
            cell.selectionStyle = .none
           return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionTVC", for: indexPath) as! SelectionTVC
            cell.reasonLbl.text = viewModel.reasonsArray[indexPath.row]
            if indexPath.row == selectedIndex{
                cell.radioImgVu.image = UIImage(named: "circleFilled")
            }else{
                cell.radioImgVu.image = UIImage(named: "circleUnfilled")
            }
            cell.selectionBtn.tag = indexPath.row
            cell.selectionBtn.addTarget(self, action: #selector(selectionBtnTpd(sender:)), for: .touchUpInside)
            
           return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTVC", for: indexPath) as! TextFieldTVC
            cell.selectionStyle = .none
            cell.inputTF.delegate = self
           return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionButtonsTVC", for: indexPath) as! SelectionButtonsTVC
            cell.yesBtn.tag = indexPath.row
            cell.yesBtn.addTarget(self, action: #selector(yesBtnTpd(sender:)), for: .touchUpInside)
            cell.cancelBtn.tag = indexPath.row
            cell.cancelBtn.addTarget(self, action: #selector(cancelBtnTpd(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
           return cell
        default:
            return UITableViewCell()
        }
        
      
    }
    @objc func selectionBtnTpd(sender: UIButton){
        if sender.tag != 4{
        selectedText = viewModel.reasonsArray[sender.tag]
        }
        selectedIndex = sender.tag
         tbvu.reloadData()

    }
    @objc func yesBtnTpd(sender: UIButton){
        viewModel.setJobStatus(serviceID: serviceID, reason: selectedText, status: "3")
    }
    @objc func cancelBtnTpd(sender: UIButton){
        self.dismiss(animated: false)
    }
   
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        selectedText = textField.text!
    }
    
}



