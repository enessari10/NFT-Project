//
//  AllCategoryTableViewCell.swift
//  NFT Create
//
//  Created by Enes on 24.01.2022.
//

import UIKit
import Alamofire
import AlamofireImage

class AllCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet var allCategoriesCollectionView: UICollectionView!
    var getData = GetDataClass()
    var colors = Colors()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        allCategoriesCollectionView.delegate = self
        allCategoriesCollectionView.dataSource = self
        getData.getCategoriesData()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (Timer) in
            self.allCategoriesCollectionView.reloadData()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension AllCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getData.CategoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allCategoriesCollectionCell", for: indexPath) as? AllCategoryCollectionViewCell else { fatalError() }
        cell.categoryLabel.text = getData.CategoryArray[indexPath.row].categoryName
        cell.categoryImage.kf.indicatorType = .activity
        cell.categoryImage.kf.setImage(with: URL(string: getData.CategoryArray[indexPath.row].categoryImage), placeholder: nil, options: [.transition((.fade(0.7)))], progressBlock: nil)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let bgColor = colors.cellColorArray[indexPath.row  % colors.cellColorArray.count]
        cell.contentView.backgroundColor = bgColor
        cell.contentView.layer.cornerRadius = 10
    }
    
    
}
