//
//  SideMenuCell.swift
//  Done
//
//  Created by Mazhar Hussain on 13/06/2022.
//

import UIKit
import Localize_Swift

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var newInvoiceLbl: UILabel!
    @IBOutlet weak var lowerVu: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgVu: UIImageView!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newInvoiceLbl.text = "New".localized()
       
    }
    func aniumateLabel(){
        self.newInvoiceLbl.alpha = 1
        UIView.animate(withDuration: 0.7, delay: 0.0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            self.newInvoiceLbl.alpha = 0
        }, completion: nil)
    }
    
    
    func configureCell(item: SideMenuItem, row: Int){
        titleLbl.text = item.title
        imgVu.image = UIImage(named: item.ImageName)
        if row == 4 || row == 5 || row == 6{
            lowerVu.isHidden = false
        }else{
            lowerVu.isHidden = true
        }
         if row == 2 && additionalInvoiceCount == 1{
             newInvoiceLbl.isHidden = false
             self.aniumateLabel()
         }else{
             newInvoiceLbl.isHidden = true
             
         }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
