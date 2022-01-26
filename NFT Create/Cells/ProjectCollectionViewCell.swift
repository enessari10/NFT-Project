//
//  ProjectCollectionViewCell.swift
//  NFT Create
//
//  Created by Enes on 26.01.2022.
//

import UIKit

class ProjectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var projectImage: UIImageView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var projectName: UILabel!
    @IBOutlet var deleteButtonPressed: UIButton!
    
    override func awakeFromNib() {
        projectImage.layer.cornerRadius = 10
    }
    
    @IBAction func deleteButtonPressedButton(_ sender: Any) {
    }
    
}
