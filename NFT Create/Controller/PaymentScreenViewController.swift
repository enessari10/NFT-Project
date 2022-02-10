//
//  PaymentScreenViewController.swift
//  NFT Create
//
//  Created by Enes on 28.01.2022.
//

import UIKit

class PaymentScreenViewController: UIViewController{
    
    @IBOutlet var weekLabel: UILabel!
    var iAPHelper = IAPHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iAPHelper.getIAPlocalPrice()
        iAPHelper.delegate = self
       
    }
    
    
    @IBAction func paymentButtonPressed(_ sender: Any) {
        iAPHelper.purchase()
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        iAPHelper.restorePurchase()
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
        
        // Maybe  show a nice message saying nothing found
    }
    
    func paymentCancelled() {

        // maybe stop a UIactivityIndicator
    }
    
    func returnIAPlocalPrice(localPrice: String) {
        weekLabel.text = "Buy for \(localPrice)"
    }
    
}
