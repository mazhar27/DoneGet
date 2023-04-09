//
//  ServiceValueTableViewCell.swift
//  Done
//
//  Created by Adeel Hussain on 14/11/2022.
//

import UIKit

class ServiceValueTableViewCell: UITableViewCell {

    @IBOutlet weak var firstSeperator: UIView!
    @IBOutlet weak var topVerticalSeperator: UIView!
    
    @IBOutlet weak var centerSeperator: UIView!
    @IBOutlet weak var bottomSeperator: UIView!
    
    @IBOutlet weak var serviceTitleLabel: UILabel!
    
    @IBOutlet weak var centerSeperatorLeadingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCellContent(title : String , level : Int,isNeedToHideFistSeperator : Bool,isNeedToHideBottomSeperator : Bool) ->  (){
        self.serviceTitleLabel.text = title
        self.firstSeperator.isHidden = isNeedToHideFistSeperator
        self.bottomSeperator.isHidden = isNeedToHideBottomSeperator
        if level == 0 {
            self.centerSeperatorLeadingConstraint.constant = 0
        }else if level == 1 {
            self.centerSeperatorLeadingConstraint.constant = 16
        }else{
            self.centerSeperatorLeadingConstraint.constant = 32
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
