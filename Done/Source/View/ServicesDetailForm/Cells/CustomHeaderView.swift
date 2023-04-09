//
//  CustomHeaderView.swift
//  CustomHeaderView
//
//  Created by Santosh on 04/08/20.
//  Copyright © 2020 Santosh. All rights reserved.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var homeRadioBtn: UIButton!
    
    @IBOutlet weak var serviceAtHomeLbl: UILabel!
    @IBOutlet weak var collectLbl: UILabel!
    @IBOutlet weak var collectRadioImgVu: UIImageView!
    @IBOutlet weak var homeRadioImgVu: UIImageView!
   
    @IBOutlet weak var collectRadioBtn: UIButton!
    @IBOutlet weak var chooseServiceTypeLbl: UILabel!
    
    func configureCell(service: Service){
        self.chooseServiceTypeLbl.text = "Choose service type".localized()
        self.serviceAtHomeLbl.text = "Service at Home".localized()
        self.collectLbl.text = "Collect & Return".localized()
        if service.is_home == 1 && service.is_pick == 1{
            collectRadioBtn.isEnabled = true
            homeRadioBtn.isEnabled = true
            collectRadioImgVu.image = UIImage(named: "circleUnfilled")
            homeRadioImgVu.image = UIImage(named: "circleUnfilled")
        }else if service.is_home == 1 && service.is_pick == 0{
            homeRadioBtn.isEnabled = false
            collectRadioBtn.isEnabled = false
            collectRadioImgVu.isHidden = true
            collectLbl.isHidden = true
            collectRadioImgVu.image = UIImage(named: "circleUnfilled")
            homeRadioImgVu.image = UIImage(named: "circleFilled")
            SessionModel.shared.serviceType = ServiceType.Home
        }else if service.is_home == 0 && service.is_pick == 1{
            homeRadioBtn.isEnabled = false
            serviceAtHomeLbl.isHidden = true
            homeRadioImgVu.isHidden = true
            collectRadioBtn.isEnabled = false
            homeRadioImgVu.image = UIImage(named: "circleUnfilled")
            collectRadioImgVu.image = UIImage(named: "circleFilled")
            SessionModel.shared.serviceType = ServiceType.CollectReturn
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func homeBtnTpd(_ sender: Any) {
        collectRadioImgVu.image = UIImage(named: "circleUnfilled")
        homeRadioImgVu.image = UIImage(named: "circleFilled")
        SessionModel.shared.serviceType = ServiceType.Home
    }
    @IBAction func collectBtnTpd(_ sender: Any) {
        collectRadioImgVu.image = UIImage(named: "circleFilled")
        homeRadioImgVu.image = UIImage(named: "circleUnfilled")
        SessionModel.shared.serviceType = ServiceType.CollectReturn
    }
}
