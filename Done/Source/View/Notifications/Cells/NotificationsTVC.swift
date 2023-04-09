//
//  NotificationsTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 21/06/2022.
//

import UIKit

class NotificationsTVC: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    func configureCell(item: NotificationsModel){
//        titleLbl.text = item.title
//        descLbl.text = item.details
//        dateLbl.text = item.time
//    }
    
    
    func configureCell(item: NotificationsData){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"
        let dateConv = dateFormatter.date(from: item.created_at ?? "")
        dateFormatter.dateFormat = "hh:mm a"
        let currentTime = dateFormatter.string(from: dateConv ?? Date())
        dateLbl.text = currentTime
        
        descLbl.text = item.notification_detail
        titleLbl.text = item.notification_title
    }
    
}
