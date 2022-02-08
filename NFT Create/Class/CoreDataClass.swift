//
//  CoreDataClass.swift
//  NFT Create
//
//  Created by Enes on 7.02.2022.
//

import Foundation
import SwiftyJSON
import CoreData

class CoreDataClass{
    var coreDataArray = [UserProject]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let currentDateTime = Date()

    func saveContext(){
        do{
            try context.save()
            
        }catch{
            print("Save Error")
        }
    }
    
    func getProjectData(){
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        let request : NSFetchRequest<UserProject> = UserProject.fetchRequest()
        request.sortDescriptors = sortDescriptors
        
        do{
            coreDataArray = try context.fetch(request)
        }catch{
            print("Error")
        }
    }
    
    func updateContext(projectName:String,projectImage:UIImage,selectProjectRow: Int){
        let data = coreDataArray[selectProjectRow] // items = [NSManagedObject]()
        let imageAsNSData = projectImage.jpegData(compressionQuality: 1)
        data.setValue(projectName, forKey: "projectName")
        data.setValue(currentDateTime, forKey: "date")
        data.setValue(imageAsNSData, forKey: "image")
        do {
            try context.save()
        } catch {
            print(error)
        }
        
    }
    
}
