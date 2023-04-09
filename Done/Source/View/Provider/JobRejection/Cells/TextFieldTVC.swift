//
//  TextFieldTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 12/09/2022.
//

import UIKit
import Localize_Swift

class TextFieldTVC: UITableViewCell {

    @IBOutlet weak var inputTF: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        inputTF.placeholder = "Tell your  reason".localized()
        if Localize.currentLanguage() == "ar"{
            inputTF.textAlignment = .right
           
        }else{
            inputTF.textAlignment = .left
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
