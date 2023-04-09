//
//  AddressTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 09/06/2022.
//

import UIKit

class AddressTVC: UITableViewCell {

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var selectionBtn: UIButton!
    @IBOutlet weak var deleteImgVu: UIImageView!
    @IBOutlet weak var editImgVu: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionBtn.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(addressObject: CustomerAddress){
        detailLbl.text = addressObject.addressTitle
        titleLbl.text = addressObject.addressName
        if addressObject.isSelected{
            titleLbl.textColor = UIColor.white
            detailLbl.textColor = UIColor.white
            deleteImgVu.tintColor = UIColor.white
            editImgVu.image = editImgVu.image?.withRenderingMode(.alwaysTemplate)
            editImgVu.tintColor = UIColor.white
            deleteImgVu.image = deleteImgVu.image?.withRenderingMode(.alwaysTemplate)
            self.contentView.backgroundColor = UIColor.blueThemeColor
        }else{
            titleLbl.textColor = UIColor.blueThemeColor
            detailLbl.textColor = UIColor.blueThemeColor
            deleteImgVu.tintColor = UIColor.red
            editImgVu.image = editImgVu.image?.withRenderingMode(.alwaysTemplate)
            editImgVu.tintColor = UIColor.blueThemeColor
            deleteImgVu.image = deleteImgVu.image?.withRenderingMode(.alwaysTemplate)
            self.contentView.backgroundColor = UIColor.init(hexString: "#FAFAFA")
        }
        
    }
    
}
