//
//  ProvidersListTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 16/06/2022.
//

import UIKit
import SDWebImage

class ProvidersListTVC: UITableViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var outerVu: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    
    @IBOutlet weak var crnLbl: UILabel!
    @IBOutlet weak var imgVu: UIImageView!
    @IBOutlet weak var lowerVu: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgVu.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.init(hexString: "#F4F9FC")
        outerVu.layer.masksToBounds = false
        lowerVu.clipsToBounds = true
        lowerVu.layer.cornerRadius = 5
        lowerVu.borderColor = UIColor.blueThemeColor
        lowerVu.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(provider: Providers){
        titleLbl.text = provider.provider_detail?.name
        descriptionLbl.text = provider.provider_detail?.description
        ratingLbl.text = provider.rating
//        priceLbl.text = "SAR " + String(provider.service_price ?? 0)
        priceLbl.text = "SAR " + (provider.service_price ?? "0")
        crnLbl.text = provider.provider_detail?.crNumber
        let imageUrl = URL(string: provider.provider_detail?.logo_image ?? "") 
        imgVu.sd_setImage(with: imageUrl,
                                 placeholderImage: UIImage(named: ""))
    }
    
}
