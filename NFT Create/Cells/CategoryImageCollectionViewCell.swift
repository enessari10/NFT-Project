//
//  CategoryImageCollectionViewCell.swift
//  NFT Create
//
//  Created by Enes on 26.01.2022.
//

import UIKit

class CategoryImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var isProLabel: UILabel!
    @IBOutlet var bgView: UIView!
    @IBOutlet var categoryImage: UIImageView!
    override func awakeFromNib() {
        categoryImage.layer.cornerRadius = 10
        bgView.layer.cornerRadius = 10
    }
}
