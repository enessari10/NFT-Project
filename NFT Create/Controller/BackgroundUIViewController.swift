//
//  BackgroundUIViewController.swift
//  NFT Create
//
//  Created by Enes on 25.01.2022.
//

import UIKit
import Kingfisher
import ZLImageEditor
import Alamofire
import AlamofireImage

class BackgroundUIViewController: UIViewController {
    
    @IBOutlet var backgroundCollectionView: UICollectionView!
    var getData = GetDataClass()
    var resultImageEditModel: ZLEditImageModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundCollectionView.delegate = self
        backgroundCollectionView.dataSource = self
        getData.getBackgroundsData()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (Timer) in
            self.backgroundCollectionView.reloadData()
        }
        
        
    }
    
    @IBAction func openGalleryButtonPressed(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    func showImageEditor(selectImage:UIImage){
        ZLImageEditorConfiguration.default()
            .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
            .adjustTools([.brightness, .contrast, .saturation])
        
        ZLEditImageViewController.showEditImageVC(parentVC: self, image: selectImage, editModel: resultImageEditModel) { [weak self] (resImage, editModel) in
            UIImageWriteToSavedPhotosAlbum(resImage, self, #selector(self!.imageFunc(_:didFinishSavingWithError:contextInfo:)), nil)
            
            
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
extension BackgroundUIViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getData.BackgroundsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "backgorundsCell", for: indexPath) as? BackgorundCollectionViewCell else {fatalError()}
        cell.backgroundImage.kf.indicatorType = .activity
        cell.backgroundImage.kf.setImage(with: URL(string: getData.BackgroundsArray[indexPath.row].imageURL), placeholder: nil, options: [.transition((.fade(0.7)))], progressBlock: nil)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let urlImage = getData.BackgroundsArray[indexPath.row].imageURL
        
        AF.request(urlImage).responseImage { response in
            if case .success(let getImage) = response.result {
                self.showImageEditor(selectImage: getImage)
                
            }
        }
    }
    
}




extension BackgroundUIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            picker.dismiss(animated: true) {
                self.showImageEditor(selectImage: image)
                
            }
        }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            showImageEditor(selectImage: image)
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}


