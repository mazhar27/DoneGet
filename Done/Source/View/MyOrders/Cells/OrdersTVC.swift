//
//  OrdersTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 20/06/2022.
//

import UIKit

class OrdersTVC: UITableViewCell {

    @IBOutlet weak var providerImgVuTopCons: NSLayoutConstraint!
    @IBOutlet weak var providerImgVuHeightCons: NSLayoutConstraint!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var orderTypeLbl: UILabel!
    @IBOutlet weak var providerLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var serviceLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusOuterVu: UIView!
   
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var inviceBtn: UIButton!
    @IBOutlet weak var inviceImgVu: UIImageView!
    @IBOutlet weak var outerVu: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.orderIdLabel.text = "Order ID".localized()
        self.homeLabel.text = "Home".localized()
        outerVu.layer.masksToBounds = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(type: orderType, item: Orders){
        
        switch type {
        case .pending:
            statusLbl.text = "Pending".localized()
            statusOuterVu.backgroundColor = UIColor.init(hexString: "#FDEECD")
            statusLbl.textColor = UIColor.init(hexString: "#C68900")
            inviceBtn.isHidden = true
            inviceImgVu.isHidden = true
           
        case .accepted:
            statusLbl.text = "Accepted".localized()
            statusOuterVu.backgroundColor = UIColor.init(hexString: "#BFE7FF")
            statusLbl.textColor = UIColor.init(hexString: "#007DC6")
            inviceBtn.isHidden = true
            inviceImgVu.isHidden = true
        case .completed:
            statusLbl.text = "Completed".localized()
            statusOuterVu.backgroundColor = UIColor.init(hexString: "#D0FFBF")
            statusLbl.textColor = UIColor.init(hexString: "#00931C")
            inviceBtn.setTitleColor(UIColor.blueThemeColor, for: .normal)
            inviceBtn.setTitle("View Invoice".localized(), for: .normal)
            inviceBtn.isHidden = false
            inviceImgVu.isHidden = false
           
        case .failed:
            statusLbl.text = "Failed".localized()
            statusOuterVu.backgroundColor = UIColor.init(hexString: "#F5CFCF")
            statusLbl.textColor = UIColor.init(hexString: "#F50808")
            inviceBtn.isHidden = false
            inviceBtn.setTitleColor(UIColor.init(hexString: "#F50808"), for: .normal)
            inviceBtn.setTitle("Report Problem".localized(), for: .normal)
            inviceImgVu.isHidden = true
        }
        priceLbl.text = "SAR " + (item.service_price ?? "0")
        orderNumberLbl.text = String(item.order_number ?? 0)
        addressLbl.text = item.address_title
        dateLbl.text = item.service_time
        serviceLbl.text = item.service_title
        providerLbl.text = item.provider_name
        orderTypeLbl.text = item.payment_method
        let dateString = item.service_time ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateString) else {
            return
        }
        dateLbl.text = DateFormatter.DDmonthYYYYTime.string(from: date)
    }
//      Configure cell for Provider Jobs
    func configureCellProvider(type: orderType, item: Jobs){
        
        switch type {
        case .pending:
            statusLbl.text = "Pending".localized()
            statusOuterVu.backgroundColor = UIColor.init(hexString: "#FDEECD")
            statusLbl.textColor = UIColor.init(hexString: "#C68900")
            inviceBtn.isHidden = true
            inviceImgVu.isHidden = true
            providerImgVuTopCons.constant = 0
            providerImgVuHeightCons.constant = 0
            providerLbl.isHidden = true
            
        case .accepted:
            statusLbl.text = "Accepted".localized()
            statusOuterVu.backgroundColor = UIColor.init(hexString: "#BFE7FF")
            statusLbl.textColor = UIColor.init(hexString: "#007DC6")
            inviceBtn.isHidden = true
            inviceImgVu.isHidden = true
            providerImgVuTopCons.constant = 22
            providerImgVuHeightCons.constant = 15
            providerLbl.isHidden = false
        case .completed:
            statusLbl.text = "Completed".localized()
            statusOuterVu.backgroundColor = UIColor.init(hexString: "#D0FFBF")
            statusLbl.textColor = UIColor.init(hexString: "#00931C")
            inviceBtn.setTitleColor(UIColor.blueThemeColor, for: .normal)
            inviceBtn.setTitle("View Invoice".localized(), for: .normal)
            inviceBtn.isHidden = true
            inviceImgVu.isHidden = true
            providerImgVuTopCons.constant = 22
            providerImgVuHeightCons.constant = 15
            providerLbl.isHidden = false
        case .failed:
            statusLbl.text = "Failed".localized()
            statusOuterVu.backgroundColor = UIColor.init(hexString: "#F5CFCF")
            statusLbl.textColor = UIColor.init(hexString: "#F50808")
            inviceBtn.isHidden = true
            inviceImgVu.isHidden = true
            providerImgVuTopCons.constant = 22
            providerImgVuHeightCons.constant = 15
            providerLbl.isHidden = false
        }
        orderNumberLbl.text = String(item.order_number ?? 0)
        addressLbl.text = item.address_title
        dateLbl.text = item.service_time
        serviceLbl.text = item.service_title
        providerLbl.text = item.name
        orderTypeLbl.text = item.payment_type
        priceLbl.text = "SAR " + (item.total_amount ?? "0")
        categoryLbl.text = item.category_title
        let dateString = item.service_time ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateString) else {
            return
        }
        dateLbl.text = DateFormatter.DDmonthYYYYTime.string(from: date)
    }
    
}
enum orderType{
    case pending, accepted, completed, failed
}
