//
//  ServicesTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 13/06/2022.
//

import UIKit
import Localize_Swift
class ServicesTVC: UITableViewCell {

   
    @IBOutlet weak var outerVu: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgVu: UIImageView!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if Localize.currentLanguage() == "ar" {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }else{
            self.arrowImageView.transform = .identity
        }        // Initialization code
        outerVu.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(item: Sub_services){
        let imageUrl = URL(string: item.service_icon ?? "")
        imgVu.sd_setImage(with: imageUrl,
                                 placeholderImage: UIImage(named: ""))
        titleLbl.text = item.service_title
    }
    
}
