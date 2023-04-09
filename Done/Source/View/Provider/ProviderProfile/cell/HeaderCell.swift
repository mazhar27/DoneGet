//
//  HeaderCell.swift
//  Done
//
//  Created by Dtech Mac on 05/09/2022.
//

import UIKit
import Localize_Swift

class HeaderCell: UITableViewCell {
    
    @IBOutlet weak var bottomSepratorVu: UIView!
    @IBOutlet weak var forwardIcon: UIImageView!
    @IBOutlet weak var LblHeader: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        LblHeader.text = "View Services".localized()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(isExpanded: Bool, title: String){
        LblHeader.text = title
        if isExpanded{
            forwardIcon.image = UIImage(named: "downArrow")
            forwardIcon.transform = .identity
        }else{
            forwardIcon.image = UIImage(named: "forwardIcon")
            if Localize.currentLanguage() == "ar"{
                forwardIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }else{
                forwardIcon.transform = .identity
            }
          
        }
    }
    
}
