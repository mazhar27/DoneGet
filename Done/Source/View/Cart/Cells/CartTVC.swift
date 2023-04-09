//
//  CartTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 15/06/2022.
//

import UIKit
import SDWebImage
import Localize_Swift

class CartTVC: UITableViewCell {

    @IBOutlet weak var appliedCouponBtn: UIButton!
    @IBOutlet weak var categoryImgvu: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var providerLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var discountCutVu: UIView!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var appliedCouponImgVu: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var outerVu: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
        outerVu.layer.masksToBounds = false
        discountLbl.isHidden = true
        discountCutVu.isHidden = true
        appliedCouponImgVu.isHidden = true
        priceLbl.sizeToFit()
        discountLbl.sizeToFit()
        priceLbl.adjustsFontSizeToFitWidth = true
        priceLbl.minimumScaleFactor = 0.5
        if Localize.currentLanguage() == "ar"{
            appliedCouponImgVu.image = UIImage(named: "CoupAppliesArabic")
            priceLbl.textAlignment = .left
            
        }
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      

        // Configure the view for the selected state
    }
  
    func configureCell(item: Services){
        titleLbl.text = item.serviceName
        descLbl.text = item.categoryName
        priceLbl.text = "SAR " + (item.service_price ?? "0")
        let fullDateArr = item.date_time?.components(separatedBy: " ")
        if let dateTime = fullDateArr{
        timeLbl.text = dateTime[1]
        dateLbl.text = dateTime[0]
            let dateString = dateTime[0]
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            guard let date = formatter.date(from: dateString) else {
                return
            }
            dateLbl.text = DateFormatter.DDmonthYYYY.string(from: date)
        }
        let imageUrl = URL(string: item.serviceImage ?? "")
        categoryImgvu.sd_setImage(with: imageUrl,
                                 placeholderImage: UIImage(named: ""))
        if item.coupon_id != 0{
            appliedCouponBtn.isEnabled = true
            appliedCouponImgVu.isHidden = false
            discountLbl.isHidden = false
            discountCutVu.isHidden = false
            discountLbl.text = "SAR " + (item.service_price ?? "0")
            priceLbl.text = "SAR " + (item.discounted_amount ?? "0")
        }else{
            appliedCouponBtn.isEnabled = false
            appliedCouponImgVu.isHidden = true
            discountLbl.isHidden = true
            discountCutVu.isHidden = true
            
        }
    }
    
}
