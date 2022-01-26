//
//  ViewController.swift
//  NFT Create
//
//  Created by Enes on 24.01.2022.
//

import UIKit
import ZLImageEditor
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet var homeTableView: UITableView!
    var getData = GetDataClass()
    var resultImageEditModel: ZLEditImageModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        
    }
    
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "BackgroundUIViewController") as! BackgroundUIViewController
        resultViewController.title = "Backgrounds"
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    @IBAction func projectButtonPressed(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ProjectViewController") as! ProjectViewController
        resultViewController.title = "My Projects"
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    
    func saveGallery(resImage:UIImage){
        UIImageWriteToSavedPhotosAlbum(resImage, self, #selector(self.imageFunc(_:didFinishSavingWithError:contextInfo:)), nil)
        var textField = UITextField()
        let alert = UIAlertController(title: "Add project", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Project Name"
            
            //Copy alertTextField in local variable to use in current block of code
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            let newAdd = UserProject(context: self.getData.context)
            newAdd.projectName = textField.text!
            newAdd.date = self.getData.currentDateTime
            let imageAsNSData = resImage.jpegData(compressionQuality: 1)
            newAdd.image = imageAsNSData
            self.getData.coreDataArray.append(newAdd)
            self.getData.saveContext()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
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




extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell", for: indexPath) as? SliderTableViewCell else { fatalError()}
            return cell
        } else if indexPath.row == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "allCategoriesCell", for: indexPath) as? AllCategoryTableViewCell else { fatalError()}
            cell.delegate = self
            
            return cell
        } else if indexPath.row >= 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryTableViewCell else { fatalError()}
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 242
        }else if indexPath.row == 1{
            return 160
        }else if indexPath.row >= 2{
            return 600
        }else{
            return 165
        }
        
    }
}

extension HomeViewController: ImagesCollectionCellDelegate{
    func didSelectCell(atIndex: UIImage) {
        ZLImageEditorConfiguration.default()
            .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
            .adjustTools([.brightness, .contrast, .saturation])
        
        ZLEditImageViewController.showEditImageVC(parentVC: self, image: atIndex, editModel: resultImageEditModel) { [weak self] (resImage, editModel) in
            self!.saveGallery(resImage: resImage)
        }
        
    }
    
    
}

extension HomeViewController: SelectedCategoryImage{
    
    func didSelectGoToPage(categoryName: String, categoryURL: String) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryImagesViewController") as! CategoryImagesViewController
        
        resultViewController.title = categoryName
        resultViewController.getURL = categoryURL
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    
    
    
}
