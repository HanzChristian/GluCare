//
//  profileViewController.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 27/10/22.
//

import UIKit
import FirebaseAuth

class ProfileSection {
    var profileSectionTitle: String?
    init(profileSectionTitle: String) {
        self.profileSectionTitle = profileSectionTitle
    }
}


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var profileSection = [ProfileSection]()
    var currentCell: IndexPath?
    var height = 56.0
    
    var isLogin = false
    
    func alreadyLogin(){
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if user != nil {
                self!.isLogin = true
                self!.tableView.reloadData()
            }
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + tableView.rowHeight + 50, right: 0)
            }
        }

    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        hideKeyboardWhenTappedAround()
        getRole()
        
        self.tabBarController?.title = "Profil"
        self.navigationItem.title = "Profile2"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        
        
        profileSection.append(ProfileSection.init(profileSectionTitle: ""))
        profileSection.append(ProfileSection.init(profileSectionTitle: "Target"))
        profileSection.append(ProfileSection.init(profileSectionTitle: "Keluarga"))
        profileSection.append(ProfileSection.init(profileSectionTitle: ""))
        
        
        let nibUsername = UINib(nibName: "UsernameTVC", bundle: nil)
        tableView.register(nibUsername, forCellReuseIdentifier: "usernameTVC")
        let nibAdherance = UINib(nibName: "MedAdheranceTVC", bundle: nil)
        tableView.register(nibAdherance, forCellReuseIdentifier: "medAdheranceTVC")
        let nibHbA1C = UINib(nibName: "HbA1CBGTVC", bundle: nil)
        tableView.register(nibHbA1C, forCellReuseIdentifier: "hbA1CBGTVC")
        let nibFasting = UINib(nibName: "FastingBGTVC", bundle: nil)
        tableView.register(nibFasting, forCellReuseIdentifier: "fastingBGTVC")
        let nibInvitesText = UINib(nibName: "InvitesTextTVC", bundle: nil)
        tableView.register(nibInvitesText, forCellReuseIdentifier: "invitesTextTVC")
        let nibListCaregiver = UINib(nibName: "ListCaregiverTVC", bundle: nil)
        tableView.register(nibListCaregiver, forCellReuseIdentifier: "listCaregiverTVC")
        let nibExit = UINib(nibName: "ExitTVC", bundle: nil)
        tableView.register(nibExit, forCellReuseIdentifier: "exitTVC")
        let nibIntro = UINib(nibName: "IntroTVC", bundle: nil)
        tableView.register(nibIntro, forCellReuseIdentifier: "introTVC")
        
        //view.backgroundColor = .systemGroupedBackground
        setNavItem()
        roundedTitle()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(toLogin), name: NSNotification.Name(rawValue: "passLogin"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(toOnboarding), name: NSNotification.Name(rawValue: "passOnboarding"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
        
        alreadyLogin()
    }
    
    
    @objc func refresh(){
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.tableView.reloadData()
        }
    }
    
    @objc func toLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        let navController = UINavigationController(rootViewController: vc)
        
//        vc.navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
//
        navController.modalPresentationStyle = .pageSheet
        navController.navigationBar.prefersLargeTitles = true
        
//        UserDefaults.standard.removeObject(forKey: "isNewUser")
        
        present(navController, animated: true, completion: nil)
    
    }
    
    @objc func toOnboarding(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "onBoardingViewController") as! OnBoardingViewController
//        let navController = UINavigationController(rootViewController: vc)
        
        vc.navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
