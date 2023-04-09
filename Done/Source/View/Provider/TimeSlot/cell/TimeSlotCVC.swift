//
//  TimeSlotCVC.swift
//  Done
//
//  Created by Dtech Mac on 08/09/2022.
//

import UIKit

class TimeSlotCVC: UICollectionViewCell {
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var lblTitleDay: UILabel!
    @IBOutlet weak var lblTitleDayNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outerView.layer.cornerRadius = 8.0
      outerView.layer.masksToBounds = false
        outerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        outerView.layer.shadowRadius = 2.5
        outerView.layer.shadowOpacity = 1
       outerView.layer.shadowOffset = CGSize(width: 0, height: 0)
       
    }
    override var isSelected: Bool {
          didSet {
              self.backgroundColor = isSelected ? .blueThemeColor : .white
          }
      }
    func configureCell(item: String){
       
        let dateString = item
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else {
            return
        }
       formatter.dateFormat = "EEE"
        let month = formatter.string(from: date)
        lblTitleDay.text = month
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        lblTitleDayNumber.text = day
      
      
//       let components = date.get(.day, .month, .year)
//        if let day = components.day, let month = components.month, let year = components.year {
//            print("day: \(day), month: \(month), year: \(year)")
//            lblTitleDayNumber.text = String(day)
//            lblTitleDay.text = month
//        }
    }
}
