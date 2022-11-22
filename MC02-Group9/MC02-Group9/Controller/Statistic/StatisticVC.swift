//
//  StatisticVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 17/11/22.
//

import UIKit

class StatisticVC: UIViewController {
    
    var statisticSections = ["Rata-rata mingguan", "", "Ringkasan"]
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNib()
        refresh()
        
        navigationItem.title = "Statistik"
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView.delegate = self
        tableView.delegate = self
        
        tableView?.backgroundColor = .systemGroupedBackground
        
    }
    
    @objc func refresh() {
        
    }
    
    func setNib() {
        let nibAdherance = UINib(nibName: "StatisticAdheranceTVC", bundle: nil)
        tableView?.register(nibAdherance, forCellReuseIdentifier: "statisticAdheranceTVC")
        let nibBG = UINib(nibName: "StatisticBGTVC", bundle: nil)
        tableView?.register(nibBG, forCellReuseIdentifier: "statisticBGTVC")
    }

}

extension StatisticVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let sectionLabel = UILabel(frame: CGRect(x: 16, y: 24, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        sectionLabel.font = .rounded(ofSize: 16, weight: .regular)
        sectionLabel.textColor = UIColor.black
        sectionLabel.text = statisticSections[section]
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statisticAdheranceTVC", for: indexPath) as! StatisticAdheranceTVC
            return cell
        } else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statisticBGTVC", for: indexPath) as! StatisticBGTVC
            return cell
        } else {
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 1) {
            return 5
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 2) {
            return 148
        }
        return 128
    }
}
