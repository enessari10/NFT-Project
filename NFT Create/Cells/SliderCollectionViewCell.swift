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
        sliderImage.layer.cornerRadius = 5
    }
}
