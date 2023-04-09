//
//  ServicesDetailsVC.swift
//  Done
//
//  Created by Mazhar Hussain on 14/06/2022.
//

import UIKit
import Combine
import WebKit
import Localize_Swift

class ServicesDetailsVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableVu: UITableView!
    
    //MARK: - Variables
    var categoriesData = [Categories]()
    var filteredData = [Categories]()
    let viewModel =  ServicesViewModel()
    var serviceDetails = ""
    var twoSections = true
    var searchKeyword = ""
    private var bindings = Set<AnyCancellable>()
    var isFilteredMode = false
    
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        //        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    //MARK: - LifeCycleController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getAllCategories(serviceID: String(SessionModel.shared.subServiceID))
        bindViewModel()
        initialSetup()
        addLeftBarButtonItem()
        // Do any additional setup after loading the view.
        
        
    }
    deinit {
        print("services details deinit called")
    }
    func animateVu(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            // Put your code which should be executed with a delay here
            self?.twoSections = false
            guard let self = self else{return}
            UIView.transition(with: self.tableVu,
                              duration: 0.5,
                              options: [.transitionCurlUp, .showHideTransitionViews],
                              animations: {
                self.tableVu.reloadData()
                self.addRightBarButtonItem(imageName: "infoIcon")
                // create custom animation
                let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
                animation.duration = 0.6
                animation.values = [-8.0, 7.0, -6.0, 5.0, -4.0, 3.0, -2.0, 1.0, 0.0 ]
                // applying the animation
                self.navigationItem.rightBarButtonItem?.animate(with: animation)
                
            }) // left out the u
        }
        
    }
    private func initialSetup(){
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        self.title = SessionModel.shared.subServiceName
        let nib1 = UINib(nibName: "ServicesDetailsTVC", bundle: nil)
        let nib2 = UINib(nibName: "ServicesHeader", bundle: nil)
        let nib3 = UINib(nibName: "ServicesDescriptionTVC", bundle: nil)
        tableVu.register(nib1, forCellReuseIdentifier: "ServicesDetailsTVC")
        tableVu.register(nib2, forCellReuseIdentifier: "ServicesHeader")
        tableVu.register(nib3, forCellReuseIdentifier: "ServicesDescriptionTVC")
        tableVu.separatorStyle = .none
        //        tableVu.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
    }
    override func rightBarButtonAction() {
        twoSections.toggle()
        tableVu.reloadData()
    }
    private func bindViewModel() {
        viewModel.categoriesResult
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
            } receiveValue: { [weak self] categories in
                if categories.count > 0 {
                    self?.categoriesData = categories
                    self?.tableVu.delegate = self
                    self?.tableVu.dataSource = self
                    self?.tableVu.reloadData()
                    self?.animateVu()
                }
            }.store(in: &bindings)
    }
    
    
}
//MARK: - UITableView Delegates
extension ServicesDetailsVC: UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if twoSections{
            return 2
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && twoSections{
            return 1
        }else{
            return isFilteredMode == true ? filteredData.count : categoriesData.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && twoSections{
            return 350
            
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if twoSections{
            if indexPath.section == 1{
                let  cell = tableView.dequeueReusableCell(withIdentifier: "ServicesDetailsTVC", for: indexPath) as? ServicesDetailsTVC
                guard let cell = cell else{return UITableViewCell()}
                cell.titleLbl.text = categoriesData[indexPath.row].category_title
                return cell
            }else{
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "ServicesDescriptionTVC", for: indexPath) as? ServicesDescriptionTVC
                guard let cell2 = cell2 else{return UITableViewCell()}
                
                let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
                let htmlText = serviceDetails
                cell2.webOuterVu.addSubview(webView)
                webView.loadHTMLString(headerString + htmlText, baseURL: nil)
                NSLayoutConstraint.activate([
                    webView.topAnchor
                        .constraint(equalTo:  cell2.webOuterVu.safeAreaLayoutGuide.topAnchor),
                    webView.leftAnchor
                        .constraint(equalTo:  cell2.webOuterVu.safeAreaLayoutGuide.leftAnchor),
                    webView.bottomAnchor
                        .constraint(equalTo:  cell2.webOuterVu.safeAreaLayoutGuide.bottomAnchor),
                    webView.rightAnchor
                        .constraint(equalTo:  cell2.webOuterVu.safeAreaLayoutGuide.rightAnchor)
                ])
                
                return cell2
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesDetailsTVC", for: indexPath) as? ServicesDetailsTVC
            guard let cell = cell else{return UITableViewCell()}
            if isFilteredMode{
                cell.titleLbl.text = filteredData[indexPath.row].category_title
            }else{
                cell.titleLbl.text = categoriesData[indexPath.row].category_title
            }
            cell.selectionStyle = .none
            return cell
        }
        //
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "ServicesHeader") as? ServicesHeader
        guard let headerCell = headerCell else{return UIView()}
        headerCell.frame = CGRect(x: 0, y: 0, width: tableVu.frame.size.width, height: 90)
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableVu.frame.width, height: 30))
       let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 20, width: headerView.frame.width-10, height: headerView.frame.height-10)
        if Localize.currentLanguage() == "ar"{
            label.frame = CGRect.init(x: -20, y: 20, width: headerView.frame.width-10, height: headerView.frame.height-10)
        }
        label.text = "Description".localized()
        label.font = UIFont.init(name: "Poppins-Bold", size: 14)
        label.textColor = UIColor.grayTextColor
        headerView.addSubview(label)
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableVu.frame.width, height: 90))
        view.addSubview(headerCell)
        headerCell.searchTF.delegate = self
        if searchKeyword != ""{
            headerCell.searchTF.text = searchKeyword
        }
        if twoSections{
            if section == 1{
                return view
            }else{
                return headerView
            }
        }else{
            return view
        }
   }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if twoSections{
            if section == 0{
                return 30
            }else{
                return 90
            }
        }else{
            return 90
        }
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isFilteredMode{
            SessionModel.shared.categoryID = String(categoriesData[indexPath.row].category_id!)
            SessionModel.shared.categoryName = (categoriesData[indexPath.row].category_title!)
            
        }else{
            SessionModel.shared.categoryID = String(filteredData[indexPath.row].category_id!)
            SessionModel.shared.categoryName = (filteredData[indexPath.row].category_title!)
        }
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ServicesDetailsForm") as? ServicesDetailsForm
        guard let vc = vc else{return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text! == "" ? (isFilteredMode = false) : (isFilteredMode = true)
        filteredData.removeAll()
        searchKeyword = textField.text!
        if isFilteredMode{
            for i in categoriesData {
                let title = i.category_title ?? ""
                if title.lowercased().contains(textField.text!.lowercased()) {
                    filteredData.append(i)
                }
            }
            tableVu.reloadData()
        }
        
        tableVu.reloadData()
    }
    
}


