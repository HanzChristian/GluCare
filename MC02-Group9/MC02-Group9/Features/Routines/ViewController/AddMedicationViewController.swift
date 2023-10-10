//
//  AddMedicationViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 08/06/22.
//

import UIKit

protocol checkForm {
    func validateForm()
}

class AddMedicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, checkForm, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    let dismissNotfication = UNNotificationDismissActionIdentifier
    
    @IBOutlet var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items = CoreDataManager.coreDataManager.items
    var itemsEdit = CoreDataManager.coreDataManager.medicines
    
    
    let cellTitle = ["Nama Obat", "Waktu Minum", "Jadwal Minum Obat"]
    var jadwal = ["Jadwal 1"]
    let textFieldShadow = ["Misal: Metformin 500 mg", "Pilih Waktu Minum", "", ""]
    let coreDataManager = CoreDataManager.coreDataManager
    
    var waktuminumIdx = -1
    
    var edit = UserDefaults.standard.bool(forKey: "edit")
    
    var first = false
    
    //    let mealTime = ["Waktu Spesifik", "Sebelum Makan", "Setelah Makan", "Bersamaan dengan Makan", "Pilih Waktu Minum"]
    //    let mealTimeDesc = ["Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat",
    //                        "Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat lalu makan",
    //                        "Notifikasi muncul 1 jam sebelum waktu yang ditentukan untuk makan lalu meminum obat",
    //                        "Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat dan makan",
    //                        "Keterangan tentang notifikasi akan muncul setelah memilih waktu minum"]
    var newMealVars = 4
    var currentCell: IndexPath?
    var height = 60.0
    
    var cellMedNameTV: MedNameTextFieldTVC?
    var cellMealTimePicker: MealTimePickerTableViewCell?
    var cellTimePicker = [SchedulePickerTableViewCell]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealVars.mealPickedRow = 4
        tableView.delegate = self
        tableView.dataSource = self
        
        waktuminumIdx = -1
        if(edit == true){
            UserDefaults.standard.set(false, forKey: "edit")
        }
        
        let nibName = UINib(nibName: "MedNameTextFieldTVC", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "medNameTextFieldTVC")
        let nibNamePicker = UINib(nibName: "MealTimePickerTableViewCell", bundle: nil)
        tableView.register(nibNamePicker, forCellReuseIdentifier: "mealTimePickerTableViewCell")
        let nibMedDescPicker = UINib(nibName: "MedDescTableViewCell", bundle: nil)
        tableView.register(nibMedDescPicker, forCellReuseIdentifier: "medDescTableViewCell")
        let nibFrequencyPicker = UINib(nibName: "FrequencyPickerTableViewCell", bundle: nil)
        tableView.register(nibFrequencyPicker, forCellReuseIdentifier: "frequencyPickerTableViewCell")
        let nibSchedulePicker = UINib(nibName: "SchedulePickerTableViewCell", bundle: nil)
        tableView.register(nibSchedulePicker, forCellReuseIdentifier: "schedulePickerTableViewCell")
        let nibAddNewSchedulePicker = UINib(nibName: "AddNewScheduleTableViewCell", bundle: nil)
        tableView.register(nibAddNewSchedulePicker, forCellReuseIdentifier: "addNewScheduleTableViewCell")
        
        view.backgroundColor = .systemGroupedBackground
        //        view.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        //        tableView.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
        
        //make navbar title rounded
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
        validateForm()
        self.hideKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(self.validateForm), name: NSNotification.Name(rawValue: "formValidateNotif"), object: nil)
        
    }
    
    
    //tableviewfunction
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else if (section == 1){
            return 2
        } else {
            if(edit == true && first == false){
                
                
                coreDataManager.fetchMeds()
                let count = coreDataManager.medicines![SelectedIdx.selectedIdx.indexPath.row].time!.count
                if count > 1 && jadwal.count == 1{
                    for i in 1...count-1{
                        jadwal.append("Jadwal \(i+1)")
                    }
                }
                
                first = true
                return jadwal.count+1
            }else{
                return jadwal.count+1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //logic if-else mod2]
        var medicine:Medicine?
        var row: Int?
        
        if(edit == true){
            row = SelectedIdx.selectedIdx.indexPath.row
            medicine = self.coreDataManager.medicines![row!]
        }
        
        if(indexPath.section == 0){
            // SECTION 1
            if (indexPath.row == 0) {
                
                // SECTION 1 ROW 1
                let cell = tableView.dequeueReusableCell(withIdentifier: "medNameTextFieldTVC", for: indexPath) as! MedNameTextFieldTVC
                
                if(edit == false){
                    cell.medNameTextField?.placeholder = "Misal: Metformin 500 mg"
                }else if(edit == true){
                    cell.medNameTextField?.text = medicine!.name
                    title = medicine!.name
                }
                
                
                cellMedNameTV = cell
                validateForm()
                //            cell.backgroundColor = hexStringToUIColor(hex: "#FAFAFA")
                return cell
                
            }
            
        } else if (indexPath.section == 1){
            // SECTION 2
            
            if (indexPath.row == 0){
                // SECTION 2 ROW 1 (Picker View)
                let cell = tableView.dequeueReusableCell(withIdentifier: "mealTimePickerTableViewCell", for: indexPath) as! MealTimePickerTableViewCell
                if(edit == true){
                    if(medicine!.eat_time == 2){
                        cell.mealTimeLabel.text = "Setelah Makan"
                    }
                    else if(medicine!.eat_time == 1){
                        cell.mealTimeLabel.text = "Sebelum Makan"
                    }
                    else if(medicine!.eat_time == 3){
                        cell.mealTimeLabel.text = "Bersamaan dengan Makan"
                    }else{
                        cell.mealTimeLabel.text = "Waktu Spesifik"
                    }
                }else{
                    cell.mealTimeLabel.text = "Pilih Waktu Minum"
                }
                
                if waktuminumIdx != -1{
                    if(waktuminumIdx == 2){
                        cell.mealTimeLabel.text = "Setelah Makan"
                    }
                    else if(waktuminumIdx == 1){
                        cell.mealTimeLabel.text = "Sebelum Makan"
                    }
                    else if(waktuminumIdx == 3){
                        cell.mealTimeLabel.text = "Bersamaan dengan Makan"
                    }else{
                        cell.mealTimeLabel.text = "Waktu Spesifik"
                    }
                }
                
                cell.accessoryType = .disclosureIndicator
                cellMealTimePicker = cell
                validateForm()
                //                cell.mealTimeLabel.textColor = hexStringToUIColor(hex: "#A0A4A8")
                //                cell.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
                // cell.mealTimeTextField?.placeholder = textFieldShadow[indexPath.row]
                return cell
                
            } else if (indexPath.row == 1){
                // SECTION 2 ROW 2 (Keterangan Waktu)
                let cell = tableView.dequeueReusableCell(withIdentifier: "medDescTableViewCell", for: indexPath) as! MedDescTableViewCell
                if(edit == true){
                    if(medicine!.eat_time == 2){
                        cell.mealDescTitle.text = "Setelah Makan"
                        cell.mealDesc.text = "Notifikasi muncul 1 jam sebelum waktu yang ditentukan untuk makan lalu meminum obat"
                        cell.mealImage.image = UIImage(named: "MealDesc2")
                        
                    }
                    else if(medicine!.eat_time == 1){
                        cell.mealDescTitle.text = "Sebelum Makan"
                        cell.mealDesc.text = "Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat lalu makan"
                        cell.mealImage.image = UIImage(named: "MealDesc1")
                    }
                    else if(medicine!.eat_time == 3){
                        cell.mealDescTitle.text = "Bersamaan dengan Makan"
                        cell.mealDesc.text = "Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat dan makan"
                        cell.mealImage.image = UIImage(named: "MealDesc3")
                    }else{
                        cell.mealDescTitle.text = "Waktu Spesifik"
                        cell.mealDesc.text = "Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat"
                        cell.mealImage.image = UIImage(named: "MealDesc0")
                    }
                }else{
                    cell.mealDescTitle.text = "Pilih Waktu Minum"
                    cell.mealDesc.text = "Keterangan tentang notifikasi akan muncul setelah memilih waktu minum"
                }
                
                if waktuminumIdx != -1{
                    if(waktuminumIdx == 2){
                        cell.mealDescTitle.text = "Setelah Makan"
                        cell.mealDesc.text = "Notifikasi muncul 1 jam sebelum waktu yang ditentukan untuk makan lalu meminum obat"
                        cell.mealImage.image = UIImage(named: "MealDesc2")
                        
                    }
                    else if(waktuminumIdx == 1){
                        cell.mealDescTitle.text = "Sebelum Makan"
                        cell.mealDesc.text = "Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat lalu makan"
                        cell.mealImage.image = UIImage(named: "MealDesc1")
                    }
                    else if(waktuminumIdx == 3){
                        cell.mealDescTitle.text = "Bersamaan dengan Makan"
                        cell.mealDesc.text = "Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat dan makan"
                        cell.mealImage.image = UIImage(named: "MealDesc3")
                    }else{
                        cell.mealDescTitle.text = "Waktu Spesifik"
                        cell.mealDesc.text = "Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat"
                        cell.mealImage.image = UIImage(named: "MealDesc0")
                    }
                }
                return cell
            }
            
        } else if (indexPath.section == 2){
            // SECTION 3
            
            if (indexPath.row < jadwal.count){
                // SECTION 3 ROW 1
                let cell = tableView.dequeueReusableCell(withIdentifier: "schedulePickerTableViewCell", for: indexPath) as! SchedulePickerTableViewCell
                cell.mealTimeLabel.text = jadwal[indexPath.row]
                cell.delegate = self // To add super view to cell
                //                cell.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
                
                // buat simpen waktu yg nya
                
                if(edit == true){
                    var idx = 0
                    for med_time in medicine!.time!{
                        if idx == indexPath.row
                        {
                            cell.btnTimePicker.text = (med_time as? Medicine_Time)?.time
                        }
                        idx += 1
                    }
                    //                    cell.btnTimePicker.text = medicine.time[0].time
                }
                
                if(indexPath.row == 0){
                    tableView.setEditing(false, animated: false)
                }else{
                    tableView.setEditing(true, animated: true)
                }
                
                if(indexPath.row == cellTimePicker.count){
                    cellTimePicker.append(cell)
                    print("append")
                }else{
                    cell.btnTimePicker.text = cellTimePicker[indexPath.row].btnTimePicker.text
                    cellTimePicker[indexPath.row] = cell
                    print("masuk \(indexPath.row)")
//                    return cellTimePicker[indexPath.row]
                }
                
                return cell
                
            } else {
                tableView.setEditing(false, animated: false)
                let cell = tableView.dequeueReusableCell(withIdentifier: "addNewScheduleTableViewCell", for: indexPath) as! AddNewScheduleTableViewCell
                //                cell.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
                return cell
            }
            
        }
        return UITableViewCell()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            tableView.beginUpdates()
            if(indexPath.section == 2){
                
                var jadwalIdx = 0
                self.jadwal.remove(at: indexPath.row)
                
                
                for j in jadwal{
                    jadwal[jadwalIdx] = "Jadwal \(jadwalIdx+1)"
                    jadwalIdx += 1
                }
                
                for i in indexPath.row...cellTimePicker.count - 1{
                    print("ini woy \(i) \(cellTimePicker[i].btnTimePicker.text)")
                }
                
                self.cellTimePicker.remove(at: indexPath.row)
                
                
                self.tableView.reloadSections(IndexSet(integer: 2), with: .none)
                self.tableView.deleteRows(at: [indexPath], with: .none)
                
            }
            tableView.endUpdates()
            tableView.reloadData()
            
        }else{
            
            
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // MARK : BUG!!
        //        tableView.deselectRow(at: indexPath, animated: false)
        //        print("didSelectRowAt: ", indexPath)
        //        currentCell = indexPath
        //        updateMealDesc()
        //        let ipMealDebug = [1,0] as IndexPath
        //        if (indexPath == ipMealDebug) {} else {
        //            tableView.reloadRows(at: [indexPath], with: .none)
        //        }
        //        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        
        if let cell = tableView.cellForRow(at: indexPath) as? MealTimePickerTableViewCell {
            if !cell.isFirstResponder {
                _ = cell.becomeFirstResponder()
            }
        } else if tableView.cellForRow(at: indexPath) is AddNewScheduleTableViewCell{
            jadwal.append("Jadwal \(jadwal.count+1)")
            //tableView.reloadSections(IndexSet(integer: 2), with: .none)
            //            UIView.performWithoutAnimation {
            //                let loc = tableView.contentOffset
            //                tableView.reloadSections(IndexSet(integer: 2), with: .none)
            //                tableView.setContentOffset(loc, animated: false)
            //            }
            reloadTableView()
            validateForm()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 1) {
            if (indexPath.row == 1) {
                height = 110
            } else {
                height = 52.0
            }
        } else {
            height = 52.0
        }
        return height
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if (indexPath.section == 2) {
            if(indexPath.row == 0){
                return false
            }else{
                return true
            }
        }
        else{
            return false
        }
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
    
    
    @objc func reloadTableView(){
        do{
            DispatchQueue.main.async { [self] in
                UIView.performWithoutAnimation {
                    let loc = tableView.contentOffset
                    tableView.reloadSections(IndexSet(integer: 2), with: .none)
                    tableView.setContentOffset(loc, animated: false)
                }
            }
        }catch{
            
        }
    }
    
    
    //end of tableview function
    
    
    
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if(edit == false){
            navigationItem.title = "Tambah Jadwal Obat"
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
        
        if(edit == true){
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Perbaharui", style: .plain, target: self, action: #selector(updateItem))
        }else if(edit == false){
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(saveItem))
        }
        
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func validateForm(){
        print("Test")
        
        if let txtTime = cellMealTimePicker?.mealTimeLabel.text, txtTime != "Pilih Waktu Minum"{
            waktuminumIdx = mealVars.mealPickedRow
        }
        
        if let txtMed = cellMedNameTV?.medNameTextField.text, !txtMed.isEmpty,
           let txtTime = cellMealTimePicker?.mealTimeLabel.text, txtTime != "Pilih Waktu Minum"{
            
            var timeSet = Set<String>()
            for cell in cellTimePicker{
                timeSet.insert(cell.btnTimePicker.text!)
            }
            
            if (timeSet.count == cellTimePicker.count) {
                navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
            
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
    
    // Function buat pake hex color
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @objc private func dismissSelf(){
        if(edit == true){
            UserDefaults.standard.set(false, forKey: "edit")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func updateItem(){
        
        CoreDataManager.coreDataManager.fetchMeds()
        CoreDataManager.coreDataManager.fetchMedicine()
        
        items = CoreDataManager.coreDataManager.items
        itemsEdit = CoreDataManager.coreDataManager.medicines
        
        
        if(edit == true){
            
            
            
            var row: Int?
            row = SelectedIdx.selectedIdx.indexPath.row
            
            let medicine = self.itemsEdit![row!]
            var medicine_time = medicine.time?.allObjects as? [Medicine_Time]
            
            var today = Date()
            today = CalendarHelper().addDays(date: today, days: -1)
            
            coreDataManager.removeAllLogMedAfter(med: medicine, date: today)
            
            
            //            let med = medicine.medicine
            
            UserDefaults.standard.set(false, forKey: "edit")
            
            medicine.name = cellMedNameTV!.medNameTextField.text!
            medicine.start_date = Date()
            
            if(mealVars.mealPickedRow == 4){
                medicine.eat_time = medicine.eat_time
            }else{
                medicine.eat_time = Int16(mealVars.mealPickedRow)
            }
            
            
            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeMedToFirestore(id: medicine.id!)
            medicine.id = UUID().uuidString
            
            
            // hapus notif
            let deletedId: [String] = [medicine.id!]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: deletedId)
            
            for time in medicine_time! {
                context.delete(time)
                do{
                    try self.context.save()
                }catch{
                    
                }
            }
            
            for time in cellTimePicker{
                var med_time = Medicine_Time(context: context)
                print("INI MED_TIMENYA \(med_time)")
                
                print("MASUK KE CELLTIMEPICKER")
                med_time.time = time.btnTimePicker.text
                print("INI btnTimePicker \(time.btnTimePicker.text)")
                medicine.addToTime(med_time)
            
                //Get notification info
                notificationCenter.getNotificationSettings { (settings) in
                    if(settings.authorizationStatus == .authorized){
                        DispatchQueue.main.async {
                            //create trigger
                            let time = med_time.time!
                            let hour = time[..<time.index(time.startIndex, offsetBy: 2)]
                            let minutes = time[time.index(time.startIndex, offsetBy: 3)...]
                            let string = ("20 Jun 2022 \(hour):\(minutes):00 +0700")
                            print(string)
                            
                            let dateFormatter = DateFormatter()
                            
                            // Set Date Format
                            dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
                            // Convert String to Date
                            print("\(dateFormatter.date(from: string)!) ubah ke UTC")
                            
                            var newDate = dateFormatter.date(from: string)!
                            var newDate2 = dateFormatter.date(from: string)!
                            
                            //dismiss notif
                            let center = UNUserNotificationCenter.current()
                            center.delegate = self
                            center.requestAuthorization (options: [.alert, .sound]) {(_, _) in
                            }
                            let clearAction = UNNotificationAction(identifier: "ClearNotif", title: "Clear", options: [])
                            let category = UNNotificationCategory(identifier: "ClearNotifCategory", actions: [clearAction], intentIdentifiers: [], options: [])
                            center.setNotificationCategories([category])
                            
                            
                            //content of notification before & after
                            var content = UNMutableNotificationContent()
                            
                            //notif belum didelete
                            
                            if(medicine.eat_time == 0){
                                content.title = "Yuk Minum Obat!"
                                content.body = "Jangan lupa minum obatmu pukul \(med_time.time!)!"
                                content.sound = UNNotificationSound.default
                                newDate.addTimeInterval(-1800)
                            }
                            else if(medicine.eat_time == 1){
                                content.title = "Yuk Minum Obat!"
                                content.body = "Jangan lupa minum obatmu pukul \(med_time.time!)! Jangan lupa makan setelah itu!"
                                content.sound = UNNotificationSound.default
                                newDate.addTimeInterval(-1800)
                            }
                            else if(medicine.eat_time == 2){
                                content.title = "Yuk Minum Obat!"
                                content.body = "Jangan lupa minum obatmu pukul \(med_time.time!)! Yuk makan sekarang!"
                                content.sound = UNNotificationSound.default
                                newDate.addTimeInterval(-3600)
                            }
                            else{
                                content.title = "Yuk Minum Obat!"
                                content.body = "Jangan lupa minum obatmu pukul \(med_time.time!)! Jangan lupa disertakan dengan makan!"
                                content.sound = UNNotificationSound.default
                                newDate.addTimeInterval(-1800)
                            }
                            
                            //content of notification on time
                            var content2 = UNMutableNotificationContent()
                            if(medicine.eat_time == 0){
                                content2.title = "Yuk Minum Obatmu Sekarang!"
                                content2.body = "Jangan lupa untuk minum obatmu sekarang ya!"
                                content2.sound = UNNotificationSound.default
                            }
                            else if(medicine.eat_time == 1){
                                content2.title = "Yuk Minum Obatmu Sekarang!"
                                content2.body = "Jangan lupa untuk minum obatmu sekarang ya!"
                                content2.sound = UNNotificationSound.default
                            }
                            else if(medicine.eat_time == 2){
                                content2.title = "Yuk Minum Obatmu Sekarang!"
                                content2.body = "Jangan lupa untuk minum obatmu sekarang ya!"
                                content2.sound = UNNotificationSound.default
                            }
                            else{
                                content2.title = "Yuk Minum Obatmu Sekarang!"
                                content2.body = "Jangan lupa untuk minum obatmu sekarang ya!"
                                content2.sound = UNNotificationSound.default
                            }
                            
                            
                            dateFormatter.dateFormat = "HH:mm"
                            let newTime = dateFormatter.string(from: newDate)
                            let newHour = newTime[..<newTime.index(newTime.startIndex, offsetBy: 2)]
                            let newMinutes = newTime[newTime.index(newTime.startIndex, offsetBy: 3)...]
                            
                            let newTime2 = dateFormatter.string(from: newDate2)
                            let newHour2 = newTime2[..<newTime2.index(newTime2.startIndex, offsetBy: 2)]
                            let newMinutes2 = newTime2[newTime2.index(newTime2.startIndex, offsetBy: 3)...]
                            
                            var dateComp = DateComponents()
                            var dateComp2 = DateComponents()
                            
                            //String to int
                            dateComp.hour = Int(newHour)
                            dateComp.minute = Int(newMinutes)
                            
                            dateComp2.hour = Int(newHour2)
                            dateComp2.minute = Int(newMinutes2)
                            
                            let uuidString = medicine.id
                            
                            
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
                            let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComp2, repeats: true)
                            let request = UNNotificationRequest(identifier: uuidString!, content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error : Error?) in
                                if let theError = error {
                                    print(theError.localizedDescription)
                                }
                            }
                            let request2 = UNNotificationRequest(identifier: uuidString!, content: content2, trigger: trigger2)
                            UNUserNotificationCenter.current().add(request2) { (error : Error?) in
                                if let theError = error {
                                    print(theError.localizedDescription)
                                }
                            }
                        }
                    }
                }
            }
            
//            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.addNewMedToFirestore(medicine: medicine)
            
            
            // bikin logic updatenya
            
           
            do{
                try self.context.save()
            }catch{
                
            }
//            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.updateMedFirestore(id: medicine.id!, medicine: medicine)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc private func saveItem(){
        // Tambahin logic save disini
        
        /*
         // DEBUG
         print("Data SAVED")
         print(cellMedNameTV!.medNameTextField.text!)
         print(mealVars.mealPickedRow)
         
         for time in cellTimePicker{
         print(time.btnTimePicker.text)
         }
         */
        
        if(edit == true){
            UserDefaults.standard.set(false, forKey: "edit")
        }
        
        // create medicine
        let medicine = Medicine(context: context)
        medicine.name = cellMedNameTV!.medNameTextField.text!
        medicine.eat_time = Int16(mealVars.mealPickedRow)
        medicine.id = UUID().uuidString
        medicine.start_date = Date()
        
        // Add time
        
//        cellTimePicker = cellTimePicker.sorted{ $0.btnTimePicker.text! < $1.btnTimePicker.text!}
//        for picker in cellTimePicker {
//            print("heeee \(picker.btnTimePicker.text!)")
//        }
        
        for time in cellTimePicker{
            let medicine_time = Medicine_Time(context: context)
            medicine_time.time = time.btnTimePicker.text
            print("hiiiii \(time.btnTimePicker.text!)")
            
            medicine.addToTime(medicine_time)
            
            
            //Get notification info
            notificationCenter.getNotificationSettings { (settings) in
                if(settings.authorizationStatus == .authorized){
                    DispatchQueue.main.async {
                        //create trigger
                        let time = medicine_time.time!
                        let hour = time[..<time.index(time.startIndex, offsetBy: 2)]
                        let minutes = time[time.index(time.startIndex, offsetBy: 3)...]
                        let string = ("20 Jun 2022 \(hour):\(minutes):00 +0700")
                        print(string)
                        
                        let dateFormatter = DateFormatter()
                        
                        // Set Date Format
                        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
                        // Convert String to Date
                        print("\(dateFormatter.date(from: string)!) ubah ke UTC")
                        
                        var newDate = dateFormatter.date(from: string)!
                        var newDate2 = dateFormatter.date(from: string)!
                        
                        //dismiss notif
                        let center = UNUserNotificationCenter.current()
                        center.delegate = self
                        center.requestAuthorization (options: [.alert, .sound]) {(_, _) in
                        }
                        let clearAction = UNNotificationAction(identifier: "ClearNotif", title: "Clear", options: [])
                        let category = UNNotificationCategory(identifier: "ClearNotifCategory", actions: [clearAction], intentIdentifiers: [], options: [])
                        center.setNotificationCategories([category])
                        
                        
                        //content of notification before & after
                        var content = UNMutableNotificationContent()
                        
                        //notif belum didelete
                        
                        if(medicine.eat_time == 0){
                            content.title = "Yuk Minum Obat!"
                            content.body = "Jangan lupa minum obatmu pukul \(medicine_time.time!)!"
                            content.sound = UNNotificationSound.default
                            newDate.addTimeInterval(-1800)
                        }
                        else if(medicine.eat_time == 1){
                            content.title = "Yuk Minum Obat!"
                            content.body = "Jangan lupa minum obatmu pukul \(medicine_time.time!)! Jangan lupa makan setelah itu!"
                            content.sound = UNNotificationSound.default
                            newDate.addTimeInterval(-1800)
                        }
                        else if(medicine.eat_time == 2){
                            content.title = "Yuk Minum Obat!"
                            content.body = "Jangan lupa minum obatmu pukul \(medicine_time.time!)! Yuk makan sekarang!"
                            content.sound = UNNotificationSound.default
                            newDate.addTimeInterval(-3600)
                        }
                        else{
                            content.title = "Yuk Minum Obat!"
                            content.body = "Jangan lupa minum obatmu pukul \(medicine_time.time!)! Jangan lupa disertakan dengan makan!"
                            content.sound = UNNotificationSound.default
                            newDate.addTimeInterval(-1800)
                        }
                        
                        //content of notification on time
                        var content2 = UNMutableNotificationContent()
                        if(medicine.eat_time == 0){
                            content2.title = "Yuk Minum Obatmu Sekarang!"
                            content2.body = "Jangan lupa untuk minum obatmu sekarang ya!"
                            content2.sound = UNNotificationSound.default
                        }
                        else if(medicine.eat_time == 1){
                            content2.title = "Yuk Minum Obatmu Sekarang!"
                            content2.body = "Jangan lupa untuk minum obatmu sekarang ya!"
                            content2.sound = UNNotificationSound.default
                        }
                        else if(medicine.eat_time == 2){
                            content2.title = "Yuk Minum Obatmu Sekarang!"
                            content2.body = "Jangan lupa untuk minum obatmu sekarang ya!"
                            content2.sound = UNNotificationSound.default
                        }
                        else{
                            content2.title = "Yuk Minum Obatmu Sekarang!"
                            content2.body = "Jangan lupa untuk minum obatmu sekarang ya!"
                            content2.sound = UNNotificationSound.default
                        }
                        
                        
                        dateFormatter.dateFormat = "HH:mm"
                        let newTime = dateFormatter.string(from: newDate)
                        let newHour = newTime[..<newTime.index(newTime.startIndex, offsetBy: 2)]
                        let newMinutes = newTime[newTime.index(newTime.startIndex, offsetBy: 3)...]
                        
                        let newTime2 = dateFormatter.string(from: newDate2)
                        let newHour2 = newTime2[..<newTime2.index(newTime2.startIndex, offsetBy: 2)]
                        let newMinutes2 = newTime2[newTime2.index(newTime2.startIndex, offsetBy: 3)...]
                        
                        var dateComp = DateComponents()
                        var dateComp2 = DateComponents()
                        
                        //String to int
                        dateComp.hour = Int(newHour)
                        dateComp.minute = Int(newMinutes)
                        
                        dateComp2.hour = Int(newHour2)
                        dateComp2.minute = Int(newMinutes2)
                        
                        let uuidString = medicine.id
                        
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
                        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComp2, repeats: true)
                        let request = UNNotificationRequest(identifier: uuidString!, content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request) { (error : Error?) in
                            if let theError = error {
                                print(theError.localizedDescription)
                            }
                        }
                        let request2 = UNNotificationRequest(identifier: uuidString!, content: content2, trigger: trigger2)
                        UNUserNotificationCenter.current().add(request2) { (error : Error?) in
                            if let theError = error {
                                print(theError.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
        
        //        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
        //           var identifiers: [String] = []
        //           for notification:UNNotificationRequest in notificationRequests {
        //               if notification.identifier == "identifierCancel" {
        //                  identifiers.append(notification.identifier)
        //               }
        //           }
        //           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        //        }
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        MigrateFirestoreToCoreData.migrateFirestoreToCoreData.addNewMedToFirestore(medicine: medicine)
        do{
            try self.context.save()
        }catch{
            
        }
        
        //        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: uuidString)
        
        
        
        self.coreDataManager.fetchMeds()
        self.coreDataManager.fetchLogs(tableView: tableView, daySelected: daySelected)
        self.coreDataManager.checkMedLogAvailable(logs: coreDataManager.logs!, meds: coreDataManager.medicines!, dayselected: daySelected)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UN) -> Void) {
    //        if response.actionIdentifier == "ClearNotif" {
    //            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    //            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    //        }
    //        completion(.dismiss)
    //    }
    
    @objc func dismissView() {
        view.endEditing(true)
    }
    
}

