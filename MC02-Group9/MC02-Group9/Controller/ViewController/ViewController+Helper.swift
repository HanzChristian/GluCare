//
//  ViewController+Helper.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 16/02/23.
//

import Firebase
import UIKit

extension ViewController{
    //  MARK: - Process
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
    
    func checkAvailableInitLog(daySelected: Date){
        if coreDataManager.fromLogin == true{
            DispatchQueue.main.asyncAfter(deadline: .now() + 5){ [weak self] in
                self!.coreDataManager.fromLogin = false
            }
            return
        }
        
        self.coreDataManager.fetchMeds()
        self.coreDataManager.fetchLogs(tableView: tableView, daySelected: daySelected)
        coreDataManager.checkMedLogAvailable(logs: coreDataManager.logs!, meds: coreDataManager.medicines!, dayselected: daySelected)
    }
    
    func mergeTV(){
        if coreDataManager.logs == nil{
            coreDataManager.logs = [Log]()
        }
        if coreDataManager.bg == nil{
            coreDataManager.bg = [BG]()
        }
        
        self.coreDataManager.fetchBG()
        checkAvailableInitLog(daySelected: daySelected)
        coreDataManager.checkBGLogAvailable(logs: coreDataManager.logs!, bgs: coreDataManager.bg!, daySelected: daySelected)
        jadwalVars.removeAll()
        self.coreDataManager.fetchLogs(tableView: tableView, daySelected: daySelected)
        
        guard let logs = self.coreDataManager.logs else{
            return
        }
        
        var idx = 0
        for log in logs {
            if log.type == 0{
                jadwalVars.append(JadwalVars(type: "MED", idx: idx))
            }else{
                jadwalVars.append(JadwalVars(type: "BG", idx: idx))
            }
            
            idx += 1
        }

        
        coreDataManager.jadwal.accept(jadwalVars)
    }
    
    func getBgIdx(bG:BG) -> Int{
        var i = 0
        for bg in coreDataManager.bg!{
            if(bg == bG){
                return i
            }
            i += 1
        }
        return -1
    }
    
    //  MARK: - Permission
    
    func requestNotificationUserPermission() {
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
    }
    
    // MARK: - View
    
    func setupViews(){
        self.tabBarController?.title = "Jadwal"
        self.navigationItem.title = "Hari ini"

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
        
        // Nav Bar Title Rounded
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
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemGroupedBackground
    }
    
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
        
    func setupCellsView(){
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2)
        
        flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.scrollDirection = .horizontal
        
        flowLayout.collectionView?.bounces = false
        flowLayout.collectionView?.showsHorizontalScrollIndicator = false
        flowLayout.collectionView?.showsVerticalScrollIndicator = false
    }
    
    func setupWeekView(){
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
