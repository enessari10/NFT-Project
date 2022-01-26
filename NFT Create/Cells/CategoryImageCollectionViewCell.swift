//
//  CategoryImageCollectionViewCell.swift
//  NFT Create
//
//  Created by Enes on 26.01.2022.
//

import UIKit

class CategoryImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var categoryImage: UIImageView!
    override func awakeFromNib() {
        categoryImage.layer.cornerRadius = 10
    }
}
