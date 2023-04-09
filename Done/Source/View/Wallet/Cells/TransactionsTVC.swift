//
//  TransactionsTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 23/06/2022.
//

import UIKit

class TransactionsTVC: UITableViewCell {

    @IBOutlet weak var priceLbl: UILabel!
  
    @IBOutlet weak var detailsLblLeadingCons: NSLayoutConstraint!
    @IBOutlet weak var dateLeadingCons: NSLayoutConstraint!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var outerVu: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outerVu.layer.masksToBounds = false
       priceLbl.sizeToFit()
        priceLbl.adjustsFontSizeToFitWidth = true
        priceLbl.minimumScaleFactor = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(item: WalletTransactions){
  detailsLbl.text = item.transaction_detail
        if item.transaction_type == "debit"{
            print("anything")
            priceLbl.textColor = UIColor.init(hexString: "#DB3F3F")
            priceLbl.text = "-SAR " + String(item.transaction_amount ?? 0)
        }else{
            priceLbl.textColor = UIColor.init(hexString: "#007DC6")
        priceLbl.text = "SAR " + String(item.transaction_amount ?? 0)
        }
        let dateString = item.created_at ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateString) else {
            return
        }
        formatter.dateFormat = "MMM"
        let month = formatter.string(from: date)
        monthLbl.text = String(month)
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        dateLbl.text = String(day)
    }
    func configureCellViewAll(item: Details){
        detailsLblLeadingCons.constant = 0
        dateLeadingCons.constant = 0
        dateLbl.text = ""
        monthLbl.text = ""
        dateLbl.isHidden = true
        monthLbl.isHidden = true
        detailsLbl.text = item.transaction_detail
        detailsLbl.textAlignment = .left
       
        if item.transaction_type == "debit"{
            print("anything")
            priceLbl.textColor = UIColor.init(hexString: "#DB3F3F")
            priceLbl.text = "-SAR " + String(item.transaction_amount ?? 0)
        }else{
            priceLbl.textColor = UIColor.init(hexString: "#007DC6")
        priceLbl.text = "SAR " + String(item.transaction_amount ?? 0)
        }
    }
    
}
