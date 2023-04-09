//
//  onboardingVC.swift
//  Done
//
//  Created by Mazhar Hussain on 01/06/2022.
//

import UIKit
import Localize_Swift

class OnboardingVC: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var pager: UIPageControl!
    @IBOutlet weak var sliderCollectionVu: UICollectionView!
    @IBOutlet weak var startBtn: UIButton!
    
    
    //MARK: - Variables
    let viewModel =  OnboardingViewModel()
    var currentPage = 0
    
    //MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        if Localize.currentLanguage() == "ar" {
//            UIView.appearance().semanticContentAttribute = .forceRightToLeft
//        }else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
//        }
        initialSetup()
        collectionvuLayout()
        
        // Do any additional setup after loading the view.
    }
    
    func initialSetup(){
        startBtn.setTitle("Get Started".localized(), for: .normal)
        viewModel.getPages()
        let nib = UINib(nibName: "SliderCell", bundle: nil)
        sliderCollectionVu?.register(nib, forCellWithReuseIdentifier: "SliderCell")
        sliderCollectionVu.dataSource = self
        sliderCollectionVu.delegate = self
        sliderCollectionVu.showsHorizontalScrollIndicator = false
        startBtn.isHidden = true
    }
    
    //MARK: - UICollectionView FlowLayout
    func collectionvuLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: sliderCollectionVu.frame.width, height: sliderCollectionVu.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        sliderCollectionVu!.collectionViewLayout = layout
    }
    
    //MARK: - IBActions
    @IBAction func startBtnTpd(_ sender: Any) {
        UserDefaults.hasSeenAppIntroduction = true
        let onBoardingStoryboard = UIStoryboard(name: Storyboards.onBoarding, bundle: nil)
        guard let userSelectionVC = onBoardingStoryboard.instantiateViewController(withIdentifier:
                                                                                    "UserSelectionVC") as? UserSelectionVC else {
            return
        }
        self.show(userSelectionVC, sender: self)
    }
}

//MARK: - UICollectionView delegate methods
extension OnboardingVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell",
                                                      for: indexPath) as! SliderCell
        cell.populateData(page: viewModel.pages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: self.sliderCollectionVu.frame.height)
    }
    
    // to update the UIPageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pager.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        currentPage = pager.currentPage
        if currentPage == (viewModel.pages.count - 1){
            startBtn.isHidden = false
        }else{
            startBtn.isHidden = true
        }
    }
}
