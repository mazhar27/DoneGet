//
//  JobDetailsTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 08/09/2022.
//

import UIKit
import Localize_Swift

class JobDetailsTVC: UITableViewCell {

    @IBOutlet weak var getDirectionLbl: UILabel!
    @IBOutlet weak var rejectionLblTopCons: NSLayoutConstraint!
    @IBOutlet weak var rejectionLbl: UILabel!
    @IBOutlet weak var rejectionReasonTitleLbl: UILabel!
    @IBOutlet weak var amountCollectedTitleLbl: UILabel!
    @IBOutlet weak var totalAmountTitleLbl: UILabel!
    @IBOutlet weak var walletBalanceTitleLbl: UILabel!
    @IBOutlet weak var couponDiscountTtileLbl: UILabel!
    @IBOutlet weak var vatTitleLbl: UILabel!
    @IBOutlet weak var subtotalTitleLbl: UILabel!
    @IBOutlet weak var orderIDttitleLbl: UILabel!
    @IBOutlet weak var addInvoiceTitleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var addInvoiceLbl: UILabel!
    @IBOutlet weak var descTitleLbl: UILabel!
    @IBOutlet weak var serviceCategoryNameLbl: UILabel!
    @IBOutlet weak var getDirectionBtn: UIButton!
    @IBOutlet weak var inviceImgVu: UIImageView!
    @IBOutlet weak var InviceBtn: UIButton!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusOuterVu: UIView!
    @IBOutlet weak var subTotalLbl: UILabel!
    
    @IBOutlet weak var collectedAmountLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var walletBlncLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var VATLbl: UILabel!
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var providerNameLbl: UILabel!
    @IBOutlet weak var serviceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var orderLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.Localization()
    }
    private func Localization(){
        orderIDttitleLbl.text = "Order ID".localized()
        subtotalTitleLbl.text = "Subtotal".localized()
        vatTitleLbl.text = "VAT".localized()
        couponDiscountTtileLbl.text = "Coupon Discount".localized()
        walletBalanceTitleLbl.text = "Wallet Balance".localized()
        totalAmountTitleLbl.text = "Total Amount".localized()
        amountCollectedTitleLbl.text = "Amount to be collected".localized()
       
        descTitleLbl.text = "Description".localized()
        addInvoiceTitleLbl.text = "Additional Invoice".localized()
        rejectionReasonTitleLbl.text = "Rejection Reason".localized()
        getDirectionLbl.text = "Get Directions".localized()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(item: JobDetailsData){
//        subTotalLbl.text = "SAR " + item.payment_details?.base_price
//        collectedAmountLbl.text = "SAR " + item.payment_details?.amount_to_be_collected
//        totalAmountLbl.text = "SAR " + item.payment_details?.total_amount
    }
    func configureCell(type: orderType, item: ProviderJobDetailsData){

        switch type {
        case .pending:
            statusLbl.text = "Pending".localized()
            statusOuterVu.backgroundColor = UIColor.init(hexString: "#FDEECD")
            statusLbl.textColor = UIColor.init(hexString: "#C68900")
            InviceBtn.isHidden = true
            inviceImgVu.isHidden = true
            rejectionReasonTitleLbl.text = ""
            rejectionLblTopCons.constant = 0

        case .accepted:
            statusLbl.text = "Accepted".localized()
            statusOuterVu.backgroundColor = UIColor.init(hexString: "#BFE7FF")
            statusLbl.textColor = UIColor.init(hexString: "#007DC6")
            InviceBtn.isHidden = true
            inviceImgVu.isHidden = true
            rejectionReasonTitleLbl.text = ""
            rejectionLblTopCons.constant = 0
        case .completed:
            statusLbl.text = "Completed".localized()
            statusOuterVu.backgroundColor = UIColor.init(hexString: "#D0FFBF")
            statusLbl.textColor = UIColor.init(hexString: "#00931C")
            InviceBtn.setTitleColor(UIColor.blueThemeColor, for: .normal)
            InviceBtn.setTitle("View Invoice".localized(), for: .normal)
            InviceBtn.isHidden = false
            inviceImgVu.isHidden = false
            rejectionReasonTitleLbl.text = ""
            rejectionLblTopCons.constant = 0
        case .failed:
            statusLbl.text = "Failed".localized()
            statusOuterVu.backgroundColor = UIColor.init(hexString: "#F5CFCF")
            statusLbl.textColor = UIColor.init(hexString: "#F50808")
            InviceBtn.isHidden = true
            InviceBtn.setTitleColor(UIColor.init(hexString: "#F50808"), for: .normal)
            InviceBtn.setTitle("Report Problem".localized(), for: .normal)
            inviceImgVu.isHidden = true
            rejectionReasonTitleLbl.text = "Rejection Reason".localized()
            rejectionLbl.text = item.reject_reason
            rejectionLblTopCons.constant = 14
        }
        subTotalLbl.text = "SAR " + (item.payment_details?.total_amount ?? "0")
        VATLbl.text = "SAR " + (item.payment_details?.vat_amount ?? "0")
        discountLbl.text = "-SAR " + (item.payment_details?.discount_amount ?? "0")
        totalAmountLbl.text = "SAR " + (item.payment_details?.total_amount ?? "0")
        collectedAmountLbl.text = "SAR " + (item.payment_details?.amount_to_be_collected ?? "0")
        walletBlncLbl.text = "SAR " + (item.payment_details?.wallet_amount ?? "0")
        orderLbl.text = "#" + (item.order_number ?? "0")
        addressLbl.text = item.address
        timeLbl.text = item.time
        serviceLbl.text = item.service_title
        descLbl.text = item.description
        addInvoiceLbl.text = item.payment_details?.additional_invoice
        serviceCategoryNameLbl.text = item.category_title
      
//        providerLbl.text = item.provider_name
        serviceTypeLbl.text = item.payment_type
        
    }
    
}
