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
    func mergedImageWith(frontImage:UIImage?, backgroundImage: UIImage?) -> UIImage{

        if (backgroundImage == nil) {
            return frontImage!
        }
        let c = CGSize(width: 400, height: 400);

        UIGraphicsBeginImageContextWithOptions(c, false, 0.0)

        backgroundImage?.draw(in: CGRect.init(x: 0, y: 0, width: 400, height: 400))
        frontImage?.draw(in: CGRect.init(x: 270, y: 240, width: 230, height: 220).insetBy(dx: c.width * 0.2, dy: c.height * 0.2))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
    
    func saveGallery(resImage:UIImage){
        UIImageWriteToSavedPhotosAlbum(resImage, self, #selector(self.imageFunc(_:didFinishSavingWithError:contextInfo:)), nil)
        
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

        ZLImageEditorConfiguration.default()
            .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
            .adjustTools([.brightness, .contrast, .saturation])
        
        AF.request(getData.CategoriesAllImages[indexPath.row].imageURL).responseImage { response in
            if case .success(let getImage) = response.result {
                let image = self.mergedImageWith(frontImage: UIImage.init(named: "logo.png"), backgroundImage: getImage)

                ZLEditImageViewController.showEditImageVC(parentVC: self, image: image, editModel: self.resultImageEditModel) { [weak self] (resImage, editModel) in
                    self!.saveGallery(resImage: resImage)
                }
                
            }
        }
        
    }
    
}
