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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProjectData()
        projectCollectionView.delegate = self
        projectCollectionView.dataSource = self
        print(getData.coreDataArray.count)
    }
    
    func getProjectData(){
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        let request : NSFetchRequest<UserProject> = UserProject.fetchRequest()
        request.sortDescriptors = sortDescriptors
        
        do{
            getData.coreDataArray = try getData.context.fetch(request)
            projectCollectionView.reloadData()
        }catch{
            print("Error")
        }
    }
    
    func updateContext(projectName:String,projectImage:UIImage){
        
        let fetchUser: NSFetchRequest<UserProject> = UserProject.fetchRequest()
         fetchUser.predicate = NSPredicate(format: "projectName= %@",projectName)

        let results = try? getData.context.fetch(fetchUser)

        if results?.count == 0 {
            // here you are inserting
            do{
                let results = try getData.context.fetch(fetchUser)
                let objectUpdate = results[0]
                let imageAsNSData = projectImage.jpegData(compressionQuality: 1)
                objectUpdate.setValue(projectName, forKey: "projectName")
                objectUpdate.setValue(getData.currentDateTime, forKey: "date")
                objectUpdate.setValue(imageAsNSData, forKey: "image")
                try getData.context.save()
            }
            catch{
                print("Error \(error)")
            }
         } else {
            // here you are updating
            //user = results?.first
             print("NE İŞE YARIYOR BİLMİYORUM")
         }

        

        
        /*let entity = NSEntityDescription.entity(forEntityName: "UserProject", in: getData.context)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        let predicate = NSPredicate(format: "(projectName = %@)", projectName)
        request.predicate = predicate
        
        do {
            let results = try getData.context.fetch(request)
            let objectUpdate = results[0] as! NSManagedObject
            let imageAsNSData = projectImage.jpegData(compressionQuality: 1)
            objectUpdate.setValue(projectName, forKey: "projectName")
            objectUpdate.setValue(getData.currentDateTime, forKey: "date")
            objectUpdate.setValue(imageAsNSData, forKey: "image")
            getData.saveContext()
        }
        catch let error as NSError {
            print("Error \(error)")
        }*/
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
                self!.updateContext(projectName: textField.text!, projectImage: selectImage)
                self?.navigationController?.popViewController(animated: true)
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
        return getData.coreDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as? ProjectCollectionViewCell else {fatalError()}
        cell.projectName.text = getData.coreDataArray[indexPath.row].projectName
        cell.projectImage.image = UIImage(data:getData.coreDataArray[indexPath.row].image!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let picture = getData.coreDataArray[indexPath.row].image
        let getImage = UIImage(data: picture!)
        self.showImageEditor(selectImage: getImage!)
    }
    
}
