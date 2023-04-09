//
//  BannerView.swift
//  Done
//
//  Created by Mazhar Hussain on 16/11/2022.
//

import Foundation
import Localize_Swift

class BannerView : UIView{
    
    @IBOutlet weak var validTillTitleLbl: UILabel!
    @IBOutlet weak var validFromTitleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var outerVu: UIView!
    @IBOutlet weak var imgVu: UIImageView!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var promoCodeLbl: UILabel!
    @IBOutlet weak var validFromLbl: UILabel!
    @IBOutlet weak var validTillLbl: UILabel!
    
    
    func setupUI(){
        validTillTitleLbl.text = "Valid till".localized()
        validFromTitleLbl.text = "Validity from".localized()
       validFromLbl.layer.shadowOpacity = 0.5
       validFromLbl.layer.shadowRadius = 0.5
       validFromLbl.layer.shadowColor = UIColor.black.cgColor
       validFromLbl.layer.shadowOffset = CGSizeMake(0.0, -0.5)
        
       validFromTitleLbl.layer.shadowOpacity = 0.5
        validFromTitleLbl.layer.shadowRadius = 0.5
        validFromTitleLbl.layer.shadowColor = UIColor.black.cgColor
        validFromTitleLbl.layer.shadowOffset = CGSizeMake(0.0, -0.5)
        
        validTillLbl.layer.shadowOpacity = 0.5
        validTillLbl.layer.shadowRadius = 0.5
        validTillLbl.layer.shadowColor = UIColor.black.cgColor
        validTillLbl.layer.shadowOffset = CGSizeMake(0.0, -0.5)
        
        validTillTitleLbl.layer.shadowOpacity = 0.5
        validTillTitleLbl.layer.shadowRadius = 0.5
        validTillTitleLbl.layer.shadowColor = UIColor.black.cgColor
        validTillTitleLbl.layer.shadowOffset = CGSizeMake(0.0, -0.5)
        
        descLbl.layer.shadowOpacity = 0.5
     descLbl.layer.shadowRadius = 0.5
        descLbl.layer.shadowColor = UIColor.black.cgColor
        descLbl.layer.shadowOffset = CGSizeMake(0.0, -0.5)
    }
}
