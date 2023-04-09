//
//  ImageViewrVC.swift
//  Done
//
//  Created by Mazhar Hussain on 22/09/2022.
//

import UIKit
import Localize_Swift

class ImageViewrVC: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var pager: UIPageControl!
    @IBOutlet weak var collectionVu: UICollectionView!
    
    //MARK: - Variables
    var images = [imagesData]()
    
    //MARK: - UIViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButtonItem()
        initialSetup()
        collectionvuLayout()
        
        // Do any additional setup after loading the view.
    }
    //MARK: - Helping Methods
    
    func initialSetup(){
        
        self.title = "Photos".localized()
        let nib = UINib(nibName: "imagesCVC", bundle: nil)
        collectionVu?.register(nib, forCellWithReuseIdentifier: "imagesCVC")
        collectionVu.dataSource = self
        collectionVu.delegate = self
        collectionVu.showsHorizontalScrollIndicator = false
        pager.numberOfPages = images.count
        
    }
    
    //MARK: - UICollectionView FlowLayout
    func collectionvuLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: collectionVu.frame.width, height: collectionVu.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionVu.isPagingEnabled = true
        collectionVu!.collectionViewLayout = layout
    }
 }

//MARK: - UICollectionView delegate methods
extension ImageViewrVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCVC",
                                                      for: indexPath) as! imagesCVC
        cell.plusImgVu.isHidden = true
        cell.closeBtn.isHidden = true
        let imageUrl = URL(string: images[indexPath.item].image_title ?? "")
        cell.imgVu.sd_setImage(with: imageUrl,
                               placeholderImage: UIImage(named: ""))
        cell.imgVu.contentMode = .scaleAspectFit
     return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: self.collectionVu.frame.height)
    }
    
    // to update the UIPageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pager.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        
        
    }
}

