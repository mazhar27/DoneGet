//
//  ServicesOrProvidersValidityTableViewCell.swift
//  Done
//
//  Created by Adeel Hussain on 11/11/2022.
//

import UIKit
import Localize_Swift

class ServicesOrProvidersValidityTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var headingLblBotCons: NSLayoutConstraint!
    @IBOutlet weak var headingLblTopCons: NSLayoutConstraint!
    @IBOutlet weak var validityFromLabel: UILabel!
    
    @IBOutlet weak var headingTitleLbl: UILabel!
    @IBOutlet weak var validityTillLabel: UILabel!
    @IBOutlet weak var validityFromValue: UILabel!
    
    @IBOutlet weak var validityTillValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        validityFromLabel.text = "Validity from".localized()
        validityTillLabel.text = "Validity till".localized()
        if Localize.currentLanguage() == "ar" {
            titleLabel.textAlignment = .right
        }else{
            titleLabel.textAlignment = .left
        }
    }
    func setCellContent(data : BanerData) -> () {
        self.validityFromValue.text = self.getDate(dateInString: data.valid_from!)
        self.validityTillValue.text = self.getDate(dateInString: data.valid_till!)
        self.titleLabel.text = data.banner_tile
        if data.type == "service"{
            headingTitleLbl.text = "Services List".localized()
            headingLblBotCons.constant = 15
            headingLblTopCons.constant = 15
        }else if data.type == "provider"{
            headingTitleLbl.text = "Provider's List".localized()
            headingLblBotCons.constant = 15
            headingLblTopCons.constant = 15
        }else if data.type == "both" {
            headingTitleLbl.text = "Service and Provider's List".localized()
            headingLblBotCons.constant = 15
            headingLblTopCons.constant = 15
        }else{
            headingTitleLbl.text = nil
            headingLblBotCons.constant = 0
            headingLblTopCons.constant = 0
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func getDate(dateInString : String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        guard let date = formatter.date(from: dateInString) else {
            return dateInString
        }
        formatter.dateFormat = "E, MMM d, yyyy"
        return formatter.string(from: date)
        
    }
}
