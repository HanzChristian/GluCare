//
//  EditProfileViewController.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 13/01/23.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var height = 56.0
    var profileSection = ["Nama", "Email", "Password"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//
//        hideKeyboardWhenTappedAround()
        
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
        
//        setNavItem()
//        roundedTitle()
        
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
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editEmailTVC", for: indexPath) as! EditEmailTVC
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
 
}


