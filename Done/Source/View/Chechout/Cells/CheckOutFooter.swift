//
//  CheckOutFooter.swift
//  Done
//
//  Created by Mazhar Hussain on 16/06/2022.
//

import UIKit
import Localize_Swift

class CheckOutFooter: UITableViewCell {

    @IBOutlet weak var voucherDisTitleLbl: UILabel!
    @IBOutlet weak var walletBalanceTitleLbl: UILabel!
    @IBOutlet weak var vatTitleLbl: UILabel!
    @IBOutlet weak var subtotalTitleLbl: UILabel!
    @IBOutlet weak var walletBlncLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var vatLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Localization()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func Localization(){
        vatTitleLbl.text = "VAT".localized()
        walletBalanceTitleLbl.text = "Wallet Balance".localized()
        voucherDisTitleLbl.text = "Coupon Discount".localized()
        subtotalTitleLbl.text = "Subtotal".localized()
    }
    func configureCell(item: Extras, walletBalance: String){
        subTotalLbl.text =  "SAR " + (item.services_total ?? "0")
        vatLbl.text = "SAR " + (item.vat_amount ?? "0")
        discountLbl.text = "-SAR " + (item.discount_amount ?? "0")
        walletBlncLbl.text = "-SAR " + (walletBalance)
    }
    
}
