//
//  TakeBGViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 06/10/22.
//

import UIKit

class TakeBGViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tblViewBG: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setNib()
        view.backgroundColor = .systemGroupedBackground
        
        tblViewBG?.delegate = self
        tblViewBG?.dataSource = self
        
        setNav()
        setNib()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.), name: NSNotification.Name(rawValue: "saveSheet"), object: nil)
    }
    
    func reloadTableView(){
        do{
            DispatchQueue.main.async {
                self.tblViewBG.reloadData()
            }
        }catch{
            
        }
    }
    
    @objc func saveSheet(){ //nanti buat simpen sheetnya tunggu si richard
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
                let cell = tblViewBG.dequeueReusableCell(withIdentifier: "bgNameTableViewCell", for: indexPath) as! BGNameTableViewCell
                cell.BGNameLbl.text = "Masih dummy"
                return cell
            }
        }
        else if(indexPath.section == 1){
            if(indexPath.row == 0){
                let cell = tblViewBG.dequeueReusableCell(withIdentifier: "bgResultTableViewCell", for:indexPath) as! BGResultTableViewCell
                cell.BGInputLbl?.placeholder = "Misal: Metformin 250g"
                cell.BGUnitLbl.text = "%"
                return cell
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
