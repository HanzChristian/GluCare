//
//  CoreDataManager+BG.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 11/11/22.
//

import Foundation
import CoreData

extension CoreDataManager{
    
    func fetchBG(){
        do{
            let request = BG.fetchRequest() as NSFetchRequest<BG>
            
            let sort = NSSortDescriptor(key: "bg_time", ascending: true)
            request.sortDescriptors = [sort]
            
            self.bg = try context.fetch(request)
            
        }catch{
            
        }
    }
    
    
    func fetchBGTime(daySelected:Date){
        let f = DateFormatter()

        do{
            let request = BG_Time.fetchRequest() as NSFetchRequest<BG_Time>
            
            self.bgTime = try context.fetch(request)
            
        }catch{
            
        }
    }
    
    func fetchDateBG(){
        
        let request = BG.fetchRequest() as NSFetchRequest<BG>
        
        // Get the current calendar with local time zone

        // Get today's beginning & end
        let dateFrom = calendarManager.calendar.startOfDay(for: daySelected) // eg. 2016-10-10 00:00:00
        let dateTo = calendarManager.calendar.date(byAdding: .day, value: 1, to: dateFrom)
        

        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time

        // Set predicate as date being today's date
        let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(BG.bg_start_date))

        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(BG.bg_start_date), dateTo! as NSDate)
                                        
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        
    }
    
}
