//
//  CodeReview.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 28/06/22.
//
/*

import Foundation

var undoIdx = Array(0...100)

func resetArray(){
    for i in undoIdx.indices{
        undoIdx[i] = -1
    }
}

func fetchLogs(tableView: UITableView, daySelected: Date){
    do{
        resetArray()
        logs?.removeAll()
        let request = Log.fetchRequest() as NSFetchRequest<Log>
        
        let dateFrom = calendarManager.calendar.startOfDay(for: daySelected) // eg. 2016-10-10 00:00:00
        let dateTo = calendarManager.calendar.date(byAdding: .day, value: 1, to: dateFrom)

        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time

        // Set predicate as date being today's date
        let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(Log.date))
        
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Log.date), dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        
        request.predicate = datePredicate
        
        self.logs = try context.fetch(request)
        
        DispatchQueue.main.async {
            tableView.reloadData()
        }
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

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //logic UI
    
    for (index, log) in coreDataManager.logs!.enumerated() {
        if(log.time == cell.timeLbl.text && log.medicine_name == cell.medLbl.text){
            
            coreDataManager.undoIdx[indexPath.row] = index
            
            if(log.action == "Skip"){
                //logic UI
            }else{
                //logic UI
            }
            break
        }
    }
}

func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //Take button swipe
    let takeAction = UITableViewRowAction(style: .normal, title: "Konsumsi"){ _, indexPath in
        self.showActionSheet(indexPath: indexPath) /// pass in the indexPath
    }
    //Delete button swipe
    let deleteAction = UITableViewRowAction(style: .destructive, title: "Lewati"){ _, indexPath in
        
        self.coreDataManager.lewati(daySelected: self.daySelected, indexPath: indexPath)

        self.coreDataManager.fetchLogs(tableView: self.tableView, daySelected: self.daySelected)
    }
    
    let untakeAction = UITableViewRowAction(style: .normal, title: "Batalkan"){ [self] _, indexPath in
        
        let logToRemove = self.coreDataManager.logs![self.coreDataManager.undoIdx[indexPath.row]]
        coreDataManager.batalkan(logToRemove: logToRemove)
        self.coreDataManager.undoIdx[indexPath.row] = -1
        
        self.showToastUndo(message: "Kamu telah membatalkan obatmu..", font: .systemFont(ofSize: 12.0))
        self.refresh()
    }
    
    takeAction.backgroundColor = .systemBlue
    
    if (coreDataManager.undoIdx[indexPath.row] >= 0){
        coreDataManager.keTake[indexPath.row] = -1
        return [untakeAction]
    }else{
        coreDataManager.keTake[indexPath.row] = 1
        return [takeAction,deleteAction]
    }
    
}





*/
