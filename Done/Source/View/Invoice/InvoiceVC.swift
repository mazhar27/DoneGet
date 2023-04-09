//
//  InvoiceVC.swift
//  Done
//
//  Created by Mazhar Hussain on 22/08/2022.
//

import UIKit
import WebKit
import Localize_Swift

class InvoiceVC: BaseViewController,WKNavigationDelegate {

    @IBOutlet weak var downloadInvoiceBtn: UIButton!
    @IBOutlet weak var webVu: WKWebView!
    @IBOutlet weak var addInvoiceBtn: UIButton!
    @IBOutlet weak var viewInvoiceBtn: UIButton!
    var urlString = ""
    var invoiceUrl = ""
    var addInvoiceUrl = ""
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup(url: invoiceUrl)
        viewInvoiceBtn.backgroundColor = UIColor.blueThemeColor
        viewInvoiceBtn.setTitleColor(UIColor.white, for: .normal)
        addInvoiceBtn.backgroundColor = UIColor.white
        addInvoiceBtn.setTitleColor(UIColor.blueThemeColor, for: .normal)
        self.Localization()
        // Do any additional setup after loading the view.
    }
    private func initialSetup(url: String){
//        webVu.backgroundColor = UIColor.white
//        webVu.isOpaque = false
        if url != ""{
            webVu.load(URLRequest(url: URL(string:url)!))
        }
        label.isHidden = true
//        if addInvoiceUrl == ""{
//            addInvoiceBtn.isEnabled = false
////            addInvoiceBtn.backgroundColor = UIColor.gray
//            addInvoiceBtn.setTitleColor(UIColor.gray, for: .disabled)
//        }
    }
    private func Localization(){
        addInvoiceBtn.setTitle("Additional Invoice".localized(), for: .normal)
        viewInvoiceBtn.setTitle("View Invoice".localized(), for: .normal)
        downloadInvoiceBtn.setTitle("Download Invoice".localized(), for: .normal)
    }
    

    @IBAction func viewInvoiceBtnTpd(_ sender: UIButton) {
        if sender.tag == 0{
            label.isHidden = true
            webVu.isHidden = false
            viewInvoiceBtn.backgroundColor = UIColor.blueThemeColor
            viewInvoiceBtn.setTitleColor(UIColor.white, for: .normal)
            addInvoiceBtn.backgroundColor = UIColor.white
            addInvoiceBtn.setTitleColor(UIColor.blueThemeColor, for: .normal)
          urlString = invoiceUrl
            initialSetup(url: invoiceUrl)
        }else{
            viewInvoiceBtn.setTitleColor(UIColor.blueThemeColor, for: .normal)
            addInvoiceBtn.backgroundColor = UIColor.blueThemeColor
            addInvoiceBtn.setTitleColor(UIColor.white, for: .normal)
            viewInvoiceBtn.backgroundColor = UIColor.white
            if addInvoiceUrl == ""{
                webVu.isHidden = true
                label.isHidden = false
                label.center = CGPoint(x:  self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
                   label.textAlignment = .center
                label.text = "No Additional Invoice.".localized()

                   self.view.addSubview(label)
            }else{
                webVu.isHidden = false
                urlString = addInvoiceUrl
                  initialSetup(url: addInvoiceUrl)
            }
            
           
        }
    }
    
    @IBAction func downloadInvoiceBtnTpd(_ sender: Any) {
        guard let pdfFilePath = URL(string: self.urlString) else { return }
        let pdfData = NSData(contentsOf: pdfFilePath)
        let activityVC = UIActivityViewController(activityItems: [pdfData!], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
   
    
}
