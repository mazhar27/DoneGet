//
//  textVuTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 19/07/2022.
//

import UIKit
import Localize_Swift
class textVuTVC: UITableViewCell {

    @IBOutlet weak var textVu: UITextView!
    @IBOutlet weak var textOuterVu: UIView!
    @IBOutlet weak var addDesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addDesLabel.text = "Add Description".localized()
        if Localize.currentLanguage() == "ar"{
            textVu.textAlignment = .right
        }else{
            textVu.textAlignment = .left
        }
        textOuterVu.layer.masksToBounds = false
        textVu.layer.cornerRadius = 5
        textVu.text = "Please tell us about your problem".localized()
        textVu.textColor = UIColor.lightGray
        textVu.layer.borderWidth = 0
        
        textOuterVu.layer.shadowOpacity = 0.6
        textOuterVu.layer.shadowRadius = 1.0
//        textOuterVu.layer.borderColor = UIColor.white.cgColor
        textOuterVu.layer.shadowOffset = CGSize(width: 0, height: 3)
        textOuterVu.layer.shadowColor = UIColor.lightGray.cgColor //Any dark color
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
