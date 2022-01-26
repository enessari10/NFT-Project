//
//  SliderTableViewCell.swift
//  NFT Create
//
//  Created by Enes on 24.01.2022.
//

import UIKit
import Alamofire
import AlamofireImage
import Kingfisher

class SliderTableViewCell: UITableViewCell {
    
    @IBOutlet var sliderCollectionView: UICollectionView!
    @IBOutlet weak var imgvHeader: UIImageView!
    
    var getData = GetDataClass()
    var timer = Timer()
    var counter = 0
    var urlImage : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        getData.getSlidersData()
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (Timer) in
            self.sliderCollectionView.reloadData()
            print(self.getData.SliderArray.count)
        }
       DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    @objc func changeImage(){
        if counter < getData.SliderArray.count{
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
        }else{
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension SliderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getData.SliderArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCollectionCell", for: indexPath) as? SliderCollectionViewCell else { fatalError()}
        cell.sliderImage.kf.indicatorType = .activity
        cell.sliderImage.kf.setImage(with: URL(string:  getData.SliderArray[indexPath.row].imageURL), placeholder: nil, options: [.transition((.fade(0.7)))], progressBlock: nil)
        
        return cell
    }
    
    
}
