//
//  languageVC.swift
//  Done
//
//  Created by Mazhar Hussain on 01/06/2022.
//

import UIKit
import Localize_Swift

class LanguageVC: UIViewController {
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var englishBtn: UIButton!
    @IBOutlet weak var arabicBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialsetup()
        
        // Do any additional setup after loading the view.
    }
    
    private func initialsetup(){
        self.languageLbl.text = "Select language".localized()
        arabicBtn.setTitle("Arabic (عربي)", for: .normal)
        englishBtn.setTitle("English", for: .normal)
    }
    
    private func moveToNextVC(){
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            let onBoardingStoryboard = UIStoryboard(name: Storyboards.onBoarding, bundle: nil)
            guard let onboardingVC = onBoardingStoryboard.instantiateViewController(withIdentifier:
                                                                                        "OnboardingVC") as? OnboardingVC else {
                return
            }
            self?.show(onboardingVC, sender: self)
        }
        
    }
    
    @IBAction func languageBtnTpd(_ sender: UIButton) {
        if sender.tag == 0{
            englishBtn.backgroundColor = UIColor.blueThemeColor
            englishBtn.setTitleColor(UIColor.white, for: .normal)
            englishBtn.tintColor = UIColor.white
            arabicBtn.backgroundColor = UIColor.white
            arabicBtn.setTitleColor(UIColor.blueThemeColor, for: .normal)
            arabicBtn.tintColor = UIColor.blueThemeColor
            Localize.setCurrentLanguage("en")
        }else{
            arabicBtn.backgroundColor = UIColor.blueThemeColor
            arabicBtn.setTitleColor(UIColor.white, for: .normal)
            arabicBtn.tintColor = UIColor.white
            englishBtn.backgroundColor = UIColor.white
            englishBtn.setTitleColor(UIColor.blueThemeColor, for: .normal)
            englishBtn.tintColor = UIColor.blueThemeColor
            Localize.setCurrentLanguage("ar")
            
        }
        UserDefaults.hasAppLanguageChanged = true
        moveToNextVC()
    }
    
}
