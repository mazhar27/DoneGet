//
//  InfoCell.swift
//  Done
//
//  Created by Dtech Mac on 05/09/2022.
//

import UIKit

class InfoCell: UITableViewCell {
    @IBOutlet weak var LblEmail: UILabel!
    @IBOutlet weak var ImageEmail: UIImageView!
    @IBOutlet weak var LblPhoneNo: UILabel!
    @IBOutlet weak var ImagePhone: UIImageView!
    @IBOutlet weak var LblLoaction: UILabel!
    @IBOutlet weak var ImageLoaction: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureInfoCell(profileInfo : ProfileInnerData) {
        LblEmail.text = profileInfo.email
        LblPhoneNo.text = profileInfo.phone
        LblLoaction.text = profileInfo.address
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
  
    
    
}

