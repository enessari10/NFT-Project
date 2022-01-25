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

class BackgroundUIViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet var backgroundCollectionView: UICollectionView!
    var getData = GetDataClass()
    var resultImageEditModel: ZLEditImageModel?
    var imagPickUp : UIImagePickerController!
    var imageV : UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundCollectionView.delegate = self
        backgroundCollectionView.dataSource = self
        getData.getBackgroundsData()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (Timer) in
            self.backgroundCollectionView.reloadData()
        }
        imagPickUp = self.imageAndVideos()

    }
    
    @IBAction func openGalleryButtonPressed(_ sender: UIButton) {
        let ActionSheet = UIAlertController(title: nil, message: "Select Photo", preferredStyle: .actionSheet)

        let cameraPhoto = UIAlertAction(title: "Camera", style: .default, handler: { [self]
                (alert: UIAlertAction) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
//Resim düzenleme
                    imagPickUp.mediaTypes = ["public.image"]
                    self.imagPickUp.sourceType = UIImagePickerController.SourceType.camera;
                    self.present(self.imagPickUp, animated: true, completion: nil)
                }
                else{
                    UIAlertController(title: "iOSDevCenter", message: "No Camera available.", preferredStyle: .alert).show(self, sender: nil);
                }

            })

        let PhotoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: { [self]
                (alert: UIAlertAction) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                    imagPickUp.mediaTypes = ["public.image"]
                    self.imagPickUp.sourceType = UIImagePickerController.SourceType.photoLibrary;
                    self.present(self.imagPickUp, animated: true, completion: nil)
                }

            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction) -> Void in

            })

            ActionSheet.addAction(cameraPhoto)
            ActionSheet.addAction(PhotoLibrary)
            ActionSheet.addAction(cancelAction)


            if UIDevice.current.userInterfaceIdiom == .pad{
                let presentC : UIPopoverPresentationController  = ActionSheet.popoverPresentationController!
                presentC.sourceView = self.view
                presentC.sourceRect = self.view.bounds
                self.present(ActionSheet, animated: true, completion: nil)
            }
            else{
                self.present(ActionSheet, animated: true, completion: nil)
            }

        
    }
    func imageAndVideos()-> UIImagePickerController{
        if(imagPickUp == nil){
            imagPickUp = UIImagePickerController()
            imagPickUp.delegate = self
            imagPickUp.allowsEditing = false
        }
        return imagPickUp
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
      
            ZLImageEditorConfiguration.default()
                .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
                .adjustTools([.brightness, .contrast, .saturation])
        ZLEditImageViewController.showEditImageVC(parentVC: self, image: image!, editModel: self.resultImageEditModel) { [weak self] (resImage, editModel) in
                
            }
       
       
        imagPickUp.dismiss(animated: true, completion: { () -> Void in
            // Dismiss
        })

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagPickUp.dismiss(animated: true, completion: { () -> Void in
            // Dismiss
        })
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
                ZLImageEditorConfiguration.default()
                    .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
                    .adjustTools([.brightness, .contrast, .saturation])
                ZLEditImageViewController.showEditImageVC(parentVC: self, image: getImage, editModel: self.resultImageEditModel) { [weak self] (resImage, editModel) in
                    
                }
            }
        }
    }
    
    
}
