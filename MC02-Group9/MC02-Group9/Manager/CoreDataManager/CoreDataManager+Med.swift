//
//  CoreDataManager+Med.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 11/11/22.
//

import Foundation
import CoreData
import UIKit


extension CoreDataManager{
    
    
    func fetchMeds(){
        // Med Time
        do{
            let request = Medicine.fetchRequest() as NSFetchRequest<Medicine>
            
            self.medicines = try context.fetch(request)
    
        }catch{
            
        }
    }
    
    func fetchMedicine(tableView: UITableView){
        do{
            let request = Medicine_Time.fetchRequest() as NSFetchRequest<Medicine_Time>
            
            let sort = NSSortDescriptor(key: "time", ascending: true)
            request.sortDescriptors = [sort]
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            
        }catch{
            
        }
    }
    
}
