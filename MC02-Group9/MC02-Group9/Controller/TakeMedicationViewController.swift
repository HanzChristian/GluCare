//
//  TakeMedicationViewController.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 04/07/22.
//

import UIKit

class TakeMedicationViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var height = 60.0
    let coreDataManager = CoreDataManager.coreDataManager
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setNib()
        view.backgroundColor = .systemGroupedBackground
        
        tblView?.delegate = self
        tblView?.dataSource = self
        
        setNav()
        setNib()
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
        return height
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                let cell = tblView.dequeueReusableCell(withIdentifier: "medNameTableViewCell", for: indexPath) as! MedNameTableViewCell
                
                let medicine_time = self.coreDataManager.items![indexPath.row]
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
                let cell = tblView.dequeueReusableCell(withIdentifier: "onTimeTableViewCell", for: indexPath) as! OnTimeTableViewCell
                return cell
            }
        }
        
        else if(indexPath.section == 2){
            if(indexPath.row == 0){
                let cell = tblView.dequeueReusableCell(withIdentifier: "takeMedTimeTableViewCell", for: indexPath) as! TakeMedTimeTableViewCell
                
                return cell
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
    
}
