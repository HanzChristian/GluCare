//
//  EditPasswordVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 13/01/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class EditPasswordVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var cellOldPass: OldPassTVC?
    var cellNewPass: NewPassTVC?
    var cellConfNewPass: ConfNewPassTVC?
    
    @IBOutlet weak var tableView: UITableView!
    
//    @IBAction func saveNewPassword(_ sender: Any) {
//        let email = FirebaseManager.firebaseManager.email
//        let pass = cellOldPass?.oldPassTxt.text
//        Auth.auth().signIn(withEmail: email, password: pass!){ [weak self] authResult, error in
//
//                if let e = error {
//                    print(e)
//                } else {
//                    if (self?.cellNewPass?.newPassTxt.text == self?.cellConfNewPass?.confNewPassTxt.text) {
//                        // nav bar enabled
//                        self?.navigationItem.rightBarButtonItem?.isEnabled = true
//                        let password = self?.cellNewPass?.newPassTxt.text
//                        Auth.auth().currentUser?.updatePassword(to: password!) { error in
//                            if let e = error {
//                                print(e)
//                            } else {
//                                print("password updated to: ", password!)
//                            }
//                        }
//                    }
//
//                }
//            }
//        }
    
    
    
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
        
        validateForm()
        setNavItem()
        NotificationCenter.default.addObserver(self, selector: #selector(self.validateForm), name: NSNotification.Name(rawValue: "formValidateNotif"), object: nil)
        navigationItem.rightBarButtonItem?.isEnabled = false
        tableView.reloadData()
    }
    
    @objc func validateForm() {
        let textCellOld = cellOldPass?.oldPassTxt.text
        let textCellNew = cellNewPass?.newPassTxt.text
        let textCellConf = cellConfNewPass?.confNewPassTxt.text
        if ((textCellOld == Optional("")) || (textCellNew == Optional("")) || (textCellConf == Optional(""))) {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            if (textCellNew == textCellConf) {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
        
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
            cell.oldPassTxt?.attributedPlaceholder = NSAttributedString(
                string: "Masukkan Password Lama"
            )
            cellOldPass = cell
            validateForm()
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newPassTVC", for: indexPath) as! NewPassTVC
            cell.newPassTxt?.attributedPlaceholder = NSAttributedString(
                string: "Masukkan Password Baru"
            )
            cellNewPass = cell
            validateForm()
            return cell
        }
        else if (indexPath.section == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "confNewPassTVC", for: indexPath) as! ConfNewPassTVC
            cell.confNewPassTxt?.attributedPlaceholder = NSAttributedString(
                string: "Masukkan Ulang Password Baru"
            )
            cellConfNewPass = cell
            validateForm()
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
    
    private func setNavItem() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Ubah Password"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ubah", style: .plain, target: self, action: #selector(savePassword))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func savePassword() {
        let email = FirebaseManager.firebaseManager.email
        let pass = cellOldPass?.oldPassTxt.text
        Auth.auth().signIn(withEmail: email, password: pass!){ [weak self] authResult, error in
                
                if let e = error {
                    print(e)
                } else {
                    if (self?.cellNewPass?.newPassTxt.text == self?.cellConfNewPass?.confNewPassTxt.text) {
                        // nav bar enabled
                        self?.navigationItem.rightBarButtonItem?.isEnabled = true
                        let password = self?.cellNewPass?.newPassTxt.text
                        Auth.auth().currentUser?.updatePassword(to: password!) { error in
                            if let e = error {
                                print(e)
                            } else {
                                print("password updated to: ", password!)
                            }
                        }
                    }
                }
            }
        navigationController?.popViewController(animated: true)
    }
    
    
}
