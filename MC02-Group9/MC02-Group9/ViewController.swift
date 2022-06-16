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
        formatter.dateFormat = "dd MMM yyyy"
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
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMedicationViewController") as? AddMedicationViewController else {
            print("Error")
            return
        }
        
        let navVC = UINavigationController(rootViewController: vc)
        
        present(navVC, animated: true)
    }
    
}



extension ViewController:UITableViewDelegate{
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 64
        }
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    
        func showActionSheet(indexPath: IndexPath) {
            let alert = UIAlertController(title: "", message: "Kapan kamu mengonsumsi obat ini?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Sekarang", style: .default, handler: { action in
                print("Sekarang tapped")
                
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
            }))
            
            alert.addAction(UIAlertAction(title: "Tepat Waktu", style: .default, handler: { action in
                print("Tepat Waktu tapped")
                
                //change daySelected to String
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_gb")
                formatter.dateFormat = "dd MMM yyyy"
                let tanggal = formatter.string(from: self.daySelected)
                // print(tanggal)
                
                // Create String
                let time = self.items![indexPath.row].time!
                let hour = time[..<time.index(time.startIndex, offsetBy: 2)]
                let minutes = time[time.index(time.startIndex, offsetBy: 3)...]
                let string = ("\(tanggal) \(hour):\(minutes):00 +0700")
                print(string)
                // 29 October 2019 20:15:55 +0200

                
                // Create Date Formatter
                let dateFormatter = DateFormatter()

                // Set Date Format
                dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
                // Convert String to Date
                
                
                let log = Log(context: self.context)
                log.date = dateFormatter.date(from: string) // Oct 29, 2019 at 7:15 PM
                log.action = "Take"
                log.time = self.items![indexPath.row].time
                log.medicine_name = self.items![indexPath.row].medicine?.name
                
                do{
                    try self.context.save()
                }catch{
                    
                }
                self.fetchLogs()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Pilih Waktu", style: .default, handler: { action in
                print("Pilih Waktu tapped")
                
            }))
            
            /*
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                
            }))
             
             */
            alert.addAction(UIAlertAction(title: "Kembali", style: .cancel, handler: { action in
            }))
            
            present(alert, animated: true)
        }
    
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            //Take button swipe
            let takeAction = UITableViewRowAction(style: .normal, title: "Konsumsi"){ _, indexPath in
                //Logic belom diisi
                
                //Create Log
                /*
                let date = Date()
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: date)
                let minutes = calendar.component(.minute, from: date)
                */
                self.showActionSheet(indexPath: indexPath) /// pass in the indexPath
            }
            //Delete button swipe
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Lewati"){ _, indexPath in
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
    
        func showToastSkip(message : String, font: UIFont) {
            let toastLabel = UILabel(frame: CGRect(x: 16, y: 690, width: 358, height: 48))
            toastLabel.backgroundColor = UIColor(hex: "#DE6FB3")
            toastLabel.textColor = UIColor.white
            toastLabel.font = font
            toastLabel.textAlignment = .center
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 8;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 5.0, delay: 0.2, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    
        func showToastTake(message : String, font: UIFont) {
            let toastLabel = UILabel(frame: CGRect(x: 16, y: 690, width: 358, height: 48))
            toastLabel.backgroundColor = UIColor(hex: "#56A3D4")
            toastLabel.textColor = UIColor.white
            toastLabel.font = font
            toastLabel.textAlignment = .center
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 8;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 5.0, delay: 0.2, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
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
            cell.timeLbl.text = medicine_time.time
            
//            cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
//            cell.cellImgView.layer.cornerRadius = cell.cellImgView.frame.height / 2
            
            cell.tintColor = UIColor.blue
            
            for log in logs! {
                if(log.time == cell.freqLbl.text && log.medicine_name == cell.medLbl.text){
                    
                    if(log.action == "Skip"){
                        cell.tintColor = UIColor.red
                        cell.timeLbl.layer.opacity = 0.3
                        cell.freqLbl.layer.opacity = 0.3
                        cell.medLbl.layer.opacity = 0.3
                        cell.cellImgView.layer.opacity = 0.3
                        cell.indicatorImgView.image = UIImage(named: "Subtract")
                        cell.medLbl.text = "Skip \(medicine_time.medicine?.eat_time)"
                        self.showToastSkip(message: "Kamu tidak mengonsumsi obatmu.", font: .systemFont(ofSize: 12.0))
                        
                    }else{
                        cell.tintColor = UIColor.green
                        cell.timeLbl.layer.opacity = 0.3
                        cell.freqLbl.layer.opacity = 0.3
                        cell.medLbl.layer.opacity = 0.3
                        cell.cellImgView.layer.opacity = 0.3
                        cell.indicatorImgView.image = UIImage(named: "Check")
                        cell.medLbl.text = "Take"
                        self.showToastTake(message: "Obat berhasil dikonsumsi.", font: .systemFont(ofSize: 12.0))
                    }
                    // print("\(log.time) = \(medicine_time.time)")
                    break
                }
            }
             
            
            return cell
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                    }
                }
            }
                return nil
        }
}

