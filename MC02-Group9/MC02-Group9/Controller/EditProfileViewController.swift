//
//  EditProfileViewController.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 13/01/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, checkForm, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    let dismissNotification = UNNotificationDismissActionIdentifier
    
    let db = Firestore.firestore()
    
    var cellUsername: EditUsernameTVC?
    var cellEmail: EditEmailTVC?
    
    @IBOutlet weak var tableView: UITableView!
    
   // @IBAction func didTapSaveProfile(_ sender: UIBarButtonItem) {
        
//        let indexPath: IndexPath = [0,0]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "editUsernameTVC", for: indexPath) as! EditUsernameTVC
//        var displayName = cell.nameTxt.text!
//
//        displayName = "dispaaaayy"
//        UserDefaults.standard.set(displayName, forKey: "name")
//
//        let updateUsername = db.collection("account").document()
//        updateUsername.setData([
//            "nama": "\(displayName)",
//        ], merge: true)
        
        
//        updateUsername.updateData([
//            "nama": "\(displayName)"
//        ]) { err in
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                FirebaseManager.firebaseManager.getAccountInfo()
//                print("Document successfully updated")
//            }
//        }
        
    
//        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//        changeRequest?.displayName = displayName
//        changeRequest?.commitChanges { error in
//            if let e = error {
//                print(e)
//            }
//        }
//    }
    
    
    
    var height = 56.0
    var profileSection = ["Nama", "Email", "Password"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tabBarController?.title = "Data Diri"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        
        
        let nibEditUsername = UINib(nibName: "EditUsernameTVC", bundle: nil)
        tableView.register(nibEditUsername, forCellReuseIdentifier: "editUsernameTVC")
        let nibEditEmail = UINib(nibName: "EditEmailTVC", bundle: nil)
        tableView.register(nibEditEmail, forCellReuseIdentifier: "editEmailTVC")
        let nibEditPassword = UINib(nibName: "EditPasswordTVC", bundle: nil)
        tableView.register(nibEditPassword, forCellReuseIdentifier: "editPasswordTVC")
        
        validateForm()
        setNavItem()
        NotificationCenter.default.addObserver(self, selector: #selector(self.validateForm), name: NSNotification.Name(rawValue: "formValidateNotif"), object: nil)
        
//        roundedTitle()
        
    }
    
    @objc func validateForm(){
        let txtUsername = cellUsername?.nameTxt.text
        let txtEmail = cellEmail?.emailTxt.text
        if (txtUsername == Optional("")) && (txtEmail == Optional("")) {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
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
        sectionLabel.text = profileSection[section]
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        return headerView
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editUsernameTVC", for: indexPath) as! EditUsernameTVC
            cellUsername = cell
            validateForm()
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editEmailTVC", for: indexPath) as! EditEmailTVC
            cellEmail = cell
            validateForm()
            return cell
        }
        else if (indexPath.section == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editPasswordTVC", for: indexPath) as! EditPasswordTVC
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                self.performSegue(withIdentifier: "goToEditPassword", sender: self)
            }
        }
    }
    
    private func setNavItem() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Data Diri"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(saveProfile))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func saveProfile() {
        let txtUsername = cellUsername?.nameTxt.text
        let txtEmail = cellEmail?.emailTxt.text
        if (txtUsername != Optional("")) {
            let newUsername = cellUsername!.nameTxt.text!
            let updateUsername = db.collection("account").document()
            updateUsername.setData([
                "nama": "\(newUsername)",
            ], merge: true)
        }
        if (txtEmail != Optional("")) {
            let email = cellEmail!.emailTxt.text!
            Auth.auth().currentUser?.updateEmail(to: email) { error in
                if let e = error {
                    print(e)
                } else {
                    
                }
            }
        }
        
        
        
    }
    
 
}

struct editProfile {
    static var editUsername: String = "1"
    static var editEmail: String = "1"
}


