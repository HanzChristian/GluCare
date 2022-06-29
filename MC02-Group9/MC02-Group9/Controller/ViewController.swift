//
//  ViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 07/06/22.
//

import UIKit
import FSCalendar
import CoreData
import Gecco

class ViewController: UIViewController, FSCalendarDelegate{
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    @IBAction func guideBtn(_ sender: Any) {
        if(coreDataHelper.items!.count > 0){
            let spotLight = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Guide") as! GuideViewController
            spotLight.alpha = 0.85
            present(spotLight, animated: true, completion: nil)
        }
        else if(coreDataHelper.items!.count == 0){
            let spotLight = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Guide2") as! GuideViewController2
            spotLight.alpha = 0.85
            present(spotLight, animated: true, completion: nil)
        }
    }
    
    func setup(){
        let emptyVC = EmptySpaceViewController()
        addChild(emptyVC)
        self.view.addSubview(emptyVC.view)

        emptyVC.enableHidden()
    }


    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!


    // var for logic
    var daySelected = Date()
    
    // Helper
    let calendarHelper = CalendarHelper.calendarHelper
    let coreDataHelper = CoreDataHelper.coreDataHelper
    let streakHelper = StreakHelper.streakHelper
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        streakHelper.resetKeTake()
        streakHelper.checkStreakFail()
        //Request for user permission
        notificationCenter.requestAuthorization(options: [.alert,.sound]) { permissionGranted, error in
                    if(!permissionGranted)
                    {
                        self.notificationCenter.getNotificationSettings { (settings) in
                            if(settings.authorizationStatus != .authorized){
                                DispatchQueue.main.async {
                                    let ac = UIAlertController(title: "Enable Notifications?", message: "To use reminder feature you must enable notifications in settings", preferredStyle: .alert)
                                    let goToSettings = UIAlertAction(title: "Settings", style: .default){
                                        
                                        (_) in
                                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
                                        else{
                                            return
                                        }
                                        if(UIApplication.shared.canOpenURL(settingsURL)){
                                            UIApplication.shared.open(settingsURL){ (_) in
                                            }
                                        }
                                    }
                                    ac.addAction(goToSettings)
                                    ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(_) in}))
                                    self.present(ac,animated: true)
                                }
                            }
                    }
                }
        }
        
