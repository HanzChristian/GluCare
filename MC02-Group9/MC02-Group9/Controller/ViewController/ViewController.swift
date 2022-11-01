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
import RxSwift
import RxCocoa

// var for logic
var daySelected = Date()

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITabBarControllerDelegate{
    
    let disposeBag = DisposeBag()
    
    let notificationCenter = UNUserNotificationCenter.current()
    //    let dismissNotfication = UNNotificationDismissActionIdentifier
    
    let cellSpacingHeight:CGFloat = 10
    
    let dataType = "BG"
    var jadwalVars = [JadwalVars]()
    let role = UserDefaults.standard.integer(forKey: "role")
    
    let firebaseManager = FirebaseManager.firebaseManager
    
    @IBAction func guideBtn(_ sender: Any) {
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
        coreDataManager.fetchBGTime(daySelected: daySelected)
        coreDataManager.fetchLogs(tableView: tableView, daySelected: daySelected)
        
        print("CORE DATA FETCH BG \(coreDataManager.bg)")
        print("CORE DATA FETCH BT_TIME \(coreDataManager.bgTime)")
        print("CORE DATA LOGS \(coreDataManager.logs)")
        
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
        
        coreDataManager.resetArray()
        
        tableView.delegate = self
//        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemGroupedBackground
        
//        self.coreDataManager.fetchUser()
        firebaseManager.loadFirebase()
        
        mergeTV()
        bindDataToTableView()
        refresh()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        setNib()
        
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
        coreDataManager.fetchBG()
        coreDataManager.fetchBGTime(daySelected: daySelected)
        
        if(coreDataManager.items!.count > 0 || coreDataManager.bg!.count > 0 ){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidden"), object: nil)
        }
        else if(coreDataManager.items!.count == 0 || coreDataManager.bg!.count == 0){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhidden"), object: nil)
        }
        
        mergeTV()
        
        print("rx here \(coreDataManager.jadwal.value)")
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //dapong
        daySelected = date
        coreDataManager.fetchLogs(tableView: tableView, daySelected: daySelected)
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


struct JadwalVars {
    var type:String
    var idx:Int
    
    init(type:String,idx:Int){
        self.type = type
        self.idx = idx
    }
    
}
