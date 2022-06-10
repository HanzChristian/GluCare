//
//  ViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 07/06/22.
//

import UIKit
import FSCalendar
import CoreData

class ViewController: UIViewController, FSCalendarDelegate {
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /*
    var medicines = ["Panadol","Metformin","Mebaral","Metaglip"]
    var freqs = ["1 time","2 times","3 times","4 times"]
    */
    
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var AddMedicationBtn: UIBarButtonItem!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    var items:[Medicine_Time]?
    var logs:[Log]?
    
    var daySelected = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        
        self.calendar.select(Date())
        
        self.calendar.scope = .week
        
        
        title = "Medication Today"
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    
        fetchMedicine()
        fetchLogs()
        
        if(items?.count ?? 0 == 0){
            dummyData()
            fetchMedicine()
        }
    
        
        
    }
    
    func dummyData(){
    
        // create medicine
        let medicine = Medicine(context: context)
        medicine.name = "Panadol"
        medicine.rules = "After"
        medicine.strength = "500 mg"
        
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
    
    func fetchMedicine(){
        do{
            let request = Medicine_Time.fetchRequest() as NSFetchRequest<Medicine_Time>
            
            let sort = NSSortDescriptor(key: "time", ascending: true)
            request.sortDescriptors = [sort]
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }catch{
            
        }
    }
    
    func fetchLogs(){
        do{
            
            logs?.removeAll()
            let request = Log.fetchRequest() as NSFetchRequest<Log>
            
            // Get the current calendar with local time zone
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local

            // Get today's beginning & end
            let dateFrom = calendar.startOfDay(for: daySelected) // eg. 2016-10-10 00:00:00
            let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
            
            /*
            print("FROM DATE >= \(dateFrom)")
            print("TO DATE < \(dateTo)")
             */
            // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time

            // Set predicate as date being today's date
            
            
            let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(Log.date))
            
            let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Log.date), dateTo! as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            
            request.predicate = datePredicate
            
            self.logs = try context.fetch(request)
            
            for log in logs! {
                print("-\(log.date)")
            }
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch{
            
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YYYY"
        let dateSelected = formatter.string(from: date)
        print("\(dateSelected)")
        
        daySelected = date
        fetchLogs()
         
         
        /*
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
         */
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    @IBAction func didTapBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "AddMedication", sender: self)
    }
    
}

extension ViewController:UITableViewDelegate{
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            //Take button swipe
            let takeAction = UITableViewRowAction(style: .normal, title: "Take"){ _, indexPath in
                //Logic belom diisi
                
                //Create Log
                /*
                let date = Date()
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: date)
                let minutes = calendar.component(.minute, from: date)
                */
                 
                let log = Log(context: self.context)
                log.date = Date()
                log.action = "Take"
                log.time = self.items![indexPath.row].time
                log.medicine_name = self.items![indexPath.row].medicine?.name
                
                do{
                    try self.context.save()
                }catch{
                    
                }
                
                self.fetchLogs()
            }
            //Delete button swipe
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Skip"){ _, indexPath in
                //Logic belom diisi
                let log = Log(context: self.context)
                log.date = Date()
                log.action = "Skip"
                log.time = self.items![indexPath.row].time
                log.medicine_name = self.items![indexPath.row].medicine?.name
                
                do{
                    try self.context.save()
                }catch{
                    
                }
                
                self.fetchLogs()
            }

            takeAction.backgroundColor = .systemBlue
            return [takeAction,deleteAction]
        }
}

extension ViewController:UITableViewDataSource{
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            /*
            return medicines.count //berdasarkan variable jumlah cellnya (pake .count)
            */
            
            return self.items?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            /*
            
            cell.medLbl.text = medicines[indexPath.row]
            cell.freqLbl.text = freqs[indexPath.row]
            */
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ViewControllerTVC
            
            let medicine_time = self.items![indexPath.row]
            cell.medLbl.text = medicine_time.medicine?.name
            cell.freqLbl.text = medicine_time.time
            
            cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
            cell.cellImgView.layer.cornerRadius = cell.cellImgView.frame.height / 2
            
            cell.tintColor = UIColor.blue
            
            for log in logs! {
                if(log.time == cell.freqLbl.text && log.medicine_name == cell.medLbl.text){
                    
                    if(log.action == "Skip"){
                        cell.tintColor = UIColor.red
                    }else{
                        cell.tintColor = UIColor.green
                    }
                    
                    // print("\(log.time) = \(medicine_time.time)")
                    break
                }
            }
             
            
            return cell
    }
}

