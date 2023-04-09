//
//  ProviderDashCVC.swift
//  Done
//
//  Created by Mazhar Hussain on 05/09/2022.
//

import UIKit
import SDWebImage

class ProviderDashCVC: UICollectionViewCell {

    @IBOutlet weak var imgVu: UIImageView!
    @IBOutlet weak var jobsTitleLbl: UILabel!
    @IBOutlet weak var jobsCountLbl: UILabel!
    @IBOutlet weak var outerVu: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureCell(item: Stats){
        jobsTitleLbl.text = item.title
        jobsCountLbl.text = String(item.stat ?? 0)
        let imageUrl = URL(string: item.icon ?? "")
        imgVu.sd_setImage(with: imageUrl,
                                 placeholderImage: UIImage(named: ""))
        switch item.job_type{
        case "1":
            outerVu.backgroundColor = UIColor.init(hexString: "#F5C14F")
            outerVu.borderColor = UIColor.init(hexString: "#F5C14F")
        case "2":
            outerVu.backgroundColor = UIColor.init(hexString: "#2BADF8")
            outerVu.borderColor = UIColor.init(hexString: "#2BADF8")
        case "3":
            outerVu.backgroundColor = UIColor.init(hexString: "#F75D5D")
            outerVu.borderColor = UIColor.init(hexString: "#F75D5D")
        case "4":
            outerVu.backgroundColor = UIColor.init(hexString: "#6DBE4F")
            outerVu.borderColor = UIColor.init(hexString: "#6DBE4F")
        case "5":
            outerVu.backgroundColor = UIColor.init(hexString: "#7676FC")
            outerVu.borderColor = UIColor.init(hexString: "#7676FC")
        case .none:
            print("do noithing ")
        case .some(_):
            print("do noithing ")
        }
        
    }

}
