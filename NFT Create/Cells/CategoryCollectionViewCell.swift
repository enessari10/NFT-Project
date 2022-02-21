//
//  CategoryCollectionViewCell.swift
//  NFT Create
//
//  Created by Enes on 24.01.2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var categoryImage: UIImageView!
    override func awakeFromNib() {
        categoryImage.layer.cornerRadius = 15
    }
}
