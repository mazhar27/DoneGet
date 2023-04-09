//
//  LocationcTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 22/06/2022.
//

import UIKit

class LocationcTVC: UITableViewCell {
    
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var noteTotProviderTitleLbl: UILabel!
    @IBOutlet weak var addressDetailLbl: UILabel!
    @IBOutlet weak var addressTypeImgVu: UIImageView!
    @IBOutlet weak var addressTitleLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.noteTotProviderTitleLbl.text = "Note to provider".localized()
        deleteBtn.setImage(UIImage(named: "deleteIcon")!.withRenderingMode(.alwaysTemplate), for: .normal)
        deleteBtn.tintColor = UIColor.blueThemeColor
        // Initialization code
    }
    func configureCell(addressObject: CustomerAddress){
        addressDetailLbl.text = addressObject.addressTitle
        addressTitleLbl.text = addressObject.addressName
        noteLbl.text = addressObject.providerNote
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
