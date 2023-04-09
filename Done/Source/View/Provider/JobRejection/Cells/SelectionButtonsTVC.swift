//
//  SelectionButtonsTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 12/09/2022.
//

import UIKit
import Localize_Swift

class SelectionButtonsTVC: UITableViewCell {

    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        yesBtn.setTitle("Yes".localized(), for: .normal)
        cancelBtn.setTitle("Cancel".localized(), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
