//
//  MergeImageClass.swift
//  NFT Create
//
//  Created by Enes on 7.02.2022.
//

import Foundation
import UIKit

class MergeImageClass{
    
    let topImageLogo = UIImage(named: "bgFrame.png")
    func mergeWith(topImage: UIImage, bottomImage:UIImage) -> UIImage {
        UIGraphicsBeginImageContext(bottomImage.size)
        let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: areaSize)
        var logoHeight = 0,logoWidth = 0, logoX = 0, logoY = 0
        let screenBounds = UIScreen.main.bounds
        if screenBounds.width <= 855 {
            //Select BG
            logoWidth = 100
            logoHeight = 100
            logoX = Int(bottomImage.size.width - 120)
            logoY = Int(bottomImage.size.height - 120)
        } else if screenBounds.width >= 3000{
            //Select Gallery Photo
            logoWidth = 400
            logoHeight = 400
            logoX = Int(bottomImage.size.width - 500)
            logoY = Int(bottomImage.size.height - 500)
        } else if screenBounds.width == 1668{
            //Select Potrait Photo
            logoWidth = 250
            logoHeight = 250
            logoX = Int(bottomImage.size.width - 300)
            logoY = Int(bottomImage.size.height - 300)
        }else if screenBounds.width < 250{
            logoWidth = 25
            logoHeight = 25
            logoX = Int(bottomImage.size.width - 100)
            logoY = Int(bottomImage.size.height - 100)
        }
        topImage.draw(in: CGRect.init(x: logoX, y: logoY, width: logoWidth, height:logoHeight))
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
    }
}
