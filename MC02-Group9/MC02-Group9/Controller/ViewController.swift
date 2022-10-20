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
import CloudKit

// var for logic
var daySelected = Date()

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITabBarControllerDelegate, UICloudSharingControllerDelegate{
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        fatalError("Failed to save share \(error)")
    }
    
    func itemTitle(for csc: UICloudSharingController) -> String? {
        return "hello"
    }
    
    
    let notificationCenter = UNUserNotificationCenter.current()
    //    let dismissNotfication = UNNotificationDismissActionIdentifier
    
    let cellSpacingHeight:CGFloat = 10
    
    @IBAction func guideBtn(_ sender: Any) {
        
        guard let barButtonItem = sender as? UIBarButtonItem else {
            fatalError("Not a UI Bar Button item??")
        }
        
        
        let container = coreDataManager.container
        
        let cloudSharingController = UICloudSharingController {
            (controller, completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
            container!.share(self.coreDataManager.items!, to: nil) { objectIDs, share, container, error in
                if let actualShare = share {
                    self.coreDataManager.context.performAndWait {
                        actualShare[CKShare.SystemFieldKey.title] = "Caregiver link"
                    }
                }
                completion(share, container, error)
            }
        }
        cloudSharingController.delegate = self
        
        if let popover = cloudSharingController.popoverPresentationController {
            popover.barButtonItem = barButtonItem
        }
        present(cloudSharingController, animated: true) {}
        
        
//        if(coreDataManager.items!.count > 0){
//            let spotLight = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Guide") as! GuideViewController
//            spotLight.alpha = 0.85
//            present(spotLight, animated: true, completion: nil)
//        }
//        else if(coreDataManager.items!.count == 0){
//            let spotLight = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Guide2") as! GuideViewController2
//            spotLight.alpha = 0.85
//            present(spotLight, animated: true, completion: nil)
//        }
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
    
    @IBOutlet var tableView: UITableView!
    
    
    // dapong
    @IBOutlet weak var collectionView: UICollectionView!
    var totalSquares = [Date]()
    var indexSelected:Int = 0
    var flowLayout = UICollectionViewFlowLayout()
    
    func setNib(){
        let nibTakeMed = UINib(nibName: "TakeMedTableViewCell", bundle: nil)
        tableView.register(nibTakeMed, forCellReuseIdentifier: "cell")
    }

    // Manager
    let calendarManager = CalendarManager.calendarManager
    let coreDataManager = CoreDataManager.coreDataManager
    let streakManager = StreakManager.streakManager
    let networkManager = NetworkManager.shared
    
    // SheetPresentation
    var isSkipped:Bool = false
    //var indexPath:Int = 0
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        collectionView.scrollToItem(at: IndexPath(row: indexSelected, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         let tabBarIndex = tabBarController.selectedIndex
         if tabBarIndex == 0 {
             DispatchQueue.main.async {
                 self.navigationItem.title = "Today"
                 daySelected = Date()
                 
                 self.setWeekView()
                 self.refresh()
                 self.collectionView.scrollToItem(at: IndexPath(row: self.indexSelected, section: 0), at: .centeredHorizontally, animated: false)
             }
         }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tabBarController?.delegate = self

        // dapong
        self.tabBarController?.title = "Jadwal"
        self.navigationItem.title = "Today"
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setCellsView()
        setWeekView()
        
        networkManager.getMedicationListName { (medicineApi, error) -> (Void) in
            if let _ = error {
                print("Error")
                return
            }
            //print(medicineApi![0].name)
            //print(medicineApi!)
        }
        
        
        coreDataManager.resetKeTake()
        streakManager.checkStreakFail()
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
        
        // dapong delete
        //calendar.delegate = self
        //self.calendar.select(Date())
        //self.calendar.scope = .week
        
        coreDataManager.resetArray()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemGroupedBackground
        
        refresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.makeSheet), name: NSNotification.Name(rawValue: "takeMed"), object: nil)
        setNib()
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.sheetHidden), name: NSNotification.Name(rawValue: "sheetOn"), object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.sheetunHidden), name: NSNotification.Name(rawValue: "sheetOff"), object: nil)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.coreDataManager.requestPermission()
            
        }
        
        
        
        
        
    }
    
    func setCellsView()
    {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2)
        
        flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.scrollDirection = .horizontal
        
        flowLayout.collectionView?.bounces = false
        flowLayout.collectionView?.showsHorizontalScrollIndicator = false
        flowLayout.collectionView?.showsVerticalScrollIndicator = false
    }
    
    func setWeekView()
    {
        totalSquares.removeAll()
        
        //var current = CalendarHelper().sundayForDate(date: daySelected)
        var current = CalendarHelper().addDays(date: daySelected, days: -100)
        let nextSunday = CalendarHelper().addDays(date: daySelected, days: 100)
        
        var count = 0;
        
        while (current < nextSunday)
        {
            count+=1
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
            
            if(current == daySelected)
            {
                indexSelected = count
                print(indexSelected)
            }
            
        }
    
        collectionView.reloadData()
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print("dapong \(totalSquares.count)")
        return totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
    
        let date = totalSquares[indexPath.item]
        cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))
        let dayOfWeek:String = CalendarHelper().dayOfWeek(date: date)
        let index = dayOfWeek.index(dayOfWeek.startIndex, offsetBy: 1)
        let mySubstring = dayOfWeek[..<index]
        
        let blue = UIColor(red: 30/255, green: 132/255, blue: 198/255, alpha: 1)
        
        cell.dayOfWeek.text = String(mySubstring)
        cell.dayOfWeek.textColor = blue
        
        cell.dayOfMonth.backgroundColor = UIColor.white
        cell.dayOfMonth.layer.cornerRadius = 34/2
        cell.dayOfMonth.layer.masksToBounds = true
        
        if(date == daySelected)
        {
            cell.backgroundColor = blue
            cell.dayOfWeek.textColor = UIColor.white
            cell.layer.cornerRadius = 25
            
            cell.dayOfMonth.layer.borderWidth = 0
        }
        else
        {
            cell.backgroundColor = UIColor.white
            cell.dayOfMonth.backgroundColor = UIColor.white
            
            if(calendarManager.calendar.isDate(date, inSameDayAs: Date())){
                cell.dayOfMonth.layer.borderWidth = 2
                cell.dayOfMonth.layer.borderColor = CGColor(red: 211/255, green: 63/255, blue: 154/255, alpha: 1)
            }else{
                cell.dayOfMonth.layer.borderWidth = 0
            }

        }
         
         
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        daySelected = totalSquares[indexPath.item]
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        let dateComponents = DateComponents()
        dateFormatter.dateFormat = "MMM d, yyyy"
        /*
         Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
         09/12/2018                        --> MM/dd/yyyy
         09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
         Sep 12, 2:11 PM                   --> MMM d, h:mm a
         September 2018                    --> MMMM yyyy
         Sep 12, 2018                      --> MMM d, yyyy
         Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
         2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
         12.09.18                          --> dd.MM.yy
         10:41:02.112                      --> HH:mm:ss.SSS
         */
        
        // change format date to str
        let strDate = dateFormatter.string(from: daySelected)
        let strToday = dateFormatter.string(from: Date())
        
        // Start Of Day
        let calendar = NSCalendar.current
        
        let from = calendar.startOfDay(for: Date())
        let to = calendar.startOfDay(for: daySelected)
        
        // numberOfDaysBetween
        let numberOfDays = Calendar.current.dateComponents([.day], from: from, to: to).day
        
        if(strDate == strToday)
        {
            self.navigationItem.title = "Today"
        }else if(numberOfDays == -1){
            self.navigationItem.title = "Yesterday"
        }else if(numberOfDays == 1){
            self.navigationItem.title = "Tomorrow"
        }else{
            self.navigationItem.title = strDate
        }
        
        collectionView.reloadData()
        
        coreDataManager.fetchLogs(tableView: tableView, daySelected: daySelected)
    }
    
    override open var shouldAutorotate: Bool
    {
        return false
    }
    
    
    @objc func refresh() {
        
        coreDataManager.resetKeTake()
        coreDataManager.resetArray()
        
        coreDataManager.fetchMedicine(tableView: tableView)
        coreDataManager.fetchLogs(tableView: tableView, daySelected: daySelected)
        
        //sini
        
        if(coreDataManager.items!.count > 0){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidden"), object: nil)
        }
        else if(coreDataManager.items!.count == 0){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhidden"), object: nil)
        }
        
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //dapong
        daySelected = date
        coreDataManager.fetchLogs(tableView: tableView, daySelected: daySelected)
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
        
        alert.addAction(UIAlertAction(title: "Tepat Waktu", style: .default, handler: { action in
            //print("Tepat Waktu tapped")
            
            self.coreDataManager.tepatWaktu(daySelected: daySelected, indexPath: indexPath)
            
            self.showToastTake(message: "Obat berhasil dikonsumsi.", font: .systemFont(ofSize: 12.0))
            
            self.coreDataManager.fetchLogs(tableView: self.tableView, daySelected: daySelected)
            
            self.streakManager.validateNewStreak(daySelected: daySelected, tableView: self.tableView)
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
                    
                    self.coreDataManager.pilihWaktu(daySelected: daySelected, indexPath: indexPath, myDatePicker: myDatePicker)
                    
                    self.showToastTake(message: "Obat berhasil dikonsumsi.", font: .systemFont(ofSize: 12.0))
                    
                    self.coreDataManager.fetchLogs(tableView: self.tableView, daySelected: daySelected)
                    
                    self.streakManager.validateNewStreak(daySelected: daySelected, tableView: self.tableView)
                    
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

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return cellSpacingHeight
       }
    
    @objc func makeSheet(_ notification:Notification){
        let idx = notification.userInfo!["indexPath"] as! Int
        
        print("debug1: idx \(idx)")
        self.isSkipped = false
        
        if (coreDataManager.undoIdx[idx] >= 0){
            coreDataManager.keTake[idx] = -1
            self.isSkipped = true
        }
        
        let storyboard = UIStoryboard(name: "Take Medication", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TakeMedicationViewController") as! TakeMedicationViewController

        let nav =  UINavigationController(rootViewController: vc)
        //        nav.modalPresentationStyle = .overCurrentContext

        if let sheet = nav.presentationController as? UISheetPresentationController{
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false

        }

        //nanti dinyalain lagi tunggu code dari richard
        vc.daySelected = daySelected
        vc.tableView = self.tableView
        vc.indexPath = IndexPath(row: idx,section : 0)

        if(isSkipped){
            //isi dari untake action
            let logToRemove = self.coreDataManager.logs![self.coreDataManager.undoIdx[vc.indexPath!.row]]
            coreDataManager.batalkan(logToRemove: logToRemove)

            self.coreDataManager.fetchLogs(tableView: self.tableView, daySelected: daySelected)

            coreDataManager.fetchStreak()
            if(coreDataManager.streaks!.isEmpty == true){
                return
            }
            // Streak Logic
            let dateFrom = calendarManager.calendar.startOfDay(for: Date())
            let lastDate = coreDataManager.streaks![coreDataManager.streaks!.count - 1].date

            if(lastDate == dateFrom){
                // Streak nya udah ketambah di hari yg sama

                coreDataManager.removeStreak(streakToRemove: coreDataManager.streaks!.last!)
                coreDataManager.fetchStreak()
            }

        }
        
        coreDataManager.medicineSelectedIdx = vc.indexPath!.row
        print("\(vc.indexPath)")
        print(self.isSkipped)
        self.present(nav, animated: true,completion: nil)

    }
    
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        //Take button swipe
//        let takeAction = UITableViewRowAction(style: .normal, title: "Konsumsi"){ _, indexPath in
//
//            self.showActionSheet(indexPath: indexPath) /// pass in the indexPath
//        }
//        //Delete button swipe
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Lewati"){ _, indexPath in
//
//        }
//
//        let untakeAction = UITableViewRowAction(style: .normal, title: "Batalkan"){ [self] _, indexPath in
//
//            let logToRemove = self.coreDataManager.logs![self.coreDataManager.undoIdx[indexPath.row]]
//            coreDataManager.batalkan(logToRemove: logToRemove)
//
//            self.showToastUndo(message: "Kamu telah membatalkan obatmu..", font: .systemFont(ofSize: 12.0))
//
//            self.coreDataManager.fetchLogs(tableView: self.tableView, daySelected: self.daySelected)
//
//            coreDataManager.fetchStreak()
//            if(coreDataManager.streaks!.isEmpty == true){
//                return
//            }
//            // Streak Logic
//            let dateFrom = calendarManager.calendar.startOfDay(for: Date())
//            let lastDate = coreDataManager.streaks![coreDataManager.streaks!.count - 1].date
//
//            if(lastDate == dateFrom){
//                // Streak nya udah ketambah di hari yg sama
//
//                coreDataManager.removeStreak(streakToRemove: coreDataManager.streaks!.last!)
//                coreDataManager.fetchStreak()
//            }
//        }
//
//        takeAction.backgroundColor = .systemBlue
//
//        //kalau diatas hari ini gabole take
//        var dateNow = calendarManager.calendar.startOfDay(for: Date())
//        dateNow.addTimeInterval(86400)
//        let dateCalendar = calendarManager.calendar.startOfDay(for: daySelected)
//
//        if(dateCalendar >= dateNow){
//            return nil
//
//        }
//
//
//        if (coreDataManager.undoIdx[indexPath.row] >= 0){
//            coreDataManager.keTake[indexPath.row] = -1
//            return [untakeAction]
//        }else{
//            coreDataManager.keTake[indexPath.row] = 1
//            return [takeAction,deleteAction]
//        }
//    }
}


extension ViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.coreDataManager.items?.count ?? 0
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TakeMedTableViewCell
        let medicine_time = self.coreDataManager.items![indexPath.row]
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
        cell.tintColor = UIColor.blue
        cell.cellBtn.setImage(UIImage(named:"Take"), for: UIControl.State.normal)
        cell.indexPath = indexPath.row
        
        for (index, log) in coreDataManager.logs!.enumerated() {
            if(log.time == cell.timeLbl.text && log.medicine_name == cell.medLbl.text){
                
                coreDataManager.undoIdx[indexPath.row] = index
                coreDataManager.keTake[indexPath.row] = 1
                
                if(log.action == "Skip"){
                    cell.tintColor = UIColor.red
                    cell.cellBtn.setImage(UIImage(named:"Skipped"), for: UIControl.State.normal)
                    //                        cell.cellImgView.layer.opacity = 0.3
                    //                        cell.indicatorImgView.image = UIImage(named: "Subtract")
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
                    cell.cellBtn.setImage(UIImage(named:"Taken"), for: UIControl.State.normal)
                    
                    cell.freqLbl.text = "Diminum pada \(date)"
                }
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
