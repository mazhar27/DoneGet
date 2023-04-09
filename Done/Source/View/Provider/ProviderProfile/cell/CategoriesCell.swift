//
//  CategoriesCell.swift
//  Done
//
//  Created by Dtech Mac on 06/09/2022.
//

import UIKit

protocol SecondVCDelegate: NSObject {
    func didSelectDataAt(_ index: Int)
}
class CategoriesCell: UITableViewCell {
    
    @IBOutlet weak var collectionV: UICollectionView!
    var servicesData = [Main_services]()
    var selectedService : Main_services?
    var collectionSelectionDelegate : SecondVCDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionvuLayout()
        let nib = UINib(nibName: "CategoryCVC", bundle: nil)
        self.collectionV.register(nib, forCellWithReuseIdentifier: "CategoryCVC")
    }
    func setCellContent(serviceData : [Main_services], selectedService : Main_services) -> () {
        self.servicesData = serviceData
        self.selectedService = selectedService
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func collectionvuLayout(){
        collectionV.allowsSelection = true
        collectionV.allowsMultipleSelection = false
        collectionV.dataSource = self
        collectionV.delegate = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (collectionV.frame.width - 30) / 3, height: collectionV.frame.height)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        collectionV!.collectionViewLayout = layout
    }
  
    
}
extension CategoriesCell: UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servicesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCVC", for: indexPath) as! CategoryCVC

        cell.configureCellForProfile(item: servicesData[indexPath.item],selecedService: self.selectedService!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width) / 3, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.collectionSelectionDelegate.didSelectDataAt(indexPath.row)

    }
}
