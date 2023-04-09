//
//  CustomFooterView.swift
//  CustomHeaderView
//
//  Created by Santosh on 04/08/20.
//  Copyright © 2020 Santosh. All rights reserved.
//

import UIKit

class CustomFooterView: UITableViewHeaderFooterView {

   
    @IBOutlet weak var collectionVu: UICollectionView!
    @IBOutlet weak var uploadVu: UIView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var uploadImgOuterVu: UIView!
    @IBOutlet weak var uploadImgLbl: UILabel!
    @IBOutlet weak var textVu: UITextView!
    @IBOutlet weak var textOuterVu: UIView!
    @IBOutlet weak var addDescriptionLbl: UILabel!
    
    
    var imagesData = [UIImage]()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func initialViewSetup(){
        uploadImgOuterVu.isHidden = true
        textOuterVu.layer.masksToBounds = false
        uploadImgOuterVu.layer.masksToBounds = false
        textVu.layer.cornerRadius = 5
    }
    func initialSetup(){
      let nib = UINib(nibName: "imagesCVC", bundle: nil)
        collectionVu?.register(nib, forCellWithReuseIdentifier: "imagesCVC")
        collectionVu.dataSource = self
        collectionVu.delegate = self
        collectionVu.showsHorizontalScrollIndicator = false
        collectionVu.isPagingEnabled = true
        collectionvuLayout()
    }
    func collectionvuLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (collectionVu.frame.width - 40) / 4, height: 70)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionVu!.collectionViewLayout = layout
    }

}

//MARK: - UICollectionView Delegate

extension CustomFooterView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCVC",for: indexPath) as! imagesCVC
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionVu.frame.width) / 4, height: 70)
    }
   
   
}
