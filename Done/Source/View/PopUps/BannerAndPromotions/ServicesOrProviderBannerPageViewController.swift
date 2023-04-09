//
//  ServicesOrProviderBannerPageViewController.swift
//  Done
//
//  Created by Adeel Hussain on 11/11/2022.
//

import UIKit
import Localize_Swift

enum ServicesSectionType : String {
    case header = "HeaderCell" , validity = "validity" , provider = "provider" , notes = "notes"
}
enum discountType : String {
    case percetage = "percentage",  fix = "fix"
}
struct IndentDataStruct {
    
    var level: Int = 0
    var title : String = ""
    var data: [Any]?
    var isNeedToHideFisrtSeperator : Bool = false
    var isNeedToHideBottomSeperator : Bool = false

}

struct SectionModel {
    
    var headerTitle : String?
    var data : [IndentDataStruct]?//[Any]?
    var type : ServicesSectionType?
}
class ServicesOrProviderBannerPageViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gradientView: UIView!
    
    var pageData : BanerData?
    var sections : [SectionModel] = [SectionModel]()
    var toasLabel : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMainViewLayout()
        self.setMainViewContent()
        self.setUpSections()
        self.setupTableView()
    
        // Do any additional setup after loading the view.
    }
    private func setupTableView() -> (){
        
        self.tableView.rowHeight = 30
        self.tableView.estimatedRowHeight = 100
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "ServicesOrProviderHeaderTableViewCell", bundle: .none), forCellReuseIdentifier: "ServicesOrProviderHeaderTableViewCell")
        self.tableView.register(UINib(nibName: "ServicesOrProvidersValidityTableViewCell", bundle: .none), forCellReuseIdentifier: "ServicesOrProvidersValidityTableViewCell")
        self.tableView.register(UINib(nibName: "ServiceValueTableViewCell", bundle: .none), forCellReuseIdentifier: "ServiceValueTableViewCell")
        self.tableView.register(UINib(nibName: "NotesTableViewCell", bundle: .none), forCellReuseIdentifier: "NotesTableViewCell")
    }
    private func setMainViewLayout() -> () {
        self.containerView.layer.cornerRadius = 20
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        self.gradientView.layer.cornerRadius = 20
        self.gradientView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        
        self.gradientView.contentMode = UIView.ContentMode.scaleToFill
        self.gradientView.layer.contents = UIImage(named:"bg_black_gradient")?.cgImage
    }
    func setMainViewContent() -> () {
        
        self.bgImageView.contentMode = .redraw
        self.bgImageView.sd_setImage(with: URL(string: self.pageData!.image!),
                                     placeholderImage: UIImage(named: ""),options: .refreshCached)
        
    }
    func setUpSections() -> () {
        var headerInfoIndentation = IndentDataStruct()
        headerInfoIndentation.level = 0
        headerInfoIndentation.data = [self.pageData as Any]
        let headerInfoSection : SectionModel = SectionModel(headerTitle: "", data: [headerInfoIndentation], type: ServicesSectionType.header)
        self.sections.append(headerInfoSection)
        
        var validityIndentation = IndentDataStruct()
        validityIndentation.level = 0
        validityIndentation.data = [self.pageData as Any]
        let validitySection : SectionModel = SectionModel(headerTitle: "", data: [validityIndentation], type: ServicesSectionType.validity)
        self.sections.append(validitySection)
        self.addProvidersSections()
        self.addNotesSection()
    }
    func addProvidersSections() -> () {
        
        for provider in self.pageData!.providers! {
            
            var providerSection : SectionModel = SectionModel(headerTitle: provider.name, data: [], type: ServicesSectionType.provider)
            
            if provider.services != nil && provider.services!.count > 0 {
                for (index ,service) in provider.services!.enumerated(){
                    
                    var ids = IndentDataStruct(level: 0, title: service.name!)
                    var isNeedToHideFirstSeperator = false
                    if (index == provider.services!.count - 1){// last index
                        isNeedToHideFirstSeperator = true
                        ids.isNeedToHideBottomSeperator = true
                    }else{
                        isNeedToHideFirstSeperator = false
                        ids.isNeedToHideBottomSeperator = false
                    }
                    ids.isNeedToHideFisrtSeperator = isNeedToHideFirstSeperator
                    providerSection.data?.append(ids)
                    
                    if service.sub_services != nil && service.sub_services!.count > 0 {
                        
                        for (j,subService) in service.sub_services!.enumerated() {
                            
                            var idsInner = IndentDataStruct(level: 1, title: subService.name!)
                            idsInner.isNeedToHideFisrtSeperator = isNeedToHideFirstSeperator
                            if (j == service.sub_services!.count - 1){// last index
                                idsInner.isNeedToHideBottomSeperator = true
                            }else{
                                idsInner.isNeedToHideBottomSeperator = false
                            }
                            providerSection.data?.append(idsInner)
                            
                            if subService.categories != nil && subService.categories!.count > 0 {
                                for (k,categ) in subService.categories!.enumerated(){
                                    var idsInnerMost = IndentDataStruct(level: 2, title: categ.name!)
                                    idsInnerMost.isNeedToHideFisrtSeperator = isNeedToHideFirstSeperator
                                    if (k == subService.categories!.count - 1){// last index
                                        idsInnerMost.isNeedToHideBottomSeperator = true
                                    }else{
                                        idsInnerMost.isNeedToHideBottomSeperator = false
                                    }
                                    providerSection.data?.append(idsInnerMost)
                                }
                            }
                            
                        }
                    }
                    
                }
            }
            self.sections.append(providerSection)
        }
    }
    func addNotesSection() -> () {
        if pageData?.notes != nil && pageData?.notes?.count != 0  {
            var notesIndent = IndentDataStruct()
            notesIndent.level = 0
            notesIndent.data = [self.pageData as Any]
            
            let headerInfoSection : SectionModel = SectionModel(headerTitle: "Important Notes".localized(), data: [notesIndent], type: ServicesSectionType.notes)
            self.sections.append(headerInfoSection)
        }
    }
}
extension ServicesOrProviderBannerPageViewController : UITableViewDataSource , UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sections[section].type == ServicesSectionType.notes{
            return self.pageData?.notes?.count ?? 0
            
        }else{
            return self.sections[section].data?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.sections[indexPath.section].type == ServicesSectionType.header {
            
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "ServicesOrProviderHeaderTableViewCell", for: indexPath) as! ServicesOrProviderHeaderTableViewCell
            headerCell.setCellContent(data: self.pageData!)
            headerCell.codeViewButton.addTarget(self, action: #selector(self.codeViewTapped), for: .touchUpInside)
            return headerCell
            
        }else if self.sections[indexPath.section].type == ServicesSectionType.validity {
            let validityCell = tableView.dequeueReusableCell(withIdentifier: "ServicesOrProvidersValidityTableViewCell", for: indexPath) as! ServicesOrProvidersValidityTableViewCell
            validityCell.setCellContent(data: self.pageData!)
            return validityCell
            
        }else if self.sections[indexPath.section].type == ServicesSectionType.provider{
            
            let serviceValueCell = tableView.dequeueReusableCell(withIdentifier: "ServiceValueTableViewCell", for: indexPath) as! ServiceValueTableViewCell
            serviceValueCell.setCellContent(title: self.sections[indexPath.section].data![indexPath.row].title, level: self.sections[indexPath.section].data![indexPath.row].level, isNeedToHideFistSeperator: self.sections[indexPath.section].data![indexPath.row].isNeedToHideFisrtSeperator,isNeedToHideBottomSeperator: self.sections[indexPath.section].data![indexPath.row].isNeedToHideBottomSeperator)
            return serviceValueCell
            
        }else{
            
            let noteCell = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell", for: indexPath) as! NotesTableViewCell
            noteCell.noteLabel.text = self.pageData!.notes![indexPath.row].note_name
            return noteCell
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.sections[section].type == ServicesSectionType.provider{
            
            return self.getHeaderForSection(title: self.sections[section].headerTitle!, tableView: tableView,isForNote: false)
            
        }else if self.sections[section].type == ServicesSectionType.notes{
            return self.getHeaderForSection(title: self.sections[section].headerTitle!, tableView: tableView,isForNote: true)
        } else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.sections[section].type == ServicesSectionType.provider || self.sections[section].type == ServicesSectionType.notes {
            return UITableView.automaticDimension
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.sections[indexPath.section].type == ServicesSectionType.provider {
            
            return 40
        }else{
            return UITableView.automaticDimension
            
        }
    }
    func getHeaderForSection(title : String , tableView : UITableView , isForNote : Bool = false) -> (UIView) {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40.0))
        let containerView = UIView(frame: CGRect(x: 12, y: 0, width: headerView.frame.size.width - (12 + 7.71), height: 40))
        containerView.layer.cornerRadius = 5.0
        if isForNote {
            containerView.backgroundColor = .clear
            
        }else{
            containerView.backgroundColor = UIColor(hexString: "BFE7FF")
        }
        containerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -7.71),
            containerView.heightAnchor.constraint(equalToConstant: 40),
            containerView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0.0),
            containerView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0.0),
        ])
        var bottomConst: CGFloat = -11
        let uilabel = UILabel()
        var leadingConstant = 9.0
        if isForNote{
            uilabel.font = UIFont.Poppins(.bold, size: 23)
        }else{
            uilabel.font = UIFont.Poppins(.bold, size: 12)
        }
        if isForNote {
            uilabel.textColor = .white
            leadingConstant = 0.0
            bottomConst = 0
        }else{
            uilabel.textColor = UIColor(hexString: "111111")
            leadingConstant = 9.0
        }
        if Localize.currentLanguage() == "ar"{
            uilabel.textAlignment = .right
        }else{
            uilabel.textAlignment = .left
        }
        uilabel.translatesAutoresizingMaskIntoConstraints = false
        uilabel.text = title
        containerView.addSubview(uilabel)

        NSLayoutConstraint.activate([
            uilabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leadingConstant),
            uilabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -9),
            uilabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12.0),
            uilabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: bottomConst),
        ])
        return headerView
    }
   @objc func codeViewTapped(){
       print("codeViewTapped tapped")
       UIPasteboard.general.string = self.pageData?.name!
       self.toasLabel.text = "Coupon Copied".localized()
       self.toasLabel.textColor = .white
       self.toasLabel.center = self.tableView.center
       self.toasLabel.textAlignment = .center
       self.tableView.addSubview(self.toasLabel)
       DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
           self.toasLabel.removeFromSuperview()
       })
    }
}
