//
//  subCategoriesCell.swift
//  Done
//
//  Created by Dtech Mac on 06/09/2022.
//

import UIKit

class subCategoriesCell: UITableViewCell {
    @IBOutlet weak var lblSubCategories: UILabel!
    @IBOutlet weak var imageVsubCategories: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureSubCategoryCell(categoryCell : Categories) {
        lblSubCategories.text = categoryCell.category_title
        
    }
    
}
