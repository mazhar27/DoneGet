//
//  SelectionTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 12/09/2022.
//

import UIKit

class SelectionTVC: UITableViewCell {

    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var radioImgVu: UIImageView!
    @IBOutlet weak var selectionBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
}
