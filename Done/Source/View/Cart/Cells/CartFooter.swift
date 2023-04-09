//
//  CartFooter.swift
//  Done
//
//  Created by Mazhar Hussain on 15/06/2022.
//

import UIKit
import Localize_Swift

class CartFooter: UITableViewCell {

    @IBOutlet weak var vatTitleLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var walletBlncLbl: UILabel!
    @IBOutlet weak var vatLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var orderNumOuterVu: UIView!
    
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var walletBalanceLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subTotalLabel.text = "Subtotal".localized()
        self.walletBalanceLabel.text = "Wallet Balance".localized()
        self.discountLabel.text = "Discount".localized()
        self.vatTitleLbl.text = "VAT".localized()
        // Initialization code
        orderNumOuterVu.layer.masksToBounds = false
        orderNumOuterVu.cornerRadius = 5
        orderNumOuterVu.borderWidth = 0.5
        orderNumOuterVu.borderColor = UIColor.white
        orderNumOuterVu.layer.shadowRadius = 2
        orderNumOuterVu.layer.shadowOpacity = 0.6
        orderNumOuterVu.layer.shadowOffset = CGSize(width: 0, height: 0)
        orderNumOuterVu.layer.shadowColor = UIColor.init(hexString: "D9D6D6").cgColor
        if Localize.currentLanguage() == "ar"{
            vatLbl.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(item: Extras, walletBalance: String){
        subTotalLbl.text =  "SAR " + (item.services_total ?? "0")
        vatLbl.text = "SAR " + (item.vat_amount ?? "0")
        discountLbl.text = "-SAR " + (item.discount_amount ?? "0")
        walletBlncLbl.text = "-SAR " + (walletBalance)
    }
    
    
}
