//
//  EditPasswordVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 13/01/23.
//

import UIKit

class EditPasswordVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var height = 56.0
    var editPasswSection = ["Password Lama", "Password Baru", "Verifikasi Password Baru"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.title = "Ubah Password"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        
        
        let nibOldPass = UINib(nibName: "OldPassTVC", bundle: nil)
        tableView.register(nibOldPass, forCellReuseIdentifier: "oldPassTVC")
        let nibNewPass = UINib(nibName: "NewPassTVC", bundle: nil)
        tableView.register(nibNewPass, forCellReuseIdentifier: "newPassTVC")
        let nibConfNewPass = UINib(nibName: "ConfNewPassTVC", bundle: nil)
        tableView.register(nibConfNewPass, forCellReuseIdentifier: "confNewPassTVC")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let sectionLabel = UILabel(frame: CGRect(x: 4, y: 10, width: tableView.bounds.size.width, height: 5))
        sectionLabel.font = .rounded(ofSize: 16, weight: .semibold)
        sectionLabel.textColor = UIColor.black
        sectionLabel.text = editPasswSection[section]
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "oldPassTVC", for: indexPath) as! OldPassTVC
            cell.oldPassTxt?.placeholder = "Masukkan Password Lama"
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newPassTVC", for: indexPath) as! NewPassTVC
            cell.newPassTxt?.placeholder = "Masukkan Password Baru"
            return cell
        }
        else if (indexPath.section == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "confNewPassTVC", for: indexPath) as! ConfNewPassTVC
            cell.confNewPassTxt?.placeholder = "Masukkan Ulang Password Baru"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 35
        } else {
            return 35
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return true
            }
        }
        return false
    }
    
    
    
}
