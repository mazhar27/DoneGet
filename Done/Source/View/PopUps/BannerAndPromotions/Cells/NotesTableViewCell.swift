//
//  NotesTableViewCell.swift
//  Done
//
//  Created by Adeel Hussain on 14/11/2022.
//

import UIKit
import Localize_Swift

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var noteLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if Localize.currentLanguage() == "ar" {
            noteLabel.textAlignment = .right
        }else{
            noteLabel.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
