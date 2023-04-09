//
//  ServicesDescriptionTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 14/06/2022.
//

import UIKit
import WebKit

class ServicesDescriptionTVC: UITableViewCell {

   
   
    @IBOutlet weak var webOuterVu: UIView!
    @IBOutlet weak var txtVu: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        txtVu.isEditable = false
        txtVu.isScrollEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
