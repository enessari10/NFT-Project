//
//  SliderCollectionViewCell.swift
//  NFT Create
//
//  Created by Enes on 24.01.2022.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var sliderImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        sliderImage.layer.cornerRadius = 20
        sliderImage.layer.borderWidth = 1
        let myColor : UIColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        sliderImage.layer.borderColor = myColor.cgColor
        //UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    }
}
