//
//  BannerAndPormotionPageViewController.swift
//  Done
//
//  Created by Adeel Hussain on 08/11/2022.
//

import UIKit
import Localize_Swift

class BannerAndPormotionPageViewController: UIViewController {
    
    
   
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var tbvu: UITableView!
    
    var pageData : BanerData?
    var toasLabel : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))

    override func viewDidLoad() {
        super.viewDidLoad()
        setMainViewContent()
        self.setContent()
        setupTableView()
        
    }
    func setupTableView(){
        let nib = UINib(nibName: "NotesTableViewCell", bundle: nil)
        let nib1 = UINib(nibName: "CashBackTVC", bundle: nil)
        tbvu.register(nib1, forCellReuseIdentifier: "CashBackTVC")
        tbvu.register(nib, forCellReuseIdentifier: "NotesTableViewCell")
        tbvu.separatorStyle = .none
        tbvu.delegate = self
        tbvu.dataSource = self
    }
    func setMainViewContent() -> () {
        
        self.bgImageView.contentMode = .redraw
        self.bgImageView.sd_setImage(with: URL(string: self.pageData!.image!),
                                     placeholderImage: UIImage(named: ""),options: .refreshCached)
        self.bgImageView.cornerRadius = 20
        self.gradientView.layer.cornerRadius = 20
        self.gradientView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        
        self.gradientView.contentMode = UIView.ContentMode.scaleToFill
        self.gradientView.layer.contents = UIImage(named:"bg_black_gradient")?.cgImage
        
    }
   
    func setContent() -> () {
        
//        self.bannerImageView.contentMode = .redraw
//        self.bannerImageView.sd_setImage(with: URL(string: self.pageData!.image!),
//                                         placeholderImage: UIImage(named: ""))
//        if self.pageData!.discount != nil{
//            self.priceLabel.text = "SAR \(self.pageData!.discount!)"
//        }
//        self.desLabel.text = self.pageData?.banner_tile
//        
//        self.validityFromLabel.text = self.getDate(dateInString: self.pageData!.valid_from!)//self.pageData?.valid_from
//        
//        self.validityTillDateLabel.text = self.getDate(dateInString: self.pageData!.valid_till!)//self.pageData?.valid_till
    }
    func getDate(dateInString : String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateInString) else {
            return dateInString
        }
        formatter.dateFormat = "E, MMM d, yyyy"
        return formatter.string(from: date)
        
    }
}


extension BannerAndPormotionPageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
           return pageData?.notes?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
           return UITableView.automaticDimension
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CashBackTVC", for: indexPath) as! CashBackTVC
            if let data = pageData{
                cell.configureCell(item: data)
            }
            cell.selectionStyle = .none
            cell.codeBtn.addTarget(self, action: #selector(self.codeViewTapped), for: .touchUpInside)
           return cell
        }else{
            
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell", for: indexPath) as! NotesTableViewCell
            cell1.noteLabel.text = pageData?.notes?[indexPath.row].note_name
            cell1.selectionStyle = .none
            return cell1
        }
    }
    
    @objc func codeViewTapped(){
        print("codeViewTapped tapped")
        UIPasteboard.general.string = self.pageData?.name!
        self.toasLabel.text = "Coupon Copied".localized()
        self.toasLabel.textColor = .white
        self.toasLabel.center = self.tbvu.center
        self.toasLabel.textAlignment = .center
        self.tbvu.addSubview(self.toasLabel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            self.toasLabel.removeFromSuperview()
        })
     }

    
    
}

