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
    let picker = UIImagePickerController()

    
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
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            picker.sourceType = UIImagePickerController.SourceType.camera
            present(picker, animated: true, completion: nil)
        }
        else
        {
           //YOU DONT HAVE CAMERA DİYE ALERT BAS
        }
    }
    func openGallary()
    {
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
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
    
    
    
    func showImageEditor(selectImage:UIImage){
        let image = self.mergedImageWith(frontImage: UIImage.init(named: "logo.png"), backgroundImage: selectImage)

        ZLImageEditorConfiguration.default()
            .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
            .adjustTools([.brightness, .contrast, .saturation])
        
        ZLEditImageViewController.showEditImageVC(parentVC: self, image: image, editModel: resultImageEditModel) { [weak self] (resImage, editModel) in
            UIImageWriteToSavedPhotosAlbum(resImage, self, #selector(self!.imageFunc(_:didFinishSavingWithError:contextInfo:)), nil)
            var textField = UITextField()
            let alert = UIAlertController(title: "Add project", message: "", preferredStyle: .alert)
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "Project Name"
                textField = alertTextField
            }
            
            let action = UIAlertAction(title: "Add item", style: .default) { [self] action in
                let newAdd = UserProject(context: self!.getData.context)
                newAdd.projectName = textField.text!
                newAdd.date = self!.getData.currentDateTime
                let imageAsNSData = resImage.jpegData(compressionQuality: 1)
                newAdd.image = imageAsNSData
                self!.getData.coreDataArray.append(newAdd)
                self!.getData.saveContext()
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
            picker.dismiss(animated: true){
                self.showImageEditor(selectImage: image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}


