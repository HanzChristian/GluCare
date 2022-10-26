//
//  TakeBGViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 06/10/22.
//

import UIKit

class TakeBGViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tblViewBG: UITableView!
    
    var cellBGName: BGNameTableViewCell?
    var cellBGResult: BGResultTableViewCell?
    var indexPath:IndexPath?
    var daySelected: Date?
    let coreDataManager = CoreDataManager.coreDataManager
    var jadwalVars = [JadwalVars]()
    
    var bg = BG()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setNib()
        view.backgroundColor = .systemGroupedBackground
        
        tblViewBG?.delegate = self
        tblViewBG?.dataSource = self
        
        setNav()
        setNib()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.), name: NSNotification.Name(rawValue: "saveSheet"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveSheet), name: NSNotification.Name(rawValue: "saveBG"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.skipSheet), name: NSNotification.Name(rawValue: "skipBG"), object: nil)
        
    }
    
    @objc func saveSheet(){
        self.coreDataManager.simpanBG(daySelected: daySelected!, indexPath: indexPath!,bGResult: (cellBGResult?.BGInputLbl.text)!)
        self.coreDataManager.fetchLogs(tableView: self.tblViewBG!, daySelected: daySelected!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func skipSheet(){
        self.coreDataManager.lewatBG(daySelected: daySelected!, indexPath: indexPath!,bGResult: (cellBGResult?.BGInputLbl.text)!)
        self.coreDataManager.fetchLogs(tableView: self.tblViewBG!, daySelected: self.daySelected!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func reloadTableView(){
        do{
            DispatchQueue.main.async {
                self.tblViewBG.reloadData()
            }
        }catch{
            
        }
    }
    
    
    func setNav(){
        
        let label = UILabel()
        label.text = "Hasil Cek Gula Darah"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        //        label.sizeToFit()
        
        
        let leftItem = UIBarButtonItem(customView: label)
        self.navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
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
                print("ini selected idx \(coreDataManager.medicineSelectedIdx)")

                cellBGName = tblViewBG.dequeueReusableCell(withIdentifier: "bgNameTableViewCell", for: indexPath) as! BGNameTableViewCell

                if(bg.bg_type == 0){
                    cellBGName!.BGNameLbl.text = "Gula Darah Puasa"
                }else if(bg.bg_type == 1){
                    cellBGName!.BGNameLbl.text = "Gula Darah Sesaat"
                }else{
                    cellBGName!.BGNameLbl.text = "HBA1C"
                }

                print("INI NILAI DARI BG TYPE \(bg.bg_type)")

                return cellBGName!
            }
        }
        else if(indexPath.section == 1){
            if(indexPath.row == 0){
                cellBGResult = tblViewBG.dequeueReusableCell(withIdentifier: "bgResultTableViewCell", for:indexPath) as! BGResultTableViewCell
                cellBGResult!.BGInputLbl?.placeholder = "Misal: 100"

                if(bg.bg_type == 0){
                    cellBGResult!.BGUnitLbl.text = "mg/dL"
                }else if(bg.bg_type == 1){
                    cellBGResult!.BGUnitLbl.text = "mg/dL"
                }else{
                    cellBGResult!.BGUnitLbl.text = "%"
                }
                return cellBGResult!
            }
        }
        else if(indexPath.section == 2){
            if(indexPath.row == 0){
                let cell = tblViewBG.dequeueReusableCell(withIdentifier: "bgBtnSaveTableViewCell", for:indexPath) as! BGBtnSaveTableViewCell
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
