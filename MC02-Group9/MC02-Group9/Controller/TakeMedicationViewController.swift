//
//  TakeMedicationViewController.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 04/07/22.
//

import UIKit

class TakeMedicationViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setNib()
        
        view.backgroundColor = .blue
        
        //tblView?.delegate = self
        //tblView?.dataSource = self
        
        setNav()
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
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Masukkan Waktu Minum Obat"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
        
        
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0 :
            // ROW 1
            let cell = tblView.dequeueReusableCell(withIdentifier: "medNameTableViewCell", for: indexPath) as! MedNameTableViewCell
            
            // Set nama obatnya dr notification center
            
            
            return cell
            
        case 1 :
            // ROW 2
            let cell = tblView.dequeueReusableCell(withIdentifier: "onTimeTableViewCell", for: indexPath) as! OnTimeTableViewCell
            
            return cell
            
        case 2 :
            // ROW 3
            let cell = tblView.dequeueReusableCell(withIdentifier: "takeMedTimeTableViewCell", for: indexPath) as! TakeMedTimeTableViewCell
            
            return cell
            
        case 3 :
            // ROW 4
            let cell = tblView.dequeueReusableCell(withIdentifier: "btnSaveTableViewCell", for: indexPath) as! BtnSaveTableViewCell
            
            return cell
            
            
        default:
            return UITableViewCell()
            
        }
        
    }

}
