//
//  addInvoiceTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 30/08/2022.
//

import UIKit

class addInvoiceTVC: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var additionalPriceLbl: UILabel!
    @IBOutlet weak var servicePriceLbl: UILabel!
    @IBOutlet weak var serviceImgVu: UIImageView!
    @IBOutlet weak var providerNameLbl: UILabel!
    @IBOutlet weak var serviceDescLbl: UILabel!
    @IBOutlet weak var serviceTitleLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var orderNumLbl: UILabel!
    @IBOutlet weak var outerVu: UIView!
    
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var additionalInvoicesLabel: UILabel!
    @IBOutlet weak var serviceOnCashLabel: UILabel!
    
    @IBOutlet weak var desLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.orderIdLabel.text = "Order Id".localized()
        self.additionalInvoicesLabel.text = "Additional Invoice".localized()
        self.serviceOnCashLabel.text = "Service on Cash".localized()
        self.desLabel.text = "Description".localized()
        self.acceptBtn.setTitle("Accept".localized(), for: .normal)
        self.rejectBtn.setTitle("Reject".localized(), for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        outerVu.layer.masksToBounds = false

        // Configure the view for the selected state
    }
    func configureCell(item: AdditionalInvoiceData){
        orderNumLbl.text = String(item.order_number ?? 0)
        addressLbl.text = item.address_title
        serviceTitleLbl.text = item.service_title
        serviceDescLbl.text = item.category_title
        providerNameLbl.text = item.provider_name
        servicePriceLbl.text = "SAR " + (item.additional_price ?? "")
        additionalPriceLbl.text = "SAR " + (item.total_amount ?? "")
        descriptionLbl.text = item.additional_remarks
        let dateString = item.service_time ?? ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateString) else {
            return
        }
        dateTimeLbl.text = DateFormatter.DDmonthYYYY.string(from: date)
        timeLbl.text = DateFormatter.hmma.string(from: date)
    }
    
}
