//
//  CategoryTableViewCell.swift
//  NFT Create
//
//  Created by Enes on 24.01.2022.
//

import UIKit
import Alamofire
import AlamofireImage
import Kingfisher

protocol ImagesCollectionCellDelegate {
    func didSelectCell(atIndex:UIImage)
}

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet var categoryCollectionView: UICollectionView!
    var getData = GetDataClass()
    var selectImage = UIImage()
    var delegate : ImagesCollectionCellDelegate?
    var iapHelper = IAPHelper()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        getData.getCategoriesData()
        getData.getImagesData()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (Timer) in
            self.categoryCollectionView.reloadData()
        }
        if getData.state == .isTrue{
            print("PROOO KULLANICI ÇALIŞTIIII")
        }
        else{
            print("FREE KULLANICI ÇALIŞTIIII")

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
        
        AF.request(getData.ImagesArray[indexPath.row].imageURL).responseImage { response in
            if case .success(let getImage) = response.result {
                cell.categoryImage.image = getImage
            }
        }
        cell.stateLabel.text = getData.ImagesArray[indexPath.row].imagePro
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if getData.ImagesArray[indexPath.row].imagePro == "PRO"{
            if getData.state == .isTrue{
                AF.request(getData.ImagesArray[indexPath.row].imageURL).responseImage { response in
                    if case .success(let getImage) = response.result {
                        self.delegate?.didSelectCell(atIndex: getImage)
                    }
                }
            }
            else{
                // Ödeme sayfasına yönlendirme
            }
        } else{
            AF.request(getData.ImagesArray[indexPath.row].imageURL).responseImage { response in
                if case .success(let getImage) = response.result {
                    self.delegate?.didSelectCell(atIndex: getImage)
                }
            }
        }
        
    }
}



