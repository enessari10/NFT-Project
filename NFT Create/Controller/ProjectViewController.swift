//
//  ProjectViewController.swift
//  NFT Create
//
//  Created by Enes on 26.01.2022.
//

import UIKit
import CoreData
import ZLImageEditor

class ProjectViewController: UIViewController {
    
    @IBOutlet var projectCollectionView: UICollectionView!
    var getData = GetDataClass()
    var resultImageEditModel: ZLEditImageModel?
    var coreDataClass = CoreDataClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataClass.getProjectData()
        projectCollectionView.delegate = self
        projectCollectionView.dataSource = self
        
    }
    
    func showImageEditor(selectImage:UIImage, projeNameDefault:String, projectIndexPath:Int){
        
        ZLImageEditorConfiguration.default()
            .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
            .adjustTools([.brightness, .contrast, .saturation])
        
        ZLEditImageViewController.showEditImageVC(parentVC: self, image: selectImage, editModel: resultImageEditModel) { [weak self] (resImage, editModel) in
            UIImageWriteToSavedPhotosAlbum(resImage, self, #selector(self!.imageFunc(_:didFinishSavingWithError:contextInfo:)), nil)
            var textField = UITextField()
            let alert = UIAlertController(title: "Update project name", message: "", preferredStyle: .alert)
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "Project Name"
                alertTextField.text = projeNameDefault
                textField = alertTextField
            }
            
            let action = UIAlertAction(title: "Add item", style: .default) { [self] action in
                self!.coreDataClass.updateContext(projectName: textField.text!, projectImage: resImage,selectProjectRow: projectIndexPath)
                self!.coreDataClass.getProjectData()
                self!.projectCollectionView.reloadData()
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

extension ProjectViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coreDataClass.coreDataArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as? ProjectCollectionViewCell else {fatalError()}
        cell.projectName.text = coreDataClass.coreDataArray[indexPath.row].projectName
        cell.projectImage.image = UIImage(data:coreDataClass.coreDataArray[indexPath.row].image!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let refreshAlert = UIAlertController(title: "Choose", message: "Please the choose item", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Edit Project", style: .default, handler: { (action: UIAlertAction!) in
            let picture = self.coreDataClass.coreDataArray[indexPath.row].image
            let getImage = UIImage(data: picture!)
            let rowNumber : Int = indexPath.row
            self.showImageEditor(selectImage: getImage!,projeNameDefault: self.coreDataClass.coreDataArray[indexPath.row].projectName!,projectIndexPath: rowNumber)
            
        }))
        refreshAlert.addAction(UIAlertAction(title: "Delete Project", style: .cancel, handler: { (action: UIAlertAction!) in
            let fetchRequest = NSFetchRequest<UserProject>(entityName: "UserProject")
            fetchRequest.predicate = NSPredicate(format:"projectName = %@", self.coreDataClass.coreDataArray[indexPath.row].projectName!)
            do {
                let objects = try self.coreDataClass.context.fetch(fetchRequest)
                for object in objects {
                    self.coreDataClass.context.delete(object)
                    self.coreDataClass.coreDataArray.remove(at: indexPath.row)
                }
                try self.coreDataClass.context.save()
            } catch _ {
            }
            self.projectCollectionView.reloadData()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
}




