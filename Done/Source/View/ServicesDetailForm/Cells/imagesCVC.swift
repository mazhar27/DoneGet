//
//  imagesCVC.swift
//  Done
//
//  Created by Mazhar Hussain on 15/07/2022.
//

import UIKit

class imagesCVC: UICollectionViewCell {

    @IBOutlet weak var outerVu: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var plusImgVu: UIImageView!
    @IBOutlet weak var imgVu: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outerVu.layer.masksToBounds = false
        
    }

}
