//
//  SliderCell.swift
//  Done
//
//  Created by Mazhar Hussain on 01/06/2022.
//

import UIKit

class SliderCell: UICollectionViewCell {

    @IBOutlet weak var imgVuHeightCons: NSLayoutConstraint!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgVu: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populateData(page: Page) {
        imgVu.image = UIImage(named: page.sliderImage)
     titleLbl.text = page.sliderTitle
        detailLbl.text = page.sliderDetail

    }
}
