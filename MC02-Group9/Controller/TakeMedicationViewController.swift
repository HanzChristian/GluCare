//
//  TakeMedicationViewController.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 04/07/22.
//

import UIKit

class TakeMedicationViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var daySelected: Date?
    var height = 60.0
    
    var indexPath:IndexPath?
    var tableView: UITableView?
    
    
    let coreDataManager = CoreDataManager.coreDataManager
    let streakManager = StreakManager.streakManager
    
    var cellTakeMed: TakeMedTimeTableViewCell?
    var switchMode: OnTimeTableViewCell?
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setNib()
        view.backgroundColor = .systemGroupedBackground
        
        tblView?.delegate = self
        tblView?.dataSource = self
        
        setNav()
        setNib()
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableHidden), name: NSNotification.Name(rawValue: "switchOn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unableHidden), name: NSNotification.Name(rawValue: "switchOff"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveSheet), name: NSNotification.Name(rawValue: "save"), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.gettime), name: NSNotification.Name(rawValue: "switchOff"), object: nil)
    }
    
    func reloadTableView(){
        do{
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }catch{
            
        }
    }
    
    @objc func enableHidden(){
        self.cellTakeMed!.isHidden = true
        reloadTableView()
    }
    
    @objc func unableHidden(){
        self.cellTakeMed!.isHidden = false
        reloadTableView()
    }
    
    @objc func saveSheet(){

        if(switchMode!.switchOnTime.isOn == true){
            //Tepat Waktu
            self.coreDataManager.tepatWaktu(daySelected: daySelected!, indexPath: indexPath!)
        }
        else{
            //Pilih Waktu
            self.coreDataManager.pilihWaktu(daySelected: daySelected!, indexPath: indexPath!, myDatePicker: cellTakeMed!.timePicker)
        }

        self.showToastTake(message: "Obat berhasil dikonsumsi.", font: .systemFont(ofSize: 12.0))

        self.coreDataManager.fetchLogs(tableView: self.tableView!, daySelected: daySelected!)

        self.streakManager.validateNewStreak(daySelected: daySelected!, tableView: self.tableView!)
        
        self.dismiss(animated: true, completion: nil)
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

    
    func setNib(){
        let nibMedName = UINib(nibName: "MedNameTableViewCell", bundle: nil)
        tblView.register(nibMedName, forCellReuseIdentifier: "medNameTableViewCell")
        let nibOnTime = UINib(nibName: "OnTimeTableViewCell", bundle: nil)
        tblView.register(nibOnTime, forCellReuseIdentifier: "onTimeTableViewCell")
        let nibTakeMed = UINib(nibName: "TakeMedTimeTableViewCell", bundle: nil)
        tblView.register(nibTakeMed, forCellReuseIdentifier: "takeMedTimeTableViewCell")
        let nibBtnSave = UINib(nibName: "BtnSaveTableViewCell", bundle: nil)
        tblView.register(nibBtnSave, forCellReuseIdentifier: "btnSaveTableViewCell")
        
    }
    
    func setNav(){
        
        let label = UILabel()
        label.text = "Masukkan Waktu Minum Obat"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        //        label.sizeToFit()
        
        
        let leftItem = UIBarButtonItem(customView: label)
        self.navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
        
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//    else if(indexPath.section == 2 && indexPath.row == 0 && cellTakeMed!.isHidden == true){
//        height = 0
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.section == 0 && indexPath.row == 0) {
            height = 72
        }
        else if(indexPath.section == 1 && indexPath.row == 0 || indexPath.section == 2 && indexPath.row == 0){
            height = 56
        }
        else{
            height = 52
        }
        if(indexPath.section == 3 && indexPath.row == 0 && switchMode!.switchOnTime.isOn == true){
            height = 0
        }
            
        return height
    }
    

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                let cell = tblView.dequeueReusableCell(withIdentifier: "medNameTableViewCell", for: indexPath) as! MedNameTableViewCell
                
                let medicine_time = self.coreDataManager.items![coreDataManager.medicineSelectedIdx]
                cell.lblMedname.text = medicine_time.medicine?.name
                if(medicine_time.medicine?.eat_time == 2){
                    cell.lblMedTime.text = "Sesudah makan"
                }
                else if(medicine_time.medicine?.eat_time == 1){
                    cell.lblMedTime.text = "Sebelum makan"
                }
                else if(medicine_time.medicine?.eat_time == 3){
                    cell.lblMedTime.text = "Bersamaan dengan makan"
                }else{
                    cell.lblMedTime.text = "Waktu Spesifik"
                }
                
                return cell
            }
        }
        
        else if(indexPath.section == 1){
            if(indexPath.row == 0){
                switchMode = tblView.dequeueReusableCell(withIdentifier: "onTimeTableViewCell", for: indexPath) as! OnTimeTableViewCell
                
                return switchMode!
            }
        }
        
        else if(switchMode!.switchOnTime.isOn == false){
            if(indexPath.section == 2){
                if(indexPath.row == 0){
                    cellTakeMed = tblView.dequeueReusableCell(withIdentifier: "takeMedTimeTableViewCell", for: indexPath) as! TakeMedTimeTableViewCell
                    
                    return cellTakeMed!
                }
            }
            
            else if(indexPath.section == 3){
                if(indexPath.row == 0){
                    let cell = tblView.dequeueReusableCell(withIdentifier: "btnSaveTableViewCell", for: indexPath) as! BtnSaveTableViewCell
                    
                    return cell
                    
                }
            }
            return UITableViewCell()
        }
        
        else if(switchMode!.switchOnTime.isOn == true){
            if(indexPath.section == 3){
                if(indexPath.row == 0){
                    cellTakeMed = tblView.dequeueReusableCell(withIdentifier: "takeMedTimeTableViewCell", for: indexPath) as! TakeMedTimeTableViewCell
                    
                    return cellTakeMed!
                }
            }
            
            else if(indexPath.section == 2){
                if(indexPath.row == 0){
                    let cell = tblView.dequeueReusableCell(withIdentifier: "btnSaveTableViewCell", for: indexPath) as! BtnSaveTableViewCell
                    
                    return cell
                    
                }
            }
        }
        
        return UITableViewCell()
    }
    
}
