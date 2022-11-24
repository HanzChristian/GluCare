//
//  AddBGViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 11/10/22.
//

import UIKit
protocol checkBGForm {
    func validateFormBG()
}

class AddBGViewController: UIViewController,UITableViewDelegate,checkBGForm, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var height = 49.0
    let cellTitle = ["Jenis", "Jadwal"]
    var bgTypeArr = ["Gula darah puasa", "Gula darah sesaat", "HbA1c"]
    
    
    var cellCalendar: BGCalendarTableViewCell?
    var bgFrequency: BGFrequencyTableViewCell?
    
    var cellBgTypeTV: BGTypeTableViewCell?
    var cellBgStartDateTV: BGStartDateTableViewCell?
    var cellBgTimeTV: BGTimeTableViewCell?
    var cellBgSubFrequency: BGSubFrequencyTableViewCell?
    var cellBgSubPicker = [BGSubFrequencyTableViewCell]()
    var cellDateCV : BGCalendarCollectionViewCell?
    
    var bg_time:[BG_Time]?
    var firstTime = false
    var firstTimeCalendar = false
    var selectedType = -1
    
    var itemsBG = CoreDataManager.coreDataManager.bg
    var itemsBGTime = CoreDataManager.coreDataManager.bgTime
    
    var calendarOff:Bool = true
    var calendarWiden:Bool = false
    var edit = UserDefaults.standard.bool(forKey: "edit")
    
    let currentTime = Date()
    let dateFormatter = DateFormatter()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let coreDataManager = CoreDataManager.coreDataManager
    
    var bg:BG?
    var row: Int?
    
    let calendarHelper = CalendarHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleVars.schedulePickedRow = -1
        typeVars.typePickedRow = -1
        daysVars.dayPickedRow = 31
        
        selectedType = -1
        
        CalendarViewModel.calendarViewModel.resetModel()
        if(edit == true){
            row = SelectedIdx.selectedIdx.indexPath.row
            bg = self.coreDataManager.bg![row!]
            UserDefaults.standard.set(false, forKey: "edit")
            bindCalendarView()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemGroupedBackground
        tableView.backgroundColor = .systemGroupedBackground
      
     
        firstTime = false
        
        cellCalendar?.isHidden = true
        
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
        setNavItem()
        setNib()
        validateFormBG()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableCalendar), name: NSNotification.Name(rawValue: "calendarOn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unableCalendar), name: NSNotification.Name(rawValue: "calendarOff"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.wideCalendar), name: NSNotification.Name(rawValue: "wideCalendar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.narrowCalendar), name: NSNotification.Name(rawValue: "narrowCalendar"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.validateFormBG), name: NSNotification.Name(rawValue: "formValidate"), object: nil)
    }
    
    
    @objc func wideCalendar(){
        calendarWiden = true
        reloadTableView()
    }
    
    @objc func narrowCalendar(){
        calendarWiden = false
        reloadTableView()
    }
    
    @objc func enableCalendar(){
        calendarOff = false
        height = 49.0
        reloadTableView()
    }
    
    @objc func unableCalendar(){
        calendarOff = true
        height = 49.0
        reloadTableView()
    }
    
    @objc func validateFormBG(){
        
        if let txtType = cellBgTypeTV?.bgTypeLbl.text, txtType != "Pilih Jenis Cek Gula Darah"{
            selectedType = typeVars.typePickedRow
        }
           
        if let txtType = cellBgTypeTV?.bgTypeLbl.text, txtType != "Pilih Jenis Cek Gula Darah", let txtDate = cellBgStartDateTV?.bgStartDatePicker.text, !txtDate.isEmpty, let txtTime = cellBgTimeTV?.bgTimePicker.text,!txtTime.isEmpty, let txtFreq = bgFrequency?.bgFrequencyScheduleLbl.text,!txtFreq.isEmpty, let txtEachFreq = cellBgSubFrequency?.bgSubFrequencyDay.text,!txtEachFreq.isEmpty{
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func reloadTableView(){
        do{
            DispatchQueue.main.async { [self] in
                
                //                UIView.performWithoutAnimation {
                //                    let loc = tableView.contentOffset
                //                    tableView.reloadSections(IndexSet(integer: 1), with: .none)
                //                    tableView.setContentOffset(loc, animated: false)
                //                }
//                UIView.performWithoutAnimation {
//                    let loc = tableView.contentOffset
//                    let indexPath = IndexPath.init(row: 4, section: 1)
//                    tableView.reloadRows(at: [indexPath], with: .none)
//                    tableView.setContentOffset(loc, animated: false)
//                }
//                UIView.performWithoutAnimation {
//                    let loc = tableView.contentOffset
//                    tableView.reloadSections(IndexSet(integer: 1), with: .none)
//                    tableView.setContentOffset(loc, animated: false)
//                }
                tableView.reloadData()
            }
        }catch{
            
        }
    }
    
    @objc private func dismissSelf(){
        if(edit == true){
            UserDefaults.standard.set(false, forKey: "edit")
        }
        selectedType = -1
        firstTime = false
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func updateItem(){
        
        CoreDataManager.coreDataManager.fetchBG()
        CoreDataManager.coreDataManager.fetchBGTime(daySelected: daySelected)
        
        itemsBG = CoreDataManager.coreDataManager.bg
        itemsBGTime = CoreDataManager.coreDataManager.bgTime
        
        if(edit == true){
            var row: Int?
            row = SelectedIdx.selectedIdx.indexPath.row
            
            let bg = self.itemsBG![row!]
            
            UserDefaults.standard.set(false, forKey: "edit")
            
            var today = Date()
            today = calendarHelper.addDays(date: today, days: -1)
            coreDataManager.removeAllLogBGAfter(bg: bg, date: today)
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.string(from: currentTime)
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let bgStartDate = cellBgStartDateTV?.bgStartDatePicker.text
            var bgDate = dateFormatter.date(from: bgStartDate!)
            
            bgDate = calendarHelper.calendar.date(byAdding: .hour, value: 7, to: bgDate!)
            
            if(typeVars.typePickedRow == -1){
                bg.bg_type = Int16(bg.bg_type)
                
                print("bg_type = \(bg.bg_type) dan typevars = \(typeVars.typePickedRow)")
            }else{
                bg.bg_type = Int16(typeVars.typePickedRow)
                print("bg_type = \(bg.bg_type) dan typevars = \(typeVars.typePickedRow)")
            }
            
            bg.bg_start_date = bgDate
            bg.bg_time = cellBgTimeTV?.bgTimePicker.text
            
            bg.bg_frequency = Int16(bgFrequency!.pickedFreq)
            bg.bg_each_frequency = Int16(cellBgSubFrequency!.pickedEachFreq)+1
//            bg.bg_id = UUID().uuidString
            
            if(scheduleVars.schedulePickedRow == 1 || scheduleVars.schedulePickedRow == 2){
                let bg_timeDelete = bg.time?.allObjects as? [BG_Time]
                
                for i in bg_timeDelete!{
                    context.delete(i)
                    do{
                        try self.context.save()
                    }catch{
                        
                    }
                }
                
                for i in dateVars.datePickedRow{
                    let bg_time = BG_Time(context: context)
                    bg_time.bg_date_item = i
                    bg.addToTime(bg_time)
                    print("BG TIME \(i)")
                }
            }
            
            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.addNewBGToFirestore(bg: bg)
            
            var lastDate = bg.bg_start_date
            
            print("BG FREQNYA ADALAH \(bg.bg_frequency)")
            
            guard var bg_times = bg.time else{
                return
            }
            
            
            // ISI DISINI
            
            if(bg.bg_frequency == 0){
                CoreDataManager.coreDataManager.bgLog(bgDate: bg.bg_start_date!, bgTime: bg.bg_time!, bg_id: bg.bg_id!,bg_type: bg.bg_type)
                
                for i in 1...5 { //loop dari hari 1 - 100
                    let date = CalendarManager.calendarManager.calendar.date(byAdding: .day, value: Int(bg.bg_each_frequency), to: lastDate!)
                    lastDate = date
                    CoreDataManager.coreDataManager.bgLog(bgDate: date!, bgTime: bg.bg_time!, bg_id: bg.bg_id!, bg_type: bg.bg_type)
                }
            }
            else if(bg.bg_frequency == 1){
                
                for i in 1...3 { //loop dari hari 1 - 20
                    let oneWeekAgo = calendarHelper.addDays(date: lastDate!, days: 7)
                    var currentDate = lastDate
                    
                    while(currentDate! < oneWeekAgo){
                        let currentWeekDay = calendarHelper.calendar.dateComponents([.weekday], from: currentDate!).weekday!
                        
                        for t in bg_times{
                            if(currentWeekDay == (t as! BG_Time).bg_date_item){
                                CoreDataManager.coreDataManager.bgLog(bgDate: currentDate!, bgTime: bg.bg_time!, bg_id: bg.bg_id!, bg_type: bg.bg_type)
                                
                                print(" CURRENT DATE \(currentDate) \(currentWeekDay)")
                                print("Tete \((t as! BG_Time).bg_date_item)")
                                
                            }
                        }
                        print(" CURRENT WEEK \(currentDate) \(currentWeekDay)")
                        
                        currentDate = calendarHelper.addDays(date: currentDate!, days: 1)
                    }
                    
                    lastDate = calendarHelper.addDays(date: lastDate!, days: 7*Int(bg.bg_each_frequency))
                    
                }
                
            }
            else if (bg.bg_frequency == 2){
                for i in 1...20 { //loop dari hari 1 - 100
                    for t in bg_times{
                        let date = (t as! BG_Time).bg_date_item
                        
                        let formatter = DateFormatter()
                        formatter.locale = Locale(identifier: "en_gb")
                        formatter.dateFormat = "dd MMM yyyy"
                        // 29 October 2019 20:15:55 +0200
                        
                        // Create String
                        formatter.dateFormat = "MMM"
                        let month = formatter.string(from: lastDate!)
                        formatter.dateFormat = "yyyy"
                        let year = formatter.string(from: lastDate!)
                        
                        let string = ("\(date+1) \(month) \(year)  07:00:00 +0700")
                        
                        formatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
                        let final = formatter.date(from: string)
                        
                        print("INI BULAN DAPONG \(final)")
                        
                        if final == nil{
                            continue
                        }
                        // pake discord aja suaranya lah
    //                    print("INI START DATE \(bg.bg_start_date) INI DATENYA \(dates)")
                        if(bg.bg_start_date! <= final!){
                            CoreDataManager.coreDataManager.bgLog(bgDate: final!, bgTime: bg.bg_time!, bg_id: bg.bg_id!, bg_type: bg.bg_type)
                        }
                    }
                    lastDate = Calendar.current.date(byAdding: .month, value: Int(bg.bg_each_frequency), to: lastDate!)
                    
                }
            }
            
            do{
                try self.context.save()
            }catch{
                
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)//nanti objectnya di viewcontroller buat fetch datanya Add BG
            
            dismiss(animated: true, completion: nil)
        }
        
    }
    @objc private func saveItem(){
        //tunggu semuanya ke save dlu baru diupdate
        if(edit == true){
            UserDefaults.standard.set(false, forKey: "edit")
        }
        
        let bg = BG(context: context)
        
        let dateFormatter = DateFormatter()
        dateFormatter.string(from: currentTime)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let bgStartDate = cellBgStartDateTV?.bgStartDatePicker.text
        var bgDate = dateFormatter.date(from: bgStartDate!)
        
        bgDate = calendarHelper.calendar.date(byAdding: .hour, value: 7, to: bgDate!)
        
        bg.bg_type = Int16(typeVars.typePickedRow)
        bg.bg_start_date = bgDate
        bg.bg_time = cellBgTimeTV?.bgTimePicker.text
        
        bg.bg_frequency = Int16(bgFrequency!.pickedFreq)
        bg.bg_each_frequency = Int16(cellBgSubFrequency!.pickedEachFreq)+1
        bg.bg_id = UUID().uuidString
        
        
        print("INI BG")
        print("INI BG TYPE = \(bg.bg_type)")
        print("INI BG START DATE = \(bg.bg_start_date)")
        print("INI BG TIME = \(bg.bg_time)")
        print("INI BG FREQ = \(bg.bg_frequency)")
        print("INI BG EACH FREQ = \(bg.bg_each_frequency)")
        
        //save tanggal sesuai kondisinya
        
        //            bg_time.bg_date_item = Int16(days.bgSubFrequencyDay.text)
        
        if(scheduleVars.schedulePickedRow == 1 || scheduleVars.schedulePickedRow == 2){
            for i in dateVars.datePickedRow{
                var bg_time = BG_Time(context: context)
                bg_time.bg_date_item = i
                bg.addToTime(bg_time)
                print("BG TIME \(i)")
                
            }
        }
        
        
        MigrateFirestoreToCoreData.migrateFirestoreToCoreData.addNewBGToFirestore(bg: bg)
        
        var lastDate = bg.bg_start_date
        
        print("BG FREQNYA ADALAH \(bg.bg_frequency)")
        
        guard var bg_times = bg.time else{
            return
        }
        
        
        if(bg.bg_frequency == 0){
            CoreDataManager.coreDataManager.bgLog(bgDate: bg.bg_start_date!, bgTime: bg.bg_time!, bg_id: bg.bg_id!,bg_type: bg.bg_type)
            
            for i in 1...5 { //loop dari hari 1 - 100
                let date = CalendarManager.calendarManager.calendar.date(byAdding: .day, value: Int(bg.bg_each_frequency), to: lastDate!)
                lastDate = date
                CoreDataManager.coreDataManager.bgLog(bgDate: date!, bgTime: bg.bg_time!, bg_id: bg.bg_id!, bg_type: bg.bg_type)
            }
        }
        else if(bg.bg_frequency == 1){
            
            for i in 1...3 { //loop dari hari 1 - 20
                let oneWeekAgo = calendarHelper.addDays(date: lastDate!, days: 7)
                var currentDate = lastDate
                
                while(currentDate! < oneWeekAgo){
                    let currentWeekDay = calendarHelper.calendar.dateComponents([.weekday], from: currentDate!).weekday!
                    
                    for t in bg_times{
                        if(currentWeekDay == (t as! BG_Time).bg_date_item){
                            CoreDataManager.coreDataManager.bgLog(bgDate: currentDate!, bgTime: bg.bg_time!, bg_id: bg.bg_id!, bg_type: bg.bg_type)
                            
                            print(" CURRENT DATE \(currentDate) \(currentWeekDay)")
                            print("Tete \((t as! BG_Time).bg_date_item)")
                            
                        }
                    }
                    print(" CURRENT WEEK \(currentDate) \(currentWeekDay)")
                    
                    currentDate = calendarHelper.addDays(date: currentDate!, days: 1)
                }
                
                lastDate = calendarHelper.addDays(date: lastDate!, days: 7*Int(bg.bg_each_frequency))
                
            }
            
        }
        else if (bg.bg_frequency == 2){
            for i in 1...20 { //loop dari hari 1 - 100
                for t in bg_times{
                    let date = (t as! BG_Time).bg_date_item
                    
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "en_gb")
                    formatter.dateFormat = "dd MMM yyyy"
                    // 29 October 2019 20:15:55 +0200
                    
                    // Create String
                    formatter.dateFormat = "MMM"
                    let month = formatter.string(from: lastDate!)
                    formatter.dateFormat = "yyyy"
                    let year = formatter.string(from: lastDate!)
                    
                    let string = ("\(date+1) \(month) \(year)  07:00:00 +0700")
                    
                    formatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
                    let final = formatter.date(from: string)
                    
                    print("INI BULAN DAPONG \(final)")
                    
                    if final == nil{
                        continue
                    }
                    // pake discord aja suaranya lah
//                    print("INI START DATE \(bg.bg_start_date) INI DATENYA \(dates)")
                    if(bg.bg_start_date! <= final!){
                        CoreDataManager.coreDataManager.bgLog(bgDate: final!, bgTime: bg.bg_time!, bg_id: bg.bg_id!, bg_type: bg.bg_type)
                    }
                }
                lastDate = Calendar.current.date(byAdding: .month, value: Int(bg.bg_each_frequency), to: lastDate!)
                
            }
        }
        
        do{
            try self.context.save()
        }catch{
            
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)//nanti objectnya di viewcontroller buat fetch datanya Add BG
        
        dismiss(animated: true, completion: nil)
        
        //        dismiss(animated: true,completion: nil)
    }
    
    private func setNavItem(){
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if(edit == true){
            navigationItem.title = "Edit Cek Gula Darah"
        }else{
            navigationItem.title = "Tambah Cek Gula Darah"
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
        
        if(edit == true){
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Perbaharui", style: .plain, target: self, action: #selector(updateItem))
        }else if (edit == false){
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(saveItem))
        }
        
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
        
        //tunggu kondisi
        //  navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setNib(){
        let nibBGType = UINib(nibName: "BGTypeTableViewCell", bundle: nil)
        tableView.register(nibBGType, forCellReuseIdentifier: "bgTypeTableViewCell")
        let nibBGStartDate = UINib(nibName: "BGStartDateTableViewCell",bundle: nil)
        tableView.register(nibBGStartDate, forCellReuseIdentifier: "bgStartDateTableViewCell")
        let nibBGTime = UINib(nibName: "BGTimeTableViewCell",bundle: nil)
        tableView.register(nibBGTime, forCellReuseIdentifier: "bgTimeTableViewCell")
        let nibBGFrequency = UINib(nibName: "BGFrequencyTableViewCell",bundle: nil)
        tableView.register(nibBGFrequency, forCellReuseIdentifier: "bgFrequencyTableViewCell")
        let nibBGSubFrequency = UINib(nibName: "BGSubFrequencyTableViewCell",bundle: nil)
        tableView.register(nibBGSubFrequency, forCellReuseIdentifier: "bgSubFrequencyTableViewCell")
        let nibBGCalendar = UINib(nibName: "BGCalendarTableViewCell", bundle: nil)
        tableView.register(nibBGCalendar, forCellReuseIdentifier: "bgCalendarTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                cellBgTypeTV = tableView.dequeueReusableCell(withIdentifier: "bgTypeTableViewCell", for: indexPath) as! BGTypeTableViewCell
                
                if(edit == true){
                    if(bg!.bg_type == 0){
                        cellBgTypeTV!.bgTypeLbl.text = "Gula Darah Puasa"
                        title = "Cek Gula Darah Puasa"
                    }else if(bg!.bg_type == 1){
                        cellBgTypeTV!.bgTypeLbl.text = "Gula Darah Sesaat"
                        title = "Cek Gula Darah Sesaat"
                    }else{
                        cellBgTypeTV!.bgTypeLbl.text = "HbA1c"
                        title = "Cek HbA1c"
                    }
                }else{
                    cellBgTypeTV!.bgTypeLbl.text = "Pilih Jenis Cek Gula Darah"
                }
                
                if(selectedType != -1){
                    if(selectedType == 0){
                        cellBgTypeTV!.bgTypeLbl.text = "Gula Darah Puasa"
                        //title = "Cek Gula Darah Puasa"
                    }else if(selectedType == 1){
                        cellBgTypeTV!.bgTypeLbl.text = "Gula Darah Sesaat"
                        //title = "Cek Gula Darah Sesaat"
                    }else{
                        cellBgTypeTV!.bgTypeLbl.text = "HbA1c"
                        //title = "Cek HbA1c"
                    }
                }
                
                validateFormBG()
                return cellBgTypeTV!
            }
        }
        else if(indexPath.section == 1){
            if(indexPath.row == 0){
                
                cellBgStartDateTV = tableView.dequeueReusableCell(withIdentifier: "bgStartDateTableViewCell",for:indexPath) as! BGStartDateTableViewCell
                
                
                
                if(edit == true){
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MMM yyyy"
                    var bgDate =
                    dateFormatter.string(from: Date())
                    
                    cellBgStartDateTV!.bgStartDatePicker.text = bgDate
                }
                cellBgStartDateTV!.bgStartDateLbl.text = "Tanggal Mulai"
                
                return cellBgStartDateTV!
            }
            else if(indexPath.row == 1){
                cellBgTimeTV = tableView.dequeueReusableCell(withIdentifier: "bgTimeTableViewCell",for:indexPath) as! BGTimeTableViewCell
                
                if(edit == true){
                    cellBgTimeTV!.bgTimePicker.text = bg!.bg_time
                }
                cellBgTimeTV!.bgTimeLbl.text = "Waktu"
                validateFormBG()
                return cellBgTimeTV!
            }
            else if(indexPath.row == 2){
                bgFrequency = tableView.dequeueReusableCell(withIdentifier: "bgFrequencyTableViewCell",for:indexPath) as! BGFrequencyTableViewCell
                bgFrequency!.bgFrequencyLbl.text = "Frekuensi"
                
                if(edit == true && firstTime == false){
                    if(bg!.bg_frequency == 0){
                        if(firstTime == false){
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calendarOff"), object: nil)
                        }
                        bgFrequency!.bgFrequencyScheduleLbl.text = "Hari"
                        bgFrequency!.pickedFreq = 0
                        scheduleVars.schedulePickedRow = 0
                    }
                    else if(bg!.bg_frequency == 1){
                        if(firstTime == false){
                            print("hellow654 ")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calendarOn"), object: nil)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "narrowCalendar"), object: nil)
                        }
                        bgFrequency!.bgFrequencyScheduleLbl.text = "Minggu"
                        bgFrequency!.pickedFreq = 1
                        scheduleVars.schedulePickedRow = 1
                    }else{
                        if(firstTime == false){
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calendarOn"), object: nil)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "wideCalendar"), object: nil)
                        }
                        bgFrequency!.bgFrequencyScheduleLbl.text = "Bulan"
                        bgFrequency!.pickedFreq = 2
                        scheduleVars.schedulePickedRow = 2
                    }
                    
                }
                validateFormBG()
                return bgFrequency!
            }
            else if(indexPath.row == 3){
                cellBgSubFrequency = tableView.dequeueReusableCell(withIdentifier: "bgSubFrequencyTableViewCell",for:indexPath) as! BGSubFrequencyTableViewCell
                if(edit == true && firstTime == false){
                    if(bg!.bg_frequency == 0){
                        cellBgSubFrequency!.bgFrequencyLbl.text = "Hari"
                    }else if(bg!.bg_frequency == 1){
                        cellBgSubFrequency!.bgFrequencyLbl.text = "Minggu"
                    }else{
                        cellBgSubFrequency!.bgFrequencyLbl.text = "Bulan"
                    }
                }
                
                
                
                if edit == true && firstTime == false{
                    cellBgSubFrequency!.bgSubFrequencyEveryLbl.text = "Setiap"
                    cellBgSubFrequency!.bgSubFrequencyDay.text = "\(bg!.bg_each_frequency)"
                }
                firstTime = true
                
                validateFormBG()
                return cellBgSubFrequency!
            }
            else if(indexPath.row == 4){
                let cell = tableView.dequeueReusableCell(withIdentifier: "bgCalendarTableViewCell",for: indexPath) as! BGCalendarTableViewCell
                
                if (calendarWiden){
                    if(firstTimeCalendar == false){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calendarOn"), object: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "wideCalendar"), object: nil)
                    }
                    
                    cell.configure(with: CalendarViewModel.calendarViewModel.calendarMonthModel!)
                }else{
                    if(firstTimeCalendar == false){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calendarOn"), object: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "narrowCalendar"), object: nil)
                    }
                    
                    cell.configure(with: CalendarViewModel.calendarViewModel.calendarModel!)
                }
                
                if cellBgSubFrequency!.bgFrequencyLbl.text == "Hari" && firstTimeCalendar == false{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calendarOff"), object: nil)
                }
                
                firstTimeCalendar = true
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func bindCalendarView(){
        var time = [BG_Time]()
        
        for t in bg!.time!{
            time.append((t as? BG_Time)!)
        }
        
        if(bg?.bg_frequency == 2){
            CalendarViewModel.calendarViewModel.bindDataMonth(dateItem: time)
        }else if(bg?.bg_frequency == 1){
            CalendarViewModel.calendarViewModel.bindDataWeek(dateItem: time)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 1 && indexPath.row == 4 && calendarOff){
            return 0
        }
        else if(indexPath.section == 1 && indexPath.row == 4 && calendarWiden){
            return 230
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let sectionLabel = UILabel(frame: CGRect(x: 18, y: 0, width:
                                                    tableView.bounds.size.width, height: 5))
        
        sectionLabel.font = .rounded(ofSize: 16, weight: .semibold)
        //        sectionLarebel.font = UIFont(name: "Helvetica Neue", size: 16)
        //        sectionLabel.textColor = UIColor.black
        sectionLabel.text = cellTitle[section]
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? BGTypeTableViewCell{
            if !cell.isFirstResponder{
                _ = cell.becomeFirstResponder()
                validateFormBG()
            }
        }
        else if let cell = tableView.cellForRow(at: indexPath) as? BGFrequencyTableViewCell{
            if !cell.isFirstResponder{
                _ = cell.becomeFirstResponder()
                validateFormBG()
            }
            
        }
        else if let cell = tableView.cellForRow(at: indexPath) as? BGSubFrequencyTableViewCell{
            if !cell.isFirstResponder{
                _ = cell.becomeFirstResponder()
                validateFormBG()
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
