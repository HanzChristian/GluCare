//
//  AddMedicationViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 08/06/22.
//

import UIKit

class AddMedicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    @IBOutlet var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[Medicine_Time]?
    
    let cellTitle = ["Nama Obat", "Waktu Minum", "Jadwal Minum Obat"]
    var jadwal = ["Jadwal 1"]
    let textFieldShadow = ["Misal: Metformin 250g", "Pilih Waktu Minum", "", ""]
    let mealTime = ["Waktu Spesifik", "Sebelum Makan", "Setelah Makan", "Bersamaan dengan Makan", "Pilih Waktu Minum"]
    let mealTimeDesc = ["Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat",
                        "Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat lalu makan",
                        "Notifikasi muncul 1 jam sebelum waktu yang ditentukan untuk makan lalu meminum obat",
                        "Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat dan makan",
                        "Keterangan tentang notifikasi akan muncul setelah memilih waktu minum"]
    var newMealVars = 4
    var currentCell: IndexPath?
    var height = 60.0
    
    var cellMedNameTV: MedNameTextFieldTVC?
    var cellTimePicker = [SchedulePickerTableViewCell]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealVars.mealPickedRow = 4
        tableView.delegate = self
        tableView.dataSource = self
        
        
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
        self.hideKeyboard()
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
            return jadwal.count+1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //logic if-else mod2]
        if(indexPath.section == 0){
            // SECTION 1
            if (indexPath.row == 0) {
                // SECTION 1 ROW 1
                let cell = tableView.dequeueReusableCell(withIdentifier: "medNameTextFieldTVC", for: indexPath) as! MedNameTextFieldTVC
                cell.medNameTextField?.placeholder = "Misal: Metformin 250g"
                cellMedNameTV = cell
                
                
                //            cell.backgroundColor = hexStringToUIColor(hex: "#FAFAFA")
                return cell
            } else if (indexPath.row == 1){
                let cell = tableView.dequeueReusableCell(withIdentifier: "mealTimePickerTableViewCell", for: indexPath) as! MealTimePickerTableViewCell
                cell.mealTimeLabel.text = cellTitle[indexPath.row]
                //            cell.mealTimeTextField?.placeholder = textFieldShadow[indexPath.row]
                return cell
            } else if (indexPath.row == 2) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "medDescTableViewCell", for: indexPath) as! MedDescTableViewCell
                cell.mealDescTitle.text = mealTime[mealVars.mealPickedRow]
                cell.mealDesc.text = mealTimeDesc[mealVars.mealPickedRow]
                cell.mealImage.image = UIImage(named: "MealDesc\(mealVars.mealPickedRow)")
                return cell
            } else {
                // tableView.reloadData()
                let cell = tableView.dequeueReusableCell(withIdentifier: "frequencyPickerTableViewCell", for: indexPath) as! FrequencyPickerTableViewCell
                cell.lblFrequency.text = cellTitle[indexPath.row]
                return cell
            }
            
            
        } else if (indexPath.section == 1){
            // SECTION 2
            
            if (indexPath.row == 0){
                // SECTION 2 ROW 1 (Picker View)
                let cell = tableView.dequeueReusableCell(withIdentifier: "mealTimePickerTableViewCell", for: indexPath) as! MealTimePickerTableViewCell
                cell.mealTimeLabel.text = "Pilih waktu minum"
                cell.accessoryType = .disclosureIndicator
                //                cell.mealTimeLabel.textColor = hexStringToUIColor(hex: "#A0A4A8")
                //                cell.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
                // cell.mealTimeTextField?.placeholder = textFieldShadow[indexPath.row]
                return cell
                
            } else if (indexPath.row == 1){
                // SECTION 2 ROW 2 (Keterangan Waktu)
                let cell = tableView.dequeueReusableCell(withIdentifier: "medDescTableViewCell", for: indexPath) as! MedDescTableViewCell
                cell.mealDescTitle.text = mealTime[mealVars.mealPickedRow]
                cell.mealDesc.text = mealTimeDesc[mealVars.mealPickedRow]
                cell.mealImage.image = UIImage(named: "MealDesc\(mealVars.mealPickedRow)")
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
                if(indexPath.row == cellTimePicker.count){
                    cellTimePicker.append(cell)
                }else{
                    cellTimePicker[indexPath.row] = cell
                }
                
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addNewScheduleTableViewCell", for: indexPath) as! AddNewScheduleTableViewCell
                //                cell.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
                return cell
            }
            
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print("didSelectRowAt: ", indexPath)
        currentCell = indexPath
        updateMealDesc()
        let ipMealDebug = [1,0] as IndexPath
        if (indexPath == ipMealDebug) {} else {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        
        if let cell = tableView.cellForRow(at: indexPath) as? MealTimePickerTableViewCell {
            if !cell.isFirstResponder {
                _ = cell.becomeFirstResponder()
            }
        } else if tableView.cellForRow(at: indexPath) is AddNewScheduleTableViewCell{
            jadwal.append("Jadwal \(jadwal.count+1)")
            tableView.reloadData()
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
    
    public func updateMealDesc() {
        let ipMealDesc = [1,1] as IndexPath
        tableView.reloadRows(at: [ipMealDesc], with: .none)
    }
    
    
    //end of tableview function
    
    
    
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Tambah Jadwal Obat"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(saveItem))
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
        dismiss(animated: true, completion: nil)
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
        
        
        // create medicine
        let medicine = Medicine(context: context)
        medicine.name = cellMedNameTV!.medNameTextField.text!
        medicine.rules = "After"
        medicine.strength = "500 mg"
        medicine.eat_time = Int16(mealVars.mealPickedRow)
        
        // Add time
        
        for time in cellTimePicker{
            let medicine_time = Medicine_Time(context: context)
            medicine_time.time = time.btnTimePicker.text
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
                        
                        
                        //content of notification
                        var content = UNMutableNotificationContent()
                        if(medicine.eat_time == 0){
                            content.title = "Yuk Minum Obat!"
                            content.body = "Jangan lupa minum obatmu pukul \(medicine_time.time!)!"
                            newDate.addTimeInterval(-1800)
                        }
                        else if(medicine.eat_time == 1){
                            content.title = "Yuk Minum Obat!"
                            content.body = "Jangan lupa minum obatmu pukul \(medicine_time.time!)! Jangan lupa makan setelah itu!"
                            newDate.addTimeInterval(-1800)
                        }
                        else if(medicine.eat_time == 1){
                            content.title = "Yuk Minum Obat!"
                            content.body = "Jangan lupa minum obatmu pukul \(medicine_time.time!)! Yuk makan sekarang!"
                            newDate.addTimeInterval(-3600)
                        }
                        else{
                            content.title = "Yuk Minum Obat!"
                            content.body = "Jangan lupa minum obatmu pukul \(medicine_time.time!)! Jangan lupa disertakan dengan makan!"
                            newDate.addTimeInterval(-1800)
                        }
                        
                        dateFormatter.dateFormat = "HH:mm"
                        let newTime = dateFormatter.string(from: newDate)
                        let newHour = newTime[..<newTime.index(newTime.startIndex, offsetBy: 2)]
                        let newMinutes = newTime[newTime.index(newTime.startIndex, offsetBy: 3)...]
                        
                        var dateComp = DateComponents()
                        
                        //String to int
                        dateComp.hour = Int(newHour)
                        dateComp.minute = Int(newMinutes)
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                        UNUserNotificationCenter.current().add(request) { (error : Error?) in
                                            if let theError = error {
                                                print(theError.localizedDescription)
                                            }
                                        }
                    }
                }
            }
        }
        
        do{
            try self.context.save()
        }catch{
            
        }
        
        
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
    
    @objc func dismissView() {
        view.endEditing(true)
    }
    
}

