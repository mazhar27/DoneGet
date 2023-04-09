//
//  BannerAndPromotionsPageViewController.swift
//  Done
//
//  Created by Adeel Hussain on 08/11/2022.
//

import UIKit

class BannerAndPromotionsPageViewController: UIPageViewController , UIPageViewControllerDataSource , UIPageViewControllerDelegate{
    
    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    var selectedIndex : Int = 0
    var comeFromCartVC = false
    
    var bannersAndPromotionsDate : [BanerData]?
    var bannersAndPromotionsDataCart : [BanerData]?
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: options)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        retrieveBannersData()
        pageControlSetup()
    }
    private func retrieveBannersData(){
        if let data = UserDefaults.standard.data(forKey: "banners") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode Note
                let decodedData = try decoder.decode([BanerData].self, from: data)
                self.bannersAndPromotionsDate = decodedData
                if comeFromCartVC{
                    if self.bannersAndPromotionsDate?.count != 0 &&  self.bannersAndPromotionsDate != nil{
                        for banner in self.bannersAndPromotionsDate!{
                            if banner.type != "recharge" && banner.type != "signup" && banner.type != "cashback"{
//                                bannersAndPromotionsDataCart?.append(banner)
                                (bannersAndPromotionsDataCart?.append(banner)) ?? (bannersAndPromotionsDataCart = [banner])
                               
                            }
                        }
                    }
                
                    bannersAndPromotionsDate = bannersAndPromotionsDataCart
                    self.setPages()
                }else{
                    self.setPages()
                }
            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }
        
    }
    private func pageControlSetup(){
        // pageControl
         self.pageControl.frame = CGRect()
       self.pageControl.currentPageIndicatorTintColor = UIColor(hexString: "127DC6")
         self.pageControl.pageIndicatorTintColor = UIColor.lightGray;
         self.view.addSubview(self.pageControl)
         
         self.pageControl.translatesAutoresizingMaskIntoConstraints = false
         self.pageControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 68).isActive = true
         self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
         self.pageControl.heightAnchor.constraint(equalToConstant: 11).isActive = true
         self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    func setPages() -> () {
        
        for banner in self.bannersAndPromotionsDate!{
            if banner.type == "cashback" || banner.type == "general" {
                let page1 = self.getViewController(with: "BannerAndPormotionPageViewController",pageData: banner)
                self.pages.append(page1)
            }else{
                let page2 = self.getViewController(with: "ServicesOrProviderBannerPageViewController",pageData: banner)
                self.pages.append(page2)
            }
        }
        setViewControllers([self.pages[self.selectedIndex]], direction: .forward, animated: true, completion: nil)
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = self.selectedIndex
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if self.pages.count == 1{
                return nil
            }
            if viewControllerIndex == 0 {
                // wrap to last page in array
                return self.pages.last
            } else {
                // go to previous page in array
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if self.pages.count == 1{
                return nil
            }
            else if viewControllerIndex < self.pages.count - 1 {
                // go to next page in array
                return self.pages[viewControllerIndex + 1]
            } else {
                // wrap to first page in array
                return self.pages.first
            }
        }
      
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // set the pageControl.currentPage to the index of the current viewController in pages
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.index(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
    private func getViewController(with identitifier: String , pageData : BanerData) -> UIViewController {
        //        var vc = UIViewController()
        if identitifier == "BannerAndPormotionPageViewController"{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identitifier) as! BannerAndPormotionPageViewController
            vc.pageData = pageData
            return vc
        }else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identitifier) as! ServicesOrProviderBannerPageViewController
            vc.pageData = pageData
            return vc
        }
        
    }
}


