//
//  CategoryTableViewCell.swift
//  NFT Create
//
//  Created by Enes on 24.01.2022.
//

import UIKit
import Alamofire
import AlamofireImage


class CategoryTableViewCell: UITableViewCell {

    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var categoryNameLabel: UILabel!
    var getData = GetDataClass()

    override func awakeFromNib() {
        super.awakeFromNib()
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        getData.getCategoriesData()
        getData.getImagesData()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (Timer) in
            self.categoryCollectionView.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        getData.ImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allCategoryCollectionCell", for: indexPath) as? CategoryCollectionViewCell else {fatalError() }
        cell.categoryImage.kf.indicatorType = .activity
        cell.categoryImage.kf.setImage(with: URL(string: getData.ImagesArray[indexPath.row].imageURL), placeholder: nil, options: [.transition((.fade(0.7)))], progressBlock: nil)
        categoryNameLabel?.text = getData.CategoryArray[indexPath.row].categoryName
        return cell
    }
    
    
}
