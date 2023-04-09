//
//  subCategoriesHeaderCell.swift
//  Done
//
//  Created by Dtech Mac on 06/09/2022.
//

import UIKit

class subCategoriesHeaderCell: UITableViewCell {
    @IBOutlet weak var lblSubCategoriesHeader: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configurHeaderCell(header:String){
        lblSubCategoriesHeader.text = header
    }
    
}
