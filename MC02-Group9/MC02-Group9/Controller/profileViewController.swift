//
//  profileViewController.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 27/10/22.
//

import UIKit

class ProfileSection {
    var profileSectionTitle: String?
    init(profileSectionTitle: String) {
        self.profileSectionTitle = profileSectionTitle
    }
}


class profileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var profileSection = [ProfileSection]()
    var currentCell: IndexPath?
    var height = 56.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = "Profil"
        self.navigationItem.title = "Profile2"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        
        profileSection.append(ProfileSection.init(profileSectionTitle: ""))
        profileSection.append(ProfileSection.init(profileSectionTitle: "Target"))
        profileSection.append(ProfileSection.init(profileSectionTitle: "Keluarga"))
        
        let nibUsername = UINib(nibName: "UsernameTVC", bundle: nil)
        tableView.register(nibUsername, forCellReuseIdentifier: "usernameTVC")
        let nibAdherance = UINib(nibName: "MedAdheranceTVC", bundle: nil)
        tableView.register(nibAdherance, forCellReuseIdentifier: "medAdheranceTVC")
        let nibHbA1C = UINib(nibName: "HbA1CBGTVC", bundle: nil)
        tableView.register(nibHbA1C, forCellReuseIdentifier: "hbA1CBGTVC")
        let nibFasting = UINib(nibName: "FastingBGTVC", bundle: nil)
        tableView.register(nibFasting, forCellReuseIdentifier: "fastingBGTVC")
        
        //view.backgroundColor = .systemGroupedBackground
        setNavItem()
        roundedTitle()
        
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else if (section == 1){
            return 3
        } else {
            return 1
            //            return jadwal.count+1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "usernameTVC", for: indexPath) as! UsernameTVC
                return cell
            }
        } else if (indexPath.section == 1) {
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
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                height = 80
            }
        } else {
            height = 56.0
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return true
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 24
        }
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let sectionLabel = UILabel(frame: CGRect(x: 18, y: 0, width: tableView.bounds.size.width, height: 5))
        sectionLabel.font = .rounded(ofSize: 16, weight: .semibold)
        sectionLabel.textColor = UIColor.black
        sectionLabel.text = profileSection[section].profileSectionTitle
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        
        return headerView
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
                self.navigationItem.title = "Today"
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
