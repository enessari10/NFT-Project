//
//  PaymentScreenViewController.swift
//  NFT Create
//
//  Created by Enes on 28.01.2022.
//

import UIKit
import SafariServices

class PaymentScreenViewController: UIViewController{
    
    @IBOutlet var paymentButton: UIButton!
    var iAPHelper = IAPHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iAPHelper.getIAPlocalPrice()
        iAPHelper.delegate = self
        paymentButton.isHidden = true
    }
    
    @IBAction func restoreButton(_ sender: Any) {
        iAPHelper.restorePurchase()

    }
    @IBAction func privacyPolicy(_ sender: Any) {
        if let url = URL(string: "https://enessari.com/nftcreator/privacy.html") {
               let config = SFSafariViewController.Configuration()
               config.entersReaderIfAvailable = true

               let vc = SFSafariViewController(url: url, configuration: config)
               present(vc, animated: true)
           }
    }
    
    @IBAction func termsOfUse(_ sender: Any) {
        if let url = URL(string: "https://enessari.com/nftcreator/terms.html") {
               let config = SFSafariViewController.Configuration()
               config.entersReaderIfAvailable = true

               let vc = SFSafariViewController(url: url, configuration: config)
               present(vc, animated: true)
           }
    }
    @IBAction func paymentButtonPressed(_ sender: Any) {
        iAPHelper.purchase()
    }
    
    
    
    
}
extension PaymentScreenViewController: InAppPurchaseDelegate {
    
    func restoreDidSucceed() {
        let isPro = true
        UserDefaults.standard.set(isPro, forKey: "isPro")
        navigationController?.popViewController(animated: true)
    }
    
    func purchaseDidSucceed() {
        
        let isPro = true
        UserDefaults.standard.set(isPro, forKey: "isPro")
        navigationController?.popViewController(animated: true)
        
    }
    
    func nothingToRestore() {
        
        navigationController?.popViewController(animated: true)
    }
    
    func paymentCancelled() {
        let ac = UIAlertController(title: "Error", message: "Payment Cancelled", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        ac.addAction(okAction)
        self.present(ac, animated: true)
    }
    
    func returnIAPlocalPrice(localPrice: String) {
        paymentButton.setTitle("\(localPrice) / Month", for:.normal)
        paymentButton.isHidden = false

    }
    
}
