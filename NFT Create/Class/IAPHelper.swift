//
//  IAPHelper.swift
//  NFT Create
//
//  Created by Enes on 9.02.2022.
//
import Foundation
import SwiftyStoreKit
import UIKit

protocol InAppPurchaseDelegate: AnyObject {
    
    func restoreDidSucceed()
    func purchaseDidSucceed()
    func nothingToRestore()
    func paymentCancelled()
    func returnIAPlocalPrice(localPrice: String)
    
}

class IAPHelper {
    
    weak var delegate: InAppPurchaseDelegate?
    let productID = "nftcreateenessari"

    
    func getIAPlocalPrice(){
            
        SwiftyStoreKit.retrieveProductsInfo([productID]) { [self] result in
                if let product = result.retrievedProducts.first {
                    let priceString = product.localizedPrice!
                    print("Product: \(product.localizedDescription), price: \(priceString)")
                    delegate?.returnIAPlocalPrice(localPrice: priceString)
                }
                else if let invalidProductId = result.invalidProductIDs.first {
                    print("Invalid product identifier: \(invalidProductId)")
                }
                else {
                    print("Error: \(String(describing: result.error))")
                }
            }
        
    }
    
    func restorePurchase() {
        
        SwiftyStoreKit.restorePurchases(atomically: true) { [self] results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                delegate?.restoreDidSucceed()
            }
            else {
                
                // Nothing to restore
                
                delegate?.nothingToRestore()
            }
        }
    }
    
    func purchase() {
        
        SwiftyStoreKit.purchaseProduct(productID, quantity: 1, atomically: true) { [self] result in
            switch result {
            case .success:
                delegate?.purchaseDidSucceed()
                
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled:
                    
                    delegate?.paymentCancelled()
                    
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                    
                }
            }
        }
    }
    
    
}
