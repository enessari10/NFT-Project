//
//  CategoryCollectionViewCell.swift
//  NFT Create
//
//  Created by Enes on 24.01.2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var stateView: UIView!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var categoryImage: UIImageView!
    override func awakeFromNib() {
        categoryImage.layer.cornerRadius = 10
        stateView.layer.cornerRadius = 10
    }
}
