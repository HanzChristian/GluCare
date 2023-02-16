//
//  ViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 07/06/22.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

// global date
var daySelected = Date()

class ViewController: UIViewController{
    
    //  MARK: - Properties
    // Manager
    let calendarManager = CalendarManager.calendarManager
    let coreDataManager = CoreDataManager.coreDataManager
    let streakManager = StreakManager.streakManager
    let firebaseManager = FirebaseManager.firebaseManager
    
    let disposeBag = DisposeBag()
    let notificationCenter = UNUserNotificationCenter.current()
    let cellSpacingHeight:CGFloat = 10
    
    var jadwalVars = [JadwalVars]()
    let role: Int = RoleHelper.instance.getRole()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var totalSquares = [Date]()
    var indexSelected:Int = 0
    var flowLayout = UICollectionViewFlowLayout()
    

    
    override open var shouldAutorotate: Bool { return false }
    
    //  MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        collectionView.scrollToItem(at: IndexPath(row: indexSelected, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Core.shared.notNewUser()
        self.tabBarController?.delegate = self

        // dapong
        self.tabBarController?.title = "Jadwal"
        self.navigationItem.title = "Hari ini"
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if(role == 1){
            if #available(iOS 16.0, *) {
                navigationItem.rightBarButtonItem?.isHidden = false
            } else {
                // Fallback on earlier versions
            }
        }else if (role == 2){
            if #available(iOS 16.0, *) {
                navigationItem.rightBarButtonItem?.isHidden = true
            } else {
                // Fallback on earlier versions
            }
        }
        
        setCellsView()
        setWeekView()
        
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
//        firebaseManager.loadFirebase()
        FirebaseManager.firebaseManager.getAccountInfo()
        
        getRole()
        
        mergeTV()
        
        bindDataToTableView()
        
        refresh()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        setNib()
        UserDefaults.standard.set(false, forKey: "edit")
        
    }
    
    
    //  MARK: - Action
    @IBAction func segueBtn(_ sender: Any){
        if(role == 1){
            performSegue(withIdentifier: "toProfile", sender: self)
        }
        else if(role == 2){
            
        }
    
    }
    
    @objc func refresh() {
        coreDataManager.resetKeTake()
        coreDataManager.resetArray()
        coreDataManager.fetchMedicine(tableView: tableView)
        coreDataManager.fetchLogs(tableView: tableView, daySelected: daySelected)
        coreDataManager.fetchBG()
        coreDataManager.fetchBGTime(daySelected: daySelected)
        
        if(coreDataManager.logs!.count > 0 ){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidden"), object: nil)
        }
        else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhidden"), object: nil)
        }
        mergeTV()
    }
    
    
    //  MARK: - Helper
    
    func setNib(){
        let nibTakeMed = UINib(nibName: "TakeMedTableViewCell", bundle: nil)
        tableView.register(nibTakeMed, forCellReuseIdentifier: "cell")
    }
    
    func setup(){
        let emptyVC = EmptySpaceViewController()
        addChild(emptyVC)
        self.view.addSubview(emptyVC.view)

        emptyVC.enableHidden()
    }
    
    func getRole(){
        if let user = Auth.auth().currentUser?.email {
            FirebaseManager.firebaseManager.db.collection("account").whereField("owner", isEqualTo: "\(user)")
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if  let roleId = data["roleId"] as? Int{
                                if(roleId == 0){
                                    RoleHelper.instance.setRole(role: .Patient)
                                }else{
                                    RoleHelper.instance.setRole(role: .Caregiver)
                                }
                            }
                        }
                    }
                }
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
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        daySelected = totalSquares[indexPath.item]
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
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
            self.navigationItem.title = "Hari ini"
        }else if(numberOfDays == -1){
            self.navigationItem.title = "Kemarin"
        }else if(numberOfDays == 1){
            self.navigationItem.title = "Besok"
        }else{
            self.navigationItem.title = strDate
        }
        
        collectionView.reloadData()
        refresh()
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
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
        print("my substring \(dayOfWeek)")
        let index = dayOfWeek.index(dayOfWeek.startIndex, offsetBy: 1)
        let mySubstring = dayOfWeek[..<index]
        
        
        let blue = UIColor(red: 30/255, green: 132/255, blue: 198/255, alpha: 1)
        
        if dayOfWeek == "Monday" {
            cell.dayOfWeek.text = "S"
        }else if dayOfWeek == "Tuesday"{
            cell.dayOfWeek.text = "S"
        }else if dayOfWeek == "Wednesday"{
            cell.dayOfWeek.text = "R"
        }else if dayOfWeek == "Thursday"{
            cell.dayOfWeek.text = "K"
        }else if dayOfWeek == "Friday"{
            cell.dayOfWeek.text = "J"
        }else if dayOfWeek == "Saturday"{
            cell.dayOfWeek.text = "S"
        }else if dayOfWeek == "Sunday"{
            cell.dayOfWeek.text = "M"
        }
        cell.dayOfWeek.textColor = blue
        
        cell.dayOfMonth.backgroundColor = UIColor.white
        cell.dayOfMonth.layer.cornerRadius = 32/2
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
}

// MARK: - UITabBarControllerDelegate

extension ViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         let tabBarIndex = tabBarController.selectedIndex
         if tabBarIndex == 0 {
             DispatchQueue.main.async { [weak self] in
                 self!.navigationItem.title = "Hari ini"
                 daySelected = Date()
                 self!.setWeekView()
                 self!.refresh()
                 self!.collectionView.scrollToItem(at: IndexPath(row: self!.indexSelected, section: 0), at: .centeredHorizontally, animated: false)
             }
         }
    }
}
