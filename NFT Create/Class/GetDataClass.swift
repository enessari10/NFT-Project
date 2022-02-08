//
//  GetDataClass.swift
//  NFT Create
//
//  Created by Enes on 24.01.2022.
//


import Foundation
import Alamofire
import SwiftyJSON
import ZLImageEditor
import CoreData

enum NFTInAppPaymentState {
    case isTrue
    case isFalse
}

class GetDataClass{
    
    //Data Modeli ve Api tanımlamaları
    var CategoryArray : [CategoriesModel] = []
    var ImagesArray : [ImagesModel] = []
    var SliderArray : [SlidersModel] = []
    var BackgroundsArray : [BackgroundsModel] = []
    var CategoriesAllImages : [CategoryImageModel] = []
    var resultImageEditModel: ZLEditImageModel?
    var apiService = APIService()
    var url = "https://enessari.com/nftcreator/NFTModel.json"
    var jsonData = JSON()
    let userDefaults = UserDefaults.standard
    var state = NFTInAppPaymentState .isFalse

    
    //Kategoriler arrayinde isim ve resimi data modeline göre oluşmuş arraya append ediyor
    func getCategoriesData(){
        self.apiService.getAllData(url: self.url) { json in
            self.jsonData = json
            let data = json["Categories"]
            data.array?.forEach({(cate) in
                let categoryDataModel = CategoriesModel(categoryName: cate["categoryName"].stringValue,categoryImage: cate["categoryImage"].stringValue, categoryURL: cate["categoryURL"].stringValue)
                self.CategoryArray.append(categoryDataModel)
            })
        }
    }
    
    //NFT Görselleri arrayinde görsel url ve pro data modeline göre oluşmuş arraya append ediyor
    func getImagesData(){
        self.apiService.getAllData(url: self.url) { json in
            self.jsonData = json
            let data = json["Images"]
            data.array?.forEach({(cate) in
                let imagesDataModel = ImagesModel(imageURL: cate["imageUrl"].stringValue,imagePro: cate["isPro"].stringValue)
                self.ImagesArray.append(imagesDataModel)
            })
        }
    }
    
    //Sliders arrayinde görsel url'ini data modeline göre oluşmuş arraya append ediyor
    func getSlidersData(){
        self.apiService.getAllData(url: self.url) { json in
            self.jsonData = json
            let data = json["Sliders"]
            data.array?.forEach({(cate) in
                let sliderDataModel = SlidersModel(imageURL: cate["imageURL"].stringValue)
                self.SliderArray.append(sliderDataModel)
            })
        }
    }
    
    //Sliders arrayinde görsel url'ini data modeline göre oluşmuş arraya append ediyor
    func getBackgroundsData(){
        self.apiService.getAllData(url: self.url) { json in
            self.jsonData = json
            let data = json["Backgrounds"]
            data.array?.forEach({(cate) in
                let bgModel = BackgroundsModel(imageURL: cate["imageURL"].stringValue)
                self.BackgroundsArray.append(bgModel)
            })
        }
    }
    
    func getCategoryAllImages(selectedURL : String){
        self.apiService.getAllData(url: selectedURL) { json in
            self.jsonData = json
            let data = json["Images"]
            data.array?.forEach({(cate) in
                let imageAll = CategoryImageModel(imageURL: cate["imageUrl"].stringValue,isPro: cate["isPro"].stringValue)
                self.CategoriesAllImages.append(imageAll)
            })
        }
        
    }
    
    
    
}
