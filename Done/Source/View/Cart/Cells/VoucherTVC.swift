//
//  VoucherTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 21/06/2022.
//

import UIKit
import Localize_Swift
import WSTagsField
protocol couponsDelegate : AnyObject{
    func getCouponsData(coupons: [String])
}


class VoucherTVC: UITableViewCell {

    var viewModel: CartVM?
    @IBOutlet weak var constraintHeightTagsView: NSLayoutConstraint!
    @IBOutlet weak var applyCouponTitleLbl: UILabel!
    
    @IBOutlet weak var tagsVu: UIView!
    @IBOutlet weak var applyBtn: UIButton!
   weak var delegate: couponsDelegate?
     let tagsField = WSTagsField()
    var couponData = [String]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        applyCouponTitleLbl.text = "Apply a Coupon".localized()
        addWSTagField()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func addWSTagField() {
        self.tagsField.frame = tagsVu.bounds
        self.tagsVu.addSubview(self.tagsField)
       self.tagsField.layer.cornerRadius = 3.0
        self.tagsField.spaceBetweenLines = 5
        self.tagsField.spaceBetweenTags = 10
        self.tagsField.layoutMargins = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        self.tagsField.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) //old padding

        self.tagsField.placeholder = self.tagsField.tags.count == 0 ?  "Add Coupons".localized() : ""
        
        self.tagsField.placeholderColor = .gray
        self.tagsField.placeholderAlwaysVisible = true
        self.tagsField.backgroundColor = .clear
        self.tagsField.textField.returnKeyType = .continue
        self.tagsVu.tintColor = UIColor.blueThemeColor
        self.tagsField.delimiter = " "
        self.tagsField.acceptTagOption = WSTagAcceptOption.space
        self.tagsField.font = UIFont.systemFont(ofSize: 14)
        textFieldEvents()
        
    }
    @IBAction func applyBtnTpd(_ sender: Any) {
        self.delegate?.getCouponsData(coupons: couponData)
        couponData.removeAll()
        tagsField.removeTags()
    }
    
    
    func textFieldEvents() {
        self.tagsField.onDidAddTag = { [weak self] field, tag in
            print("onDidAddTag", tag.text)
           
            self?.tagsField.placeholder = self?.tagsField.tags.count == 0 ?  "Add Coupons".localized() : ""
            self?.couponData.append(tag.text)
            DispatchQueue.main.async {
          self?.constraintHeightTagsView.constant = self?.tagsField.contentSize.height ?? 31
                        }
//            if self?.viewModel?.tagsDataArray == nil{
//            self?.viewModel?.tagsDataArray = [tag.text]
//            }else{
//                self?.viewModel?.tagsDataArray.append(tag.text)
//            }
            print("anyth")
        }

        self.tagsField.onDidRemoveTag = { field, tag in
            print("onDidRemoveTag", tag.text)
//            self.removeCouponCode(coupon: tag.text)
           
            self.tagsField.placeholder = self.tagsField.tags.count == 0 ?  "Add Coupons".localized() : ""
//            if self.viewModel?.tagsDataArray != nil{
//            self.couponData = (self.viewModel?.tagsDataArray.filter { $0 != tag.text })!
//            }
//            if self.viewModel?.tagsDataArray.count != 0{
//                self.applyBtn.isEnabled = true
//            }else{
//                self.applyBtn.isEnabled = false
//            }
           
        }

        self.tagsField.onDidChangeText = { _, text in
            print("onDidChangeText")
        }

        self.tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")
        }

        self.tagsField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }

        self.tagsField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }

        self.tagsField.onShouldAcceptTag = { field in
            return field.text != "OMG"
        }
    }
   
    
  
   
    
}

