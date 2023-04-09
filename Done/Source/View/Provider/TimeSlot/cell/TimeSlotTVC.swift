//
//  TimeSlotTVC.swift
//  Done
//
//  Created by Dtech Mac on 08/09/2022.
//

import UIKit

class TimeSlotTVC: UITableViewCell {
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var lblTitleTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(item: Slots){
        if let fromTime = item.slot_time_from, let toTime = item.slot_time_to{
            lblTitleTime.text = fromTime + "-" + toTime
        }
        btnSwitch.isOn = ((item.booking_status ?? 0) != 0)
       
    }

    
}