//
//        navController.modalPresentationStyle = .fullScreen
//        navController.navigationBar.prefersLargeTitles = true
        
        UserDefaults.standard.removeObject(forKey: "isNewUser")
        
        present(vc, animated: true, completion: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //yang lama
//        return 4
        if(isLogin == false){
            return 1
        }else{
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countCaregiver = listCaregiver.caregiverList.count
        
        if(isLogin == false){
            if (section == 0){
                return 1
            }
        }
        else{
            if (section == 0){
                return 1
            }
            else if (section == 1){
                return 3
            } else if (section == 2){
                return countCaregiver+1
            }
            else {
                return 1
            }
        }
        
        return 1
    }
        
        //yang lama
//        if (section == 0){
//            return 2
//        }
//        else if (section == 1){
//            return 3
//        } else if (section == 2){
//            return countCaregiver+1
//        } else {
//            return 1
//        }
        //            return jadwal.count+1
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let countCaregiver = listCaregiver.caregiverList.count
        
        if(isLogin == false){
            if(indexPath.section == 0){
                if (indexPath.row == 0) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "introTVC", for: indexPath) as! IntroTVC
                    return cell
                }
            }
        }
        else{ //login == false
            if(indexPath.section == 0){
                if (indexPath.row == 0) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "usernameTVC", for: indexPath) as! UsernameTVC
                    return cell
                }
            }
            else if (indexPath.section == 1){
                if (indexPath.row == 0) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "medAdheranceTVC", for: indexPath) as! MedAdheranceTVC
                    return cell
                } else if (indexPath.row == 1) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "hbA1CBGTVC", for: indexPath) as! HbA1CBGTVC
                    return cell
                } else if (indexPath.row == 2) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "fastingBGTVC", for: indexPath) as! FastingBGTVC
                    return cell
                }
            }
            else if (indexPath.section == 2) {
                if (indexPath.row == (countCaregiver)) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "invitesTextTVC", for: indexPath) as! InvitesTextTVC
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "listCaregiverTVC", for: indexPath) as! ListCaregiverTVC
                    cell.setupView(care: listCaregiver.caregiverList[indexPath.row])
                    return cell
                }
            }
            else if (indexPath.section == 3) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "exitTVC", for: indexPath) as! ExitTVC
                return cell
            }
        }
        
        //yang lama
//        if(indexPath.section == 0){
//            if (indexPath.row == 0) {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "introTVC", for: indexPath) as! IntroTVC
//                return cell
//            }
//            else if (indexPath.row == 1){
//                let cell = tableView.dequeueReusableCell(withIdentifier: "usernameTVC", for: indexPath) as! UsernameTVC
//                return cell
//            }
//        } else if (indexPath.section == 1) {
//            if (indexPath.row == 0) {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "medAdheranceTVC", for: indexPath) as! MedAdheranceTVC
//                return cell
//            } else if (indexPath.row == 1) {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "hbA1CBGTVC", for: indexPath) as! HbA1CBGTVC
//                return cell
//            } else if (indexPath.row == 2) {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "fastingBGTVC", for: indexPath) as! FastingBGTVC
//                return cell
//            }
//        } else if (indexPath.section == 2) {
//            if (indexPath.row == (countCaregiver)) {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "invitesTextTVC", for: indexPath) as! InvitesTextTVC
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "listCaregiverTVC", for: indexPath) as! ListCaregiverTVC
//                cell.setupView(care: listCaregiver.caregiverList[indexPath.row])
//                return cell
//            }
//        } else if (indexPath.section == 3) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "exitTVC", for: indexPath) as! ExitTVC
//            return cell
//        }
        return UITableViewCell()
    }
    //
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        if let cell = tableView.cellForRow(at: indexPath) as? MealTimePickerTableViewCell {
    //            if !cell.isFirstResponder {
    //                _ = cell.becomeFirstResponder()
    //            }
    //        } else if tableView.cellForRow(at: indexPath) is AddNewScheduleTableViewCell{
    //            //            jadwal.append("Jadwal \(jadwal.count+1)")
    //            UIView.performWithoutAnimation {
    //                let loc = tableView.contentOffset
    //                tableView.reloadSections(IndexSet(integer: 2), with: .none)
    //                tableView.setContentOffset(loc, animated: false)
    //            }
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let countCaregiver = listCaregiver.caregiverList.count
        
            if(isLogin == true){
                if(indexPath.section == 0){
                    if(indexPath.row == 0){
                        height = 80
                    }
                }
                else if (indexPath.section == 2) {
                    if (indexPath.row == countCaregiver) {
                        height = 180
                    } else if (indexPath.row != countCaregiver) {
                        height = 56
                    }
                } else {
                    height = 56.0
                }
        }
        else{
            if(indexPath.section == 0){
                if(indexPath.row == 0){
                    height = 509
                }
            }
        }
            
            
        //yang lama
//        if(isLogin == true){
//            if(indexPath.section == 0){
//                if(indexPath.row == 0){
//                    height = 0
//                }
//                else if(indexPath.row == 1){
//                    height = 80
//                }
//            }
//            else if (indexPath.section == 2) {
//                if (indexPath.row == countCaregiver) {
//                    height = 180
//                } else if (indexPath.row != countCaregiver) {
//                    height = 56
//                }
//            } else {
//                height = 56.0
//            }
//
//        }else{
//            if(indexPath.section == 0){
//                if(indexPath.row == 0){
//                    height = 509
//                }else if(indexPath.row == 1){
//                    height = 0
//                }
//            }else{
//                height = 0
//            }
//        }
        return height
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if(isLogin == true){
            if (indexPath.section == 0) {
                if (indexPath.row == 1) {
                    return true
                }
            }
        }
        //yang lama
//        if (indexPath.section == 0) {
//            if (indexPath.row == 1) {
//                return true
//            }
//        }
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(isLogin == true){
            if (indexPath.section == 3) {
                if (indexPath.row == 0) {
                    print("alert exit done")
                    let alert = UIAlertController(title: "Yakin mau keluar?", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Ya", style: .destructive, handler: {
                        action in
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()

                            listCaregiver.caregiverList.removeAll()
                            CoreDataManager.coreDataManager.resetAllCoreData()

                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "passOnboarding"), object: nil)

                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)

                        }
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
        }

        
        //yang lama
