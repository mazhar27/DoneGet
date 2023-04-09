//
//  UpperTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 12/09/2022.
//

import UIKit
import Localize_Swift

class UpperTVC: UITableViewCell {

    @IBOutlet weak var chooseLbl: UILabel!
    @IBOutlet weak var orderRejectionLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var orderNumLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        descLbl.text = "Are you sure you want to reject the customer Service assigned to you against the ORDER".localized()
        orderRejectionLbl.text = "Order Rejection".localized()
        chooseLbl.text = "Choose Reason to delete".localized()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }
    
}
