//
//  ProjectCollectionViewCell.swift
//  NFT Create
//
//  Created by Enes on 26.01.2022.
//

import UIKit
import CoreData

class ProjectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var projectImage: UIImageView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var projectName: UILabel!


    override func awakeFromNib() {
        projectImage.layer.cornerRadius = 10
        bgView.layer.cornerRadius = 10
        bgView.layer.maskedCorners = [.layerMinXMaxYCorner ,.layerMaxXMaxYCorner]
       

    }
    
    
}