//        if (indexPath.section == 3) {
//            if (indexPath.row == 0) {
//                print("alert exit done")
//                let alert = UIAlertController(title: "Yakin mau keluar?", message: "", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: nil))
//                alert.addAction(UIAlertAction(title: "Ya", style: .destructive, handler: {
//                    action in
//                    let firebaseAuth = Auth.auth()
//                    do {
//                        try firebaseAuth.signOut()
//
//                        listCaregiver.caregiverList.removeAll()
//                        CoreDataManager.coreDataManager.resetAllCoreData()
//
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "passOnboarding"), object: nil)
//
//                    } catch let signOutError as NSError {
//                        print("Error signing out: %@", signOutError)
//
//                    }
//                }))
//                present(alert, animated: true, completion: nil)
//            }
//        }
   }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(isLogin == false){
            return 0
        }
        else{
            if(section == 0){
                return 24
            }else if (section == 3){
                return 14
            }
            return 35
            
            //yang lama
//            if (section == 0) {
//                return 24
//            } else if (section == 3) {
//                return 14
//            }
//            return 35
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        let headerView = UIView()
        if(isLogin == false){
            return headerView
        }else{
            let sectionLabel = UILabel(frame: CGRect(x: 18, y: 0, width: tableView.bounds.size.width, height: 5))
            sectionLabel.font = .rounded(ofSize: 16, weight: .semibold)
            sectionLabel.textColor = UIColor.black
            sectionLabel.text = profileSection[section].profileSectionTitle
            sectionLabel.sizeToFit()
            headerView.addSubview(sectionLabel)
            
            return headerView
        }
    }
    
    func roundedTitle() {
        if let roundedTitleDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .largeTitle)
            .withDesign(.rounded)?
            .withSymbolicTraits(.traitBold) {
            self.navigationController?
                .navigationBar
                .largeTitleTextAttributes = [
                    .font: UIFont(descriptor: roundedTitleDescriptor, size: 0)
                ]
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            DispatchQueue.main.async {
                self.navigationItem.title = "Hari ini"
            }
        }
    }
    
    
    
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Profil"
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveItem() {
        dismiss(animated: true, completion: nil)
    }
}

struct listCaregiver {
    
    var name: String
    var status: Int
    
    init(name: String, status: Int) {
        self.name = name
        self.status = status
    }
    
    static var caregiverList = [listCaregiver]()
    
}

