//
//  ProvidersDetailsCVC.swift
//  Done
//
//  Created by Mazhar Hussain on 17/06/2022.
//

import UIKit

class ProvidersDetailsCVC: UICollectionViewCell {
    @IBOutlet weak var outerVu: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outerVu.layer.masksToBounds = false
    }
//    func configureCell(slot: Slots){
//        titleLbl.text = (slot.slot_time_from ?? "") + " to " + (slot.slot_time_to ?? "")
//    }
//    func configureCell(slot: Slots){
//        self.titleLbl.text = (slot.slot_time_from ?? "") + " to " + (slot.slot_time_to ?? "")
//       if slot.isSelected{
//            outerVu.backgroundColor = UIColor.blueThemeColor
//            titleLbl.textColor = UIColor.white
//        }else{
//            outerVu.backgroundColor = UIColor.white
//            titleLbl.textColor = UIColor.grayTextColor
//        }
//    }
    
    func configureCell(item: Slots){
        self.titleLbl.text = (item.slot_time_from ?? "") + " to " + (item.slot_time_to ?? "")
        if item.status == 1 && item.isSelected == false{
          outerVu.backgroundColor = UIColor.white
          outerVu.borderColor = UIColor.white
          titleLbl.textColor = UIColor.labelTitleColor
        }else if item.isSelected{
          outerVu.backgroundColor = UIColor.blueThemeColor
          titleLbl.textColor = UIColor.white
        }else{
          outerVu.backgroundColor = UIColor.disableBackgroundColor
          titleLbl.textColor = UIColor.lightGrayThemeColor
        }
      }
    func configureTopUp(item: TopUpModel){
        self.titleLbl.text = item.title
        if item.isSelected == false{
            outerVu.backgroundColor = UIColor.white
            outerVu.borderColor = UIColor.white
            titleLbl.textColor = UIColor.labelTitleColor
        }else{
            outerVu.backgroundColor = UIColor.blueThemeColor
            titleLbl.textColor = UIColor.white
        }
    }
    
}
