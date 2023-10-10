//
//  CoreDataManager+Streak.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 11/11/22.
//

import Foundation
import UIKit
import CoreData


extension CoreDataManager{
    func fetchStreak(){
        do{
            let request = Streak.fetchRequest() as NSFetchRequest<Streak>
            
            self.streaks = try context.fetch(request)
            
        }catch{
            
        }
    }
    
    func resetStreak(){
        // reset streak
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Streak")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newStreak"), object: nil)
    }
    
    func addStreak(){
        // Get today's beginning & end
        let dateFrom = calendarManager.calendar.startOfDay(for: Date())
        let streak = Streak(context: context)
        streak.date = dateFrom
        
        do{
            try self.context.save()
        }catch{
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newStreak"), object: nil)
    }

    func removeStreak(streakToRemove: Streak){
        // streak
        self.context.delete(streakToRemove)
        
        do{
            try self.context.save()
        }catch{
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newStreak"), object: nil)
    }

    func dummyData(){
        // create medicine
        let medicine = Medicine(context: context)
        medicine.name = "Panadol"
        medicine.eat_time = 1
        
        // Add time
        let medicine_time1 = Medicine_Time(context: context)
        medicine_time1.time = "07.00"
        
        let medicine_time2 = Medicine_Time(context: context)
        medicine_time2.time = "12.00"
        
        let medicine_time3 = Medicine_Time(context: context)
        medicine_time3.time = "18.00"
        
        // Add Time to Medicine
        medicine.addToTime(medicine_time1)
        medicine.addToTime(medicine_time2)
        medicine.addToTime(medicine_time3)
        
        do{
            try self.context.save()
        }catch{
            
        }
    }
    
    
}
