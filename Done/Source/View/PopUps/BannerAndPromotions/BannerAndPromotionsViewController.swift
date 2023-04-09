//
//  BannerAndPromotionsViewController.swift
//  Done
//
//  Created by Adeel Hussain on 08/11/2022.
//

import UIKit

class BannerAndPromotionsViewController: UIViewController {
    let pageView : BannerAndPromotionsPageViewController = BannerAndPromotionsPageViewController()
    var selectedIndex : Int = 0
    var comefromCart = false
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.layer.cornerRadius = 30
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.pageView.selectedIndex = self.selectedIndex
        self.pageView.comeFromCartVC = comefromCart
        self.addChild(self.pageView)
        self.containerView.addSubview(self.pageView.view)
        self.pageView.view.frame = self.containerView.bounds
        
    }
//MARK: Actions
    
    @IBAction func crossButtonClickAction(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
}
