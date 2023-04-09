//
//  CashBackTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 15/11/2022.
//

import UIKit
import Localize_Swift

class CashBackTVC: UITableViewCell {

    @IBOutlet weak var validityTillTtitleLbl: UILabel!
    @IBOutlet weak var validitiyFromTitleLbl: UILabel!
    @IBOutlet weak var getLbl: UILabel!
    @IBOutlet weak var couponCodeVuHeightCons: NSLayoutConstraint!
    @IBOutlet weak var couponCodeOuterVu: UIView!
    @IBOutlet weak var importantNotesTitleLbl: UILabel!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var validityTillLbl: UILabel!
    @IBOutlet weak var validityFromLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.gradientView.contentMode = UIView.ContentMode.scaleToFill
//        self.gradientView.layer.contents = UIImage(named:"bg_black_gradient")?.cgImage
        getLbl.text = "GET".localized()
        importantNotesTitleLbl.text = "Important Notes".localized()
        validitiyFromTitleLbl.text = "Validity from".localized()
        validityTillTtitleLbl.text = "Validity till".localized()
        if Localize.currentLanguage() == "ar" {
            descLbl.textAlignment = .right
        }else{
            descLbl.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(item: BanerData){
        let validFrom = item.valid_from ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: validFrom)  {
            validityFromLbl.text =  DateFormatter.DDmonYYYY.string(from: date)
        }
        let validTill = item.valid_till ?? ""
        if let date1 = formatter.date(from: validTill)  {
            validityTillLbl.text =  DateFormatter.DDmonYYYY.string(from: date1)
        }
        codeLbl.text = item.name
        print("????  \(item.banner_tile)")
        descLbl.text = item.banner_tile
      
        if item.notes?.count == 0{
            importantNotesTitleLbl.isHidden = true
        }else{
            importantNotesTitleLbl.isHidden = false
        }
        if item.type == "recharge" || item.type == "signup" || item.type == "cashback"{
            couponCodeOuterVu.isHidden = true
            if item.discount_type == "percentage"{
                discountLbl.text = (item.discount ?? "0") + "%" + "OFF".localized()
            }else{
                discountLbl.text = "SAR " + (item.discount ?? "0")
            }
        }else{
            codeLbl.text = "#" + (item.name ?? "")
            discountLbl.text = (item.discount ?? "0")  + "%" + "OFF".localized()
            couponCodeOuterVu.isHidden = false
//            couponCodeVuHeightCons.constant = 38
        }
    }
    
}
