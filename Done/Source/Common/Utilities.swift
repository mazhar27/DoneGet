//
//  Utilities.swift
//  Done
//
//  Created by Mazhar Hussain on 26/10/2022.
//

import Foundation

class Utilities{
    
    static let shared = Utilities()
    private init() {}
    
    func showVersionUpdateAlert(message: String) {
        let alertController: UIAlertController = UIAlertController(title: "Done".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Update".localized(), style: .default, handler: {_ in
            guard let url = URL(string: appStoreURL) else {
              return //be safe
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            self.showVersionUpdateAlert(message: message)
        })
        alertController.addAction(okAction)
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
//        present(alertController, animated: true, completion: nil)
    }
}
