//
//  TakeBGViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 06/10/22.
//

import UIKit


class TakeBGViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, checkForm, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var tblViewBG: UITableView!
    
    var cellBGName: BGNameTableViewCell?
    var cellBGResult: BGResultTableViewCell?
//    var indexPath:IndexPath?
    var daySelected: Date?
    var edit = UserDefaults.standard.bool(forKey: "edit")
    let coreDataManager = CoreDataManager.coreDataManager

    
    var log: Log?
    
//    var bg = BG()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setNib()
        
        view.backgroundColor = .systemGroupedBackground
        
        tblViewBG?.delegate = self
        tblViewBG?.dataSource = self
        
        setNav()
        setNib()
        
        validateForm()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.), name: NSNotification.Name(rawValue: "saveSheet"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveSheet), name: NSNotification.Name(rawValue: "saveBG"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.skipSheet), name: NSNotification.Name(rawValue: "skipBG"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.validateForm), name: NSNotification.Name(rawValue: "formValidateNotif"), object: nil)
        
        
    }
    
    @objc func saveSheet(){
        
        let result = (cellBGResult?.BGInputLbl.text)!
        log!.action = "Take"
        log!.bg_check_result = result
        
        do{
            try coreDataManager.context.save()
        }
        catch {
            
        }
        
        MigrateFirestoreToCoreData.migrateFirestoreToCoreData.updateLogFirestore(id: log!.log_id!, newLog: log!)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func skipSheet(){  //lewatbg belom diganti coredatamanagernya
        log!.action = "Skip"
        log!.bg_check_result = "-100"
     
        
        do{
            try coreDataManager.context.save()
        }
        catch {
            
        }
        
        MigrateFirestoreToCoreData.migrateFirestoreToCoreData.updateLogFirestore(id: log!.log_id!, newLog: log!)
        
        print("nDJASND \(log!.action)")
        print("GA MASUK BANG")
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
//    func reloadTableView(){
//        do{
//            DispatchQueue.main.async {
//                self.tblViewBG.reloadData()
//            }
//        }catch{
//
//        }
//    }
    
    
    func setNav(){
        
        let label = UILabel()
        label.text = "Hasil Cek Gula Darah"
        label.font = .rounded(ofSize: 18, weight: .semibold)
        label.largeContentImageInsets
        
        //        label.sizeToFit()
        
        
        let leftItem = UIBarButtonItem(customView: label)
        self.navigationItem.leftBarButtonItem = leftItem
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withTintColor(.gray,renderingMode: .alwaysOriginal).withConfiguration(largeConfig), style: .plain, target: self, action: #selector(dismissSelf))
    }
    
    func setNib(){
        let nibBGName = UINib(nibName: "BGNameTableViewCell", bundle: nil)
        tblViewBG.register(nibBGName, forCellReuseIdentifier: "bgNameTableViewCell")
        let nibBGResult = UINib(nibName: "BGResultTableViewCell", bundle: nil)
        tblViewBG.register(nibBGResult, forCellReuseIdentifier: "bgResultTableViewCell")
        let nibBGBtnSave = UINib(nibName: "BGBtnSaveTableViewCell", bundle: nil)
        tblViewBG.register(nibBGBtnSave, forCellReuseIdentifier: "bgBtnSaveTableViewCell")
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func validateForm(){
        print("Tesssst")
        
        if cellBGResult?.BGInputLbl?.text != "" {
            print("masook gaa nil 1111")
            print(type(of: cellBGResult?.BGInputLbl?.text))
            print(cellBGResult?.BGInputLbl?.text)
            let indexPath = IndexPath(row: 0, section: 2)
            if let cell = tblViewBG.cellForRow(at: indexPath) as? BGBtnSaveTableViewCell {
                cell.BGBtnSave.isEnabled = true
                print("masok gaa nil")
            }
        } else {
            print("masook nil 1111")
            let indexPath = IndexPath(row: 0, section: 2)
            if let cell = tblViewBG.cellForRow(at: indexPath) as? BGBtnSaveTableViewCell {
                cell.BGBtnSave.isEnabled = false
                print("masok nil")
            }
        }
        
        
//        if let txtRes = cellBGResult?.BGInputLbl.text, !txtRes.isEmpty {
//            let indexPath = IndexPath(row: 0, section: 2)
//            let cell = tblViewBG.dequeueReusableCell(withIdentifier: "bgBtnSaveTableViewCell", for:indexPath) as! BGBtnSaveTableViewCell
//            cell.BGBtnSave.isEnabled = true
//
//        }
        
//        if let txtTime = cellMealTimePicker?.mealTimeLabel.text, txtTime != "Pilih Waktu Minum"{
//            waktuminumIdx = mealVars.mealPickedRow
//        }

//        if (cellBGResult?.BGInputLbl.text) != nil {
//            let result = (cellBGResult?.BGInputLbl.text)!
//            navigationItem.rightBarButtonItem?.isEnabled = true
//        }
        
//        let indexPath = IndexPath(row: 0, section: 2)
//        let cell = tblViewBG.dequeueReusableCell(withIdentifier: "bgBtnSaveTableViewCell", for:indexPath) as! BGBtnSaveTableViewCell
//        if (cellBGResult?.BGInputLbl.text) != nil {
//            let result = (cellBGResult?.BGInputLbl.text)!
//            cell.BGBtnSave.isEnabled = true
//            print(type(of: result))
//            print(result, "ressssss")
//        }
            
        
        
//        if let txtMed = cellMedNameTV?.medNameTextField.text, !txtMed.isEmpty,
//           let txtTime = cellMealTimePicker?.mealTimeLabel.text, txtTime != "Pilih Waktu Minum"{
//
//            var timeSet = Set<String>()
//            for cell in cellTimePicker{
//                timeSet.insert(cell.btnTimePicker.text!)
//            }
//
//            if (timeSet.count == cellTimePicker.count) {
//                navigationItem.rightBarButtonItem?.isEnabled = true
//            } else {
//                navigationItem.rightBarButtonItem?.isEnabled = false
//            }
//
//        } else {
//            navigationItem.rightBarButtonItem?.isEnabled = false
//        }
        
    }
    
    @objc func reloadTableView(){
        do{
            DispatchQueue.main.async { [self] in
                UIView.performWithoutAnimation {
                    let loc = tblViewBG.contentOffset
                    tblViewBG.reloadSections(IndexSet(integer: 1), with: .none)
                    tblViewBG.setContentOffset(loc, animated: false)
                }
            }
        }catch{
            
        }
    }
  
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateForm()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = 60.0
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            if(indexPath.row == 0){

                cellBGName = tblViewBG.dequeueReusableCell(withIdentifier: "bgNameTableViewCell", for: indexPath) as! BGNameTableViewCell

                if(log?.eat_time == 0){
                    cellBGName!.BGNameLbl.text = "Gula Darah Puasa"
                }else if(log?.eat_time == 1){
                    cellBGName!.BGNameLbl.text = "Gula Darah Sewaktu"
                }else{
                    cellBGName!.BGNameLbl.text = "HbA1c"
                }

                return cellBGName!
            }
        }
        else if(indexPath.section == 1){
            if(indexPath.row == 0){
                cellBGResult = tblViewBG.dequeueReusableCell(withIdentifier: "bgResultTableViewCell", for:indexPath) as! BGResultTableViewCell
                if(log?.eat_time == 0){
                    cellBGResult!.BGInputLbl?.placeholder = "Misal: 100"
                    cellBGResult!.BGUnitLbl.text = "mg/dL"
                }else if(log?.eat_time == 1){
                    cellBGResult!.BGInputLbl?.placeholder = "Misal: 100"
                    cellBGResult!.BGUnitLbl.text = "mg/dL"
                }else{
                    cellBGResult!.BGInputLbl?.placeholder = "Misal: 7.0"
                    cellBGResult!.BGUnitLbl.text = "%"
                }
                
                validateForm()
                return cellBGResult!
            }
        }
        else if(indexPath.section == 2){
            if(indexPath.row == 0){
                let cell = tblViewBG.dequeueReusableCell(withIdentifier: "bgBtnSaveTableViewCell", for:indexPath) as! BGBtnSaveTableViewCell
//                cell.BGBtnSave.isEnabled = false
                
                validateForm()
//                if(cellBGResult!.BGUnitLbl?.text == nil){
//                    cell.BGBtnSave.isEnabled = false
//                }
                return cell
            }
        }
        validateForm()
        
        return UITableViewCell()
    }
    
   
    
}
