//
//  ServicesFormFooterTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 15/07/2022.
//

import UIKit
import OpalImagePicker
import Photos
protocol ImagesQATableViewCellDelegate : AnyObject{
    func imagesQATableViewCell(tag: Int)
    func uploadImage()
}

class ServicesFormFooterTVC: UITableViewCell {

    @IBOutlet weak var outerVu: UIView!
    @IBOutlet weak var collectionVu: UICollectionView!
    @IBOutlet weak var uploadImgBtn: UIButton!
    @IBOutlet weak var uploadImgOuterVu: UIView!
    @IBOutlet weak var uploadImgTitleLbl: UILabel!
    
    @IBOutlet weak var imageLimitLabel: UILabel!
    
    @IBOutlet weak var sizeLimitLabel: UILabel!
    weak var delegate: ImagesQATableViewCellDelegate?
    
    var imagesData = [UIImage]()
    let imagePicker = OpalImagePickerController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.uploadImgTitleLbl.text = "Upload images".localized()
        self.imageLimitLabel.text = "Upload Maximum 06 images".localized()
        self.sizeLimitLabel.text = "Max Image Size: 2 MB".localized()
        uploadImgOuterVu.layer.masksToBounds = false
       let nib = UINib(nibName: "imagesCVC", bundle: nil)
          collectionVu?.register(nib, forCellWithReuseIdentifier: "imagesCVC")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialSetup(imagesdata : [UIImage]){
        self.imagesData = imagesdata
        if imagesData.count == 0{
            uploadImgOuterVu.isHidden = false
        }else{
            uploadImgOuterVu.isHidden = true
        }
     
        collectionVu.dataSource = self
        collectionVu.delegate = self
        collectionVu.showsHorizontalScrollIndicator = false
        collectionVu.isPagingEnabled = true
        collectionvuLayout()
        collectionVu.reloadData()
    }
    func reloadCollectionView(imagesdata: [UIImage]){
       
        collectionVu.reloadData()
    }
    func collectionvuLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (collectionVu.frame.width - 40) / 4, height: 80)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionVu!.collectionViewLayout = layout
    }
    
//    @IBAction func uploadImgBtnTpd(_ sender: Any) {
//        uploadImgOuterVu.isHidden = true
//       initialSetup()
//        collectionvuLayout()
//
//    }
}

//MARK: - UICollectionView Delegate

extension ServicesFormFooterTVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCVC",for: indexPath) as! imagesCVC
        if indexPath.row < imagesData.count{
            cell.plusImgVu.isHidden = true
            cell.closeBtn.isHidden = false
        cell.imgVu.image = imagesData[indexPath.item]
        }else{
            cell.closeBtn.isHidden = true
            cell.plusImgVu.isHidden = false
            cell.imgVu.image = nil
        }
        cell.closeBtn.tag = indexPath.row
        cell.closeBtn.addTarget(self, action: #selector(deleteImageBtnTpd(sender:)), for: .touchUpInside)
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionVu.frame.width) / 4, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= imagesData.count{
            delegate?.uploadImage()
        }
    }
    @objc func deleteImageBtnTpd(sender: UIButton){
        imagesData.remove(at: sender.tag)
        delegate?.imagesQATableViewCell(tag: sender.tag)
        collectionVu.reloadData()
    }
   
   
}

//MARK: Convert array of PHAsset to UIImages
        func getAssetThumbnail(assets: [PHAsset]) -> [UIImage] {
            var arrayOfImages = [UIImage]()
            for asset in assets {
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var image = UIImage()
                option.isSynchronous = true
               manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                    image = result!
                    arrayOfImages.append(image)
                })
            }

            return arrayOfImages
        }