//        Nav Bar Title Rounded
        if let roundedTitleDescriptor = UIFontDescriptor
          .preferredFontDescriptor(withTextStyle: .largeTitle)
          .withDesign(.rounded)?
          .withSymbolicTraits(.traitBold) {
            self.navigationController? // Assumes a navigationController exists on the current view
              .navigationBar
              .largeTitleTextAttributes = [
                .font: UIFont(descriptor: roundedTitleDescriptor, size: 0) // Note that 'size: 0' maintains the system size class
              ]
        }
        
        calendar.delegate = self
        self.calendar.select(Date())
        self.calendar.scope = .week
        
        streakHelper.resetArray()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    
        refresh()
                
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }
    
    @objc func refresh() {
        coreDataHelper.fetchMedicine(tableView: tableView)
        coreDataHelper.fetchLogs(tableView: tableView, daySelected: daySelected)
        
        if(coreDataHelper.items!.count > 0){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidden"), object: nil)
        }
        else if(coreDataHelper.items!.count == 0){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhidden"), object: nil)
        }
                
    }
    
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }


    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        self.streakHelper.resetArray()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let dateSelected = formatter.string(from: date)
        
        //print("\(dateSelected)")
        
        daySelected = date
        coreDataHelper.fetchLogs(tableView: tableView, daySelected: daySelected)        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        //print("\(self.dateFormatter.string(from: calendar.currentPage))")
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
            
            /*
            alert.addAction(UIAlertAction(title: "Sekarang", style: .default, handler: { action in
                print("Sekarang tapped")
                
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
                print("\(dateFormatter.date(from: string)!) ubah ke UTC")
                
                let log = Log(context: self.context)
                log.date = dateFormatter.date(from: string) // Oct 29, 2019 at 7:15 PM
                log.dateTake = Date()
                log.action = "Take"
                log.time = self.items![indexPath.row].time
                log.medicine_name = self.items![indexPath.row].medicine?.name
                
                self.showToastTake(message: "Obat berhasil dikonsumsi.", font: .systemFont(ofSize: 12.0))
                
                do{
                    try self.context.save()
                }catch{
                    
                }
                self.fetchLogs()
                self.resetArray()
                self.validateNewStreak()
            }))
            
             */
            alert.addAction(UIAlertAction(title: "Tepat Waktu", style: .default, handler: { action in
                //print("Tepat Waktu tapped")
                
                self.coreDataHelper.tepatWaktu(daySelected: self.daySelected, indexPath: indexPath)
                
                self.showToastTake(message: "Obat berhasil dikonsumsi.", font: .systemFont(ofSize: 12.0))
                
                self.coreDataHelper.fetchLogs(tableView: self.tableView, daySelected: self.daySelected)
                self.streakHelper.resetArray()
                self.streakHelper.validateNewStreak(daySelected: self.daySelected, tableView: self.tableView)
            }))
            
            alert.addAction(UIAlertAction(title: "Pilih Waktu", style: .default, handler: { action in
                //print("Pilih Waktu tapped")
                // Gas
                
                self.dismiss(animated: true, completion: {
                    
                    
                    let myDatePicker: UIDatePicker = UIDatePicker()
                    myDatePicker.preferredDatePickerStyle = .wheels
                    myDatePicker.timeZone = TimeZone.init(identifier: "ICT")
                    myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
                    let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
                    
                    alertController.view.addSubview(myDatePicker)
                    
                    let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        
                        self.coreDataHelper.pilihWaktu(daySelected: self.daySelected, indexPath: indexPath, myDatePicker: myDatePicker)
                        
                        self.showToastTake(message: "Obat berhasil dikonsumsi.", font: .systemFont(ofSize: 12.0))
                        
                        self.coreDataHelper.fetchLogs(tableView: self.tableView, daySelected: self.daySelected)
                        self.streakHelper.resetArray()
                        self.streakHelper.validateNewStreak(daySelected: self.daySelected, tableView: self.tableView)
                        
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(selectAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true)
                    
                })
                
            }))
        
            /*
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                
            }))
             
             */
            alert.addAction(UIAlertAction(title: "Kembali", style: .cancel, handler: { action in
            }))
            
            self.present(alert, animated: true) {
                    
            }
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
                
                self.coreDataHelper.lewati(daySelected: self.daySelected, indexPath: indexPath)
                
                self.coreDataHelper.resetStreak()
                self.showToastSkip(message: "Kamu tidak mengonsumsi obatmu.", font: .systemFont(ofSize: 12.0))
                self.coreDataHelper.fetchLogs(tableView: self.tableView, daySelected: self.daySelected)
            }
            
            let untakeAction = UITableViewRowAction(style: .normal, title: "Batalkan"){ [self] _, indexPath in
                
                let logToRemove = self.coreDataHelper.logs![self.streakHelper.undoIdx[indexPath.row]]
                coreDataHelper.batalkan(logToRemove: logToRemove)
                self.streakHelper.undoIdx[indexPath.row] = -1
                
                self.showToastUndo(message: "Kamu telah membatalkan obatmu..", font: .systemFont(ofSize: 12.0))
                self.refresh()
            }
            
            takeAction.backgroundColor = .systemBlue
            
            if (streakHelper.undoIdx[indexPath.row] >= 0){
                streakHelper.keTake[indexPath.row] = -1
                return [untakeAction]
            }else{
                streakHelper.keTake[indexPath.row] = 1
                return [takeAction,deleteAction]
            }
            
        }
    
    
    
}


extension ViewController:UITableViewDataSource{
       
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            /*
            return medicines.count //berdasarkan variable jumlah cellnya (pake .count)
            */
            
