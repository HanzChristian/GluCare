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
    
    
    var cellCalendar: BGCalendarTableViewCell?
    var bgFrequency: BGFrequencyTableViewCell?
    
    var cellBgTypeTV: BGTypeTableViewCell?
    var cellBgStartDateTV: BGStartDateTableViewCell?
    var cellBgTimeTV: BGTimeTableViewCell?
    var cellBgSubFrequency: BGSubFrequencyTableViewCell?
    var cellBgSubPicker = [BGSubFrequencyTableViewCell]()
    var cellDateCV : BGCalendarCollectionViewCell?
    
    var calendarOff:Bool = true
    var calendarWiden:Bool = false
    
    let currentTime = Date()
    let dateFormatter = DateFormatter()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let calendarHelper = CalendarHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemGroupedBackground
        tableView.backgroundColor = .systemGroupedBackground
        
        scheduleVars.schedulePickedRow = 3
        typeVars.typePickedRow = 3
        daysVars.dayPickedRow = 31
        
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
                UIView.performWithoutAnimation {
                    self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
                }
            }
        }catch{
            
        }
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveItem(){
        //tunggu semuanya ke save dlu baru diupdate
        
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
            CoreDataManager.coreDataManager.bgLog(bgDate: bg.bg_start_date!, bgTime: bg.bg_time!)
            
            for i in 1...20 { //loop dari hari 1 - 100
                let date = CalendarManager.calendarManager.calendar.date(byAdding: .day, value: Int(bg.bg_each_frequency), to: lastDate!)
                lastDate = date
                CoreDataManager.coreDataManager.bgLog(bgDate: date!, bgTime: bg.bg_time!)
            }
        }
        else if(bg.bg_frequency == 1){
            
            for i in 1...20 { //loop dari hari 1 - 20
                let oneWeekAgo = calendarHelper.addDays(date: lastDate!, days: 7)
                var currentDate = lastDate
                
                while(currentDate! < oneWeekAgo){
                    let currentWeekDay = calendarHelper.calendar.dateComponents([.weekday], from: currentDate!).weekday!
                    
                    for t in bg_times{
                        if(currentWeekDay == (t as! BG_Time).bg_date_item){
                            CoreDataManager.coreDataManager.bgLog(bgDate: currentDate!, bgTime: bg.bg_time!)
                            
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
                    let calendar = Calendar.current
                    
                    var dateComponents: DateComponents? = calendar.dateComponents([.hour, .minute, .second], from: lastDate!)
                    
                    dateComponents?.day = Int(date)
                    
                    let dates: Date? = calendar.date(from: dateComponents!)
                    print("INI START DATE \(bg.bg_start_date) INI DATENYA \(dates)")
                    if(bg.bg_start_date! <= dates!){
                        CoreDataManager.coreDataManager.bgLog(bgDate: dates!, bgTime: bg.bg_time!)
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
        
        navigationItem.title = "Tambah Cek Gula Darah"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(saveItem))
        
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
                cellBgTypeTV!.bgTypeLbl.text = "Pilih Jenis Cek Gula Darah"
                validateFormBG()
                return cellBgTypeTV!
            }
        }
        else if(indexPath.section == 1){
            if(indexPath.row == 0){
                cellBgStartDateTV = tableView.dequeueReusableCell(withIdentifier: "bgStartDateTableViewCell",for:indexPath) as! BGStartDateTableViewCell
                cellBgStartDateTV!.bgStartDateLbl.text = "Tanggal Mulai"
                return cellBgStartDateTV!
            }
            else if(indexPath.row == 1){
                cellBgTimeTV = tableView.dequeueReusableCell(withIdentifier: "bgTimeTableViewCell",for:indexPath) as! BGTimeTableViewCell
                cellBgTimeTV!.bgTimeLbl.text = "Waktu"
                validateFormBG()
                return cellBgTimeTV!
            }
            else if(indexPath.row == 2){
                bgFrequency = tableView.dequeueReusableCell(withIdentifier: "bgFrequencyTableViewCell",for:indexPath) as! BGFrequencyTableViewCell
                bgFrequency!.bgFrequencyLbl.text = "Frekuensi"
                validateFormBG()
                return bgFrequency!
            }
            else if(indexPath.row == 3){
                cellBgSubFrequency = tableView.dequeueReusableCell(withIdentifier: "bgSubFrequencyTableViewCell",for:indexPath) as! BGSubFrequencyTableViewCell
                cellBgSubFrequency!.bgSubFrequencyEveryLbl.text = "Setiap"
                validateFormBG()
                return cellBgSubFrequency!
            }
            else if(indexPath.row == 4){
                let cell = tableView.dequeueReusableCell(withIdentifier: "bgCalendarTableViewCell",for: indexPath) as! BGCalendarTableViewCell
                
                if(calendarWiden){
                    cell.configure(with: CalendarViewModel.calendarViewModel.calendarMonthModel!)
                }else{
                    cell.configure(with: CalendarViewModel.calendarViewModel.calendarModel!)
                }
                
                return cell
            }
        }
        return UITableViewCell()
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
