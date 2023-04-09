//
//  Localize-Extension.swift
//  Done
//
//  Created by Mazhar Hussain on 6/2/22.
//

import Foundation
import Localize_Swift


extension Localize {
    
    static var isArabicLanguage: Bool {
        return Localize.currentLanguage() == "ar"
    }
    
    static var isRTL: Bool {
        return Localize.currentLanguage() == "ar" ? true : false
    }
    
    static var currentLanguageLocaleName: String {
        return langLocale(langCode: currentLanguage()) ?? currentLanguage()
    }
    
    static var changeNotification: Notification.Name {
        return .init(LCLLanguageChangeNotification)
    }
    
    class func langLocale(langCode:String, showLangInCurrentLocaleALSO: Bool = false) -> String? {
        let locale = Locale(identifier: langCode)
        let langLocale = locale.localizedString(forIdentifier: langCode)?.capitalized ?? ""
        
        if showLangInCurrentLocaleALSO && langCode != Localize.currentLanguage() {
            let currentLocale = Locale(identifier: Localize.currentLanguage())
            let currentLangLocaleName = currentLocale.localizedString(forIdentifier: langCode)?.capitalized ?? ""
            return langLocale + " - " + currentLangLocaleName
        } else {
            return langLocale
        }
    }
    
    class func localizeNumber(_ value: Int) -> String {
        let nf = NumberFormatter()
        nf.locale = Locale(identifier: currentLanguage())
        return nf.string(from: value as NSNumber) ?? "0"
    }
}
