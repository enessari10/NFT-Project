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
    func didSelectCell(atIndexImage:UIImage, atIndex:Bool, isPro:String)
    func isNotProNextPage()
}

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet var categoryCollectionView: UICollectionView!
    var getData = GetDataClass()
    var selectImage = UIImage()
    var delegate : ImagesCollectionCellDelegate?
    var iapHelper = IAPHelper()
    let isPro = UserDefaults.standard.bool(forKey: "isPro")
    var imageClass = MergeImageClass()

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
        
        AF.request(getData.ImagesArray[indexPath.row].imageURL).responseImage { response in
            if case .success(let getImage) = response.result {
                cell.categoryImage.image = getImage
            }
        }
        cell.stateLabel.text = getData.ImagesArray[indexPath.row].imagePro
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
      
            if isPro == true{
                AF.request(getData.ImagesArray[indexPath.row].imageURL).responseImage { response in
                    if case .success(let getImage) = response.result {
                        self.delegate?.didSelectCell(atIndexImage: getImage,atIndex: true,isPro: self.getData.ImagesArray[indexPath.row].imagePro)
                        }
                    }
            }
            else{
                // Proya tıkladı ama kullanıcı pro değil
                if getData.ImagesArray[indexPath.row].imagePro=="Free"{
                    AF.request(getData.ImagesArray[indexPath.row].imageURL).responseImage { response in
                        if case .success(let getImage) = response.result {
                            let image = self.imageClass.mergeWith(topImage: self.imageClass.topImageLogo!, bottomImage: getImage)
                            self.delegate?.didSelectCell(atIndexImage: image,atIndex: true,isPro: self.getData.ImagesArray[indexPath.row].imagePro)
                            }
                        }
                }else{
                    delegate?.isNotProNextPage()

                }
            }
          
        
    }
    
}



