//
//  ServicesHeader.swift
//  Done
//
//  Created by Mazhar Hussain on 14/06/2022.
//

import UIKit
import Localize_Swift

class ServicesHeader: UITableViewCell {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var outerVu: UIView!
    @IBOutlet weak var serviceDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.serviceDetailLabel.text = "Detailed Services".localized()
        self.searchTF.placeholder = "Search for keywords".localized()
        if Localize.currentLanguage() == "ar" {
            self.searchTF.textAlignment = .right
        }else{
            self.searchTF.textAlignment = .left
        }
        outerVu.layer.masksToBounds = false
        outerVu.cornerRadius = 5
        outerVu.borderWidth = 0.5
        outerVu.borderColor = UIColor.white
        outerVu.layer.shadowRadius = 3
        outerVu.layer.shadowOpacity = 0.5
//        outerVu.layer.shadowColor = UIColor.init(hexString: "D9D6D6").cgColor
        outerVu.layer.shadowColor = UIColor.lightGray.cgColor
        outerVu.layer.shadowOffset = CGSize(width: 0 , height:1)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
}
