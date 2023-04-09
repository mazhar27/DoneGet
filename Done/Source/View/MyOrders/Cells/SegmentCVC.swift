//
//  SegmentCVC.swift
//  Done
//
//  Created by Mazhar Hussain on 20/06/2022.
//

import UIKit

class SegmentCVC: UICollectionViewCell {

    @IBOutlet weak var lowerVu: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(item: MyOrdersModel){
        titleLbl.text = item.title
        if item.isSelected{
            lowerVu.backgroundColor = UIColor.blueThemeColor
            titleLbl.textColor = UIColor.blueThemeColor
        }else{
            lowerVu.backgroundColor = .white
            titleLbl.textColor = UIColor.labelTitleColor
        }
}
}
