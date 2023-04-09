//
//  CategoryCVC.swift
//  Done
//
//  Created by Mazhar Hussain on 13/06/2022.
//

import UIKit
import SDWebImage

class CategoryCVC: UICollectionViewCell {
    
    @IBOutlet weak var categoryTitleLbl: UILabel!
    @IBOutlet weak var categoryImgVu: UIImageView!
    @IBOutlet weak var radioImgVu: UIImageView!
    @IBOutlet weak var outerVu: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        outerVu.layer.masksToBounds = false
        
        // Initialization code
    }
    
    func configureCell(item: Main_services){
        
        categoryTitleLbl.text = item.service_title
        let imageUrl = URL(string: item.service_icon ?? "")
        categoryImgVu.sd_setImage(with: imageUrl,
                                  placeholderImage: UIImage(named: ""))
        if item.isSelected {
            radioImgVu.image = UIImage(named: "selectedIcon")
        }else{
            radioImgVu.image = UIImage(named: "unselectedIcon")
        }
        categoryImgVu.contentMode = .scaleAspectFit
    }
    func configureCellForProfile(item: Main_services,selecedService : Main_services){
        categoryTitleLbl.text = item.service_title
        let imageUrl = URL(string: item.service_icon ?? "")
        categoryImgVu.sd_setImage(with: imageUrl,
                                  placeholderImage: UIImage(named: ""))
        
        self.outerVu.layer.cornerRadius = 13
        self.outerVu.layer.masksToBounds = false
        self.outerVu.layer.borderWidth = 0
        self.outerVu.layer.shadowRadius = 2
        self.outerVu.layer.shadowOpacity = 1
        self.outerVu.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        if item.service_id == selecedService.service_id {
            categoryTitleLbl.textColor = UIColor.blueThemeColor
            radioImgVu.image = UIImage(named: "selectedIcon")
            self.outerVu.layer.shadowColor = UIColor.selectedServiceShadowColor.cgColor
        }else{
            categoryTitleLbl.textColor = UIColor.init(hexString: "#3E3E3E")
            radioImgVu.image = UIImage(named: "unselectedIcon")
            self.outerVu.layer.shadowColor = UIColor.unselectedServiceShadowColor.cgColor
        }
        categoryImgVu.contentMode = .scaleAspectFit
    }
}
