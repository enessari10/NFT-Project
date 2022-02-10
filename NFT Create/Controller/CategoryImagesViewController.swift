//
//  CategoryImagesViewController.swift
//  NFT Create
//
//  Created by Enes on 26.01.2022.
//

import UIKit
import Kingfisher
import ZLImageEditor
import Alamofire
import AlamofireImage

class CategoryImagesViewController: UIViewController {
    
    @IBOutlet var categoryCollectionView: UICollectionView!
    var getData = GetDataClass()
    var getURL : String = ""
    var resultImageEditModel: ZLEditImageModel?
    var imageClass = MergeImageClass()
    var coreDataClass = CoreDataClass()
    let isPro = UserDefaults.standard.bool(forKey: "isPro")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData.getCategoryAllImages(selectedURL: getURL)
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (Timer) in
            if self.getData.CategoriesAllImages.count == 0{
                let ac = UIAlertController(title: "Error", message: "Server error, try again", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                ac.addAction(okAction)
                self.present(ac, animated: true)
                
            }else {
                self.categoryCollectionView.delegate = self
                self.categoryCollectionView.dataSource = self
            }
        }
        
        
    }
    func showImageEditor(selectImage:UIImage){
        
        ZLImageEditorConfiguration.default()
            .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
            .adjustTools([.brightness, .contrast, .saturation])
        
        ZLEditImageViewController.showEditImageVC(parentVC: self, image: selectImage, editModel: resultImageEditModel) { [weak self] (resImage, editModel) in
            UIImageWriteToSavedPhotosAlbum(resImage, self, #selector(self!.imageFunc(_:didFinishSavingWithError:contextInfo:)), nil)
            var textField = UITextField()
            let alert = UIAlertController(title: "Add project", message: "", preferredStyle: .alert)
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "Project Name"
                textField = alertTextField
            }
            
            let action = UIAlertAction(title: "Add item", style: .default) { [self] action in
                let newAdd = UserProject(context: self!.coreDataClass.context)
                newAdd.projectName = textField.text!
                newAdd.date = self!.coreDataClass.currentDateTime
                let imageAsNSData = resImage.jpegData(compressionQuality: 1)
                newAdd.image = imageAsNSData
                self!.coreDataClass.coreDataArray.append(newAdd)
                self!.coreDataClass.saveContext()
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ProjectViewController") as! ProjectViewController
                resultViewController.title = "My Projects"
                self?.navigationController?.pushViewController(resultViewController, animated: true)
            }
            alert.addAction(action)
            self!.present(alert, animated: true, completion: nil)
            
            
        }
    }
    @objc func imageFunc(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))
            present(ac, animated: false)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension CategoryImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getData.CategoriesAllImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryImage", for: indexPath) as? CategoryImageCollectionViewCell else {fatalError() }
        cell.categoryImage.kf.indicatorType = .activity
        cell.isProLabel.text = getData.CategoriesAllImages[indexPath.row].isPro
        cell.categoryImage.kf.setImage(with: URL(string: getData.CategoriesAllImages[indexPath.row].imageURL), placeholder: nil, options: [.transition((.fade(0.7)))], progressBlock: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urlImage = getData.CategoriesAllImages[indexPath.row].imageURL
        AF.request(urlImage).responseImage { response in
            if case .success(let getImage) = response.result {
                if self.isPro == true{
                    self.showImageEditor(selectImage: getImage)
                } else if self.isPro == false{
                    if self.getData.CategoriesAllImages[indexPath.row].isPro == "Pro"{
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentScreenViewController") as! PaymentScreenViewController
                        self.navigationController?.pushViewController(resultViewController, animated: true)
                    }else{
                        let image = self.imageClass.mergeWith(topImage: self.imageClass.topImageLogo!, bottomImage: getImage)
                        self.showImageEditor(selectImage: image)
                    }
                }
            }
        }
    }
}


