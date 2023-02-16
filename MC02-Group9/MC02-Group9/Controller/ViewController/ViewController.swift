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
    let calendarManager = CalendarManager.calendarManager
    let coreDataManager = CoreDataManager.coreDataManager
    let firebaseManager = FirebaseManager.firebaseManager
    
    let disposeBag = DisposeBag()
    var jadwalVars = [JadwalVars]()
    let role: Int = RoleHelper.instance.getRole()
    
    let notificationCenter = UNUserNotificationCenter.current()
    let cellSpacingHeight:CGFloat = 10
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        Core.shared.notNewUser()
        
        tableView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        self.tabBarController?.delegate = self
        
        setupViews()
        setupCellsView()
        setupWeekView()
        
        requestNotificationUserPermission()
        
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
//        coreDataManager.resetKeTake()
//        coreDataManager.resetArray()
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
}
