//
//  PaymentScreenViewController.swift
//  NFT Create
//
//  Created by Enes on 28.01.2022.
//

import UIKit

class PaymentScreenViewController: UIViewController,InAppPurchaseDelegate {
    var iapHelper = IAPHelper()
    var getData = GetDataClass()
    @IBOutlet var weekLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        iapHelper.delegate = self
        iapHelper.getIAPlocalPrice()
        if getData.userDefaults.bool(forKey: iapHelper.productID) {
            getData.state = .isTrue
        }
    }
    
    
    @IBAction func paymentButtonPressed(_ sender: Any) {
        iapHelper.purchase()
    }
    
    func restoreDidSucceed() {
        getData.userDefaults.setValue(true, forKey: iapHelper.productID)
        getData.state = .isTrue
    }
    
    func purchaseDidSucceed() {
        getData.userDefaults.setValue(true, forKey: iapHelper.productID)
        getData.state = .isTrue
    }
    
    func nothingToRestore() {
        //
    }
    
    func paymentCancelled() {
        print("PAYMENT CANCEL")
    }
    
    func returnIAPlocalPrice(localPrice: String) {
        weekLabel.text = "Week for \(localPrice)"
    }
    
    
}