            return self.coreDataHelper.items?.count ?? 0
        }
    
        func showToastSkip(message : String, font: UIFont) {
            let toastLabel = UILabel(frame: CGRect(x: 16, y: 690, width: 358, height: 48))

            toastLabel.backgroundColor = UIColor(rgb: 0xDE6FB3)
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

            toastLabel.backgroundColor = UIColor(rgb: 0x56A3D4)
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
        
        func showToastUndo(message : String, font: UIFont) {
            let toastLabel = UILabel(frame: CGRect(x: 16, y: 690, width: 358, height: 48))
            toastLabel.backgroundColor = .gray
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
            
            let medicine_time = self.coreDataHelper.items![indexPath.row]
            cell.medLbl.text = medicine_time.medicine?.name
            if(medicine_time.medicine?.eat_time == 2){
                cell.freqLbl.text = "Sesudah makan"
            }
            else if(medicine_time.medicine?.eat_time == 1){
                cell.freqLbl.text = "Sebelum makan"
            }
            else if(medicine_time.medicine?.eat_time == 3){
                cell.freqLbl.text = "Bersamaan dengan makan"
            }else{
                cell.freqLbl.text = "Waktu Spesifik"
            }
            cell.timeLbl.text = medicine_time.time
            cell.timeLbl.layer.opacity = 1
            cell.freqLbl.layer.opacity = 1
            cell.medLbl.layer.opacity = 1
            cell.cellImgView.layer.opacity = 1
            cell.indicatorImgView.image = nil
            
           
//            dateFormatter.locale = Locale(identifier: "en_gb")
//            dateFormatter.dateFormat = "dd MMM yyyy"
//            let tanggal = dateFormatter.string(from: self.daySelected)
//            // print(tanggal)
//
//            // Create String
            let time = self.coreDataHelper.items![indexPath.row].time!
            let hour = time[..<time.index(time.startIndex, offsetBy: 2)]
            let minutes = time[time.index(time.startIndex, offsetBy: 3)...]
            let string = ("20 Jun 2022 \(hour):\(minutes):00 +0700")
            
            let startMorning = ("20 Jun 2022 06:00:00 +0700")
            let endMorning = ("20 Jun 2022 11:59:00 +0700")
            
            let startEvening = ("20 Jun 2022 12:00:00 +0700")
            let endEvening = ("20 Jun 2022 17:59:00 +0700")
            
//            let startNight = ("20 Jun 2022 18:00:00 +0700")
//            let endNight = ("21 Jun 2022 05:59:00 +0700")
            
            
            
            let dateFormatter = DateFormatter()

            // Set Date Format
            dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
            // Convert String to Date
            //print("\(dateFormatter.date(from: string)!) ubah ke UTC")
            
            let newDate = dateFormatter.date(from: string)!
            
            let startMorningDate = dateFormatter.date(from: startMorning)!
            let endMorningDate = dateFormatter.date(from: endMorning)!
            let startEveningDate = dateFormatter.date(from: startEvening)!
            let endEveningDate = dateFormatter.date(from: endEvening)!
//            let startNightDate = dateFormatter.date(from: startNight)!
//            let endNightDate = dateFormatter.date(from: endNight)!
            
            if(newDate >= startMorningDate && newDate <= endMorningDate){
                cell.cellImgView.image = UIImage(named: "Pagi")
            }
            else if(newDate >= startEveningDate && newDate <= endEveningDate){
                cell.cellImgView.image = UIImage(named: "Siang")
            }
            else{
                cell.cellImgView.image = UIImage(named: "Malam")
            }
            
//            cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
//            cell.cellImgView.layer.cornerRadius = cell.cellImgView.frame.height / 2
            
            cell.tintColor = UIColor.blue
            

            for (index, log) in coreDataHelper.logs!.enumerated() {
                if(log.time == cell.timeLbl.text && log.medicine_name == cell.medLbl.text){
                    
                    streakHelper.undoIdx[indexPath.row] = index
                    streakHelper.keTake[indexPath.row] = 1
                    
                    if(log.action == "Skip"){
                        cell.tintColor = UIColor.red
                        cell.timeLbl.layer.opacity = 0.3
                        cell.freqLbl.layer.opacity = 0.3
                        cell.medLbl.layer.opacity = 0.3
                        cell.cellImgView.layer.opacity = 0.3
                        cell.indicatorImgView.image = UIImage(named: "Subtract")
                        //cell.medLbl.text = "Skip \(medicine_time.medicine?.eat_time)"
                    }else{

                        // Create Date Formatter
                        let dateFormatter = DateFormatter()

                        // Set Date/Time Style
                        dateFormatter.dateStyle = .long
                        dateFormatter.timeStyle = .short
                        dateFormatter.dateFormat = "HH:mm"

                        // Convert Date to String
                        var date = dateFormatter.string(from: log.dateTake!)
                        
                        cell.tintColor = UIColor.green
                        cell.timeLbl.layer.opacity = 0.3
                        cell.freqLbl.layer.opacity = 0.3
                        cell.medLbl.layer.opacity = 0.3
                        cell.cellImgView.layer.opacity = 0.3
                        cell.indicatorImgView.image = UIImage(named: "Check")
                        //cell.medLbl.text = "Take"

                        cell.freqLbl.text = "Diminum pada \(date)"
                    }
                    // print("\(log.time) = \(medicine_time.time)")
                    break
                }
            }
             
            
            return cell
    }
}

extension UIColor {

   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
