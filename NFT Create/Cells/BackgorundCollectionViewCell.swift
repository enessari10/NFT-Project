//
//  BackgorundCollectionViewCell.swift
//  NFT Create
//
//  Created by Enes on 25.01.2022.
//

import UIKit

class BackgorundCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var backgroundImage: UIImageView!
    override func awakeFromNib() {
        backgroundImage.layer.cornerRadius = 10
    }
}
