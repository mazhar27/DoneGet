//
//  ServiceQuestionTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 14/07/2022.
//

import UIKit
import iOSDropDown
import Localize_Swift

class ServiceQuestionTVC: UITableViewCell {

    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var titleLbl: UILabel!
    
    var options: [Optiontree] = []
    var optionTapped: ((Optiontree, ServiceQuestionTVC) -> Void)?
    var dropDownData = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dropDown.layer.shadowOpacity = 0.6
        dropDown.layer.shadowRadius = 1.0
        dropDown.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        dropDown.layer.shadowOffset = CGSize(width: 0, height: 3)
        dropDown.layer.shadowColor = UIColor.lightGray.cgColor //Any dark color
        if Localize.currentLanguage() == "ar"{
            dropDown.textAlignment = .right
        }else{
            dropDown.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(item: AMPGenericObject){
        titleLbl.text = item.name
        for option in item.optiontree{
            dropDownData.append(option.option ?? "")
        }
        setupFiltersDropDown()
        dropDownData.removeAll()
        
    }
    private func setupFiltersDropDown(){
        dropDown.arrowColor = UIColor.blueThemeColor
        dropDown.optionArray = dropDownData
        dropDown.text = "Choose the Option".localized()
        dropDown.didSelect{(selectedText , index ,id) in
            self.dropDown.text = selectedText
            self.optionTapped!(self.options[index], self)
            
        }
    }
    
}
