//
//  APIService.swift
//  NFT Create
//
//  Created by Enes on 24.01.2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIService{
    
    //Verileri JSON olarak getiren fonksiyon
    func getAllData(url : String, completion: @escaping (JSON) -> Void){
        DispatchQueue.main.async {
            AF.request(url).responseJSON{ response in
                switch response.result{
                case .success(let value):
                    completion(JSON(value))
                case .failure(let error):
                    print(error)
                    completion(JSON(error))
                    
                }
                
            }
        }
    }

}
