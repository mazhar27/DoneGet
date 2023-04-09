//
//  ServicesOrProviderHeaderTableViewCell.swift
//  Done
//
//  Created by Adeel Hussain on 11/11/2022.
//

import UIKit
import Localize_Swift

class ServicesOrProviderHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var getLbl: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var codeContainerView: UIView!
    
    @IBOutlet weak var codeViewButton: UIButton!
    @IBOutlet weak var couponLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        getLbl.text = "GET".localized()
    }
    func setCellContent(data : BanerData) -> () {
        self.percentageLabel.text = "\(data.discount!)% OFF"
        self.couponLabel.text = "#\(data.name!)"
        if data.type == "recharge" || data.type == "signup" || data.type == "cashback"{
            codeContainerView.isHidden = true
           
            if data.discount_type == "percentage"{
                percentageLabel.text = (data.discount ?? "0")  + "%" + "OFF".localized()
            }else{
                percentageLabel.text = "SAR " + (data.discount ?? "0")
            }
        }else{
            percentageLabel.text = (data.discount ?? "0") + "%" + "OFF".localized()
            codeContainerView.isHidden = false
            
        }   }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
