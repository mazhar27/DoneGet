//
//  logOutCell.swift
//  Done
//
//  Created by Dtech Mac on 06/09/2022.
//

import UIKit
import Localize_Swift

class logOutCell: UITableViewCell {
    @IBOutlet weak var lblHelp: UILabel!
    @IBOutlet weak var ImageVHelp: UIImageView!
    @IBOutlet weak var lblDelete: UILabel!
    @IBOutlet weak var imageVDelete: UIImageView!
    @IBOutlet weak var lblLogout: UILabel!
    @IBOutlet weak var imageVLogout: UIImageView!
    @IBOutlet weak var actionHelp: UIButton!
    @IBOutlet weak var actionDelete: UIButton!
    @IBOutlet weak var actionLogOut: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Localization()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func Localization(){
        lblHelp.text = "Help & Support".localized()
        lblLogout.text = "Logout".localized()
        lblDelete.text = "Delete Account".localized()
    }
    
}
