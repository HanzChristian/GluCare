//
//  StatisticsViewController.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 09/12/22.
//

import UIKit
import CoreData

class StatisticsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let currentDateTime = Date()
    let formatter = DateFormatter()
    
    var items = CoreDataManager.coreDataManager.items
    var itemsMed = CoreDataManager.coreDataManager.medicines
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = "Statistik"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        
        //formatter.timeStyle = .none
        //formatter.dateStyle = .medium
        formatter.dateFormat = "MMM d"
        
        let nibAdheranceStat = UINib(nibName: "AdheranceSTVC", bundle: nil)
        tableView.register(nibAdheranceStat, forCellReuseIdentifier: "adheranceSTVC")
        let nibBGStat = UINib(nibName: "BGSTVC", bundle: nil)
        tableView.register(nibBGStat, forCellReuseIdentifier: "iBGSTVC")
        let nibHbA1CStat = UINib(nibName: "HbA1CSTVC", bundle: nil)
        tableView.register(nibHbA1CStat, forCellReuseIdentifier: "iHbA1CSTVC")
        
        setNavItem()
        //roundedTitle()
        //
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "adheranceSTVC", for: indexPath) as! AdheranceSTVC
                ///
                var percentage = 0.0
                percentage = calculateAdherancePercentage()
                cell.percentageAdheranceLbl?.text = "\(percentage) %"

                ///
                return cell
            }
        }
        else if(indexPath.section == 1){
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "iBGSTVC", for: indexPath) as! BGSTVC
                var mean = 0.0
                mean = calculateBGPercentage()
                cell.percentageBGLbl?.text = "\(mean) mg/dL"
                
                return cell
            }
        }
        else if(indexPath.section == 2){
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "iHbA1CSTVC", for: indexPath) as! HbA1CSTVC
                var percentage = 0.0
                percentage = calculateHbA1CPercentage()
                cell.percentageHbA1CLbl?.text = "\(percentage) %"
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 40
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let sectionLabel = UILabel(frame: CGRect(x: 18, y: 0, width: tableView.bounds.size.width, height: 5))
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: daySelected))!
        let dateFrom = formatter.string(from: startOfMonth)
        let dateToday = formatter.string(from: currentDateTime)
        let statisticsSections = ["Rata-rata bulanan \(dateFrom) - \(dateToday)","", ""]
        sectionLabel.font = .rounded(ofSize: 16, weight: .semibold)
        sectionLabel.textColor = UIColor.black
        sectionLabel.text = statisticsSections[section]
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        
        return headerView
        
        
        
        
        
        
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
        
        
    }
    
    func calculateAdherancePercentage() -> Double {
        let logs = CoreDataManager.coreDataManager.fetchLogsMonthly(daySelected: Date())
        var skippedMed = 0.0
        var totalMeds = 0.0
        //var result = nom/(nom + skip med #totalMeds)
        var resultMeds = 0.0
        for log in logs{
            //Meds
            if (log.type == 0) {
                totalMeds += 1
                print("action", log.action)
                if (log.action! == "Skip" || log.action! == "Nil") {
                    skippedMed += 1
                }
            }
        }
        
        print("print calculate" ,totalMeds, skippedMed)
        if (totalMeds == 0.0 && skippedMed == 0.0) {
            return 0.0
        }
        resultMeds = Double(round((totalMeds - skippedMed) / (totalMeds) * 100.0))
        return resultMeds
    }
    
    func calculateBGPercentage() -> Double {
        let logs = CoreDataManager.coreDataManager.fetchLogsMonthly(daySelected: Date())
        var totalBG = 0.0
        var countBG = 0.0
        var resultBG = 0.0
        for log in logs{
            //Meds
            if (log.type == 1 && (log.eat_time == 0 || log.eat_time == 1) && log.action! == "Take") {
                countBG += 1.0
                totalBG += Double(Int(log.bg_check_result!) ?? Int(0.0))
            }
        }
        if (countBG == 0) {
            return 0.0
        }
        resultBG = Double(round((totalBG) / (countBG)))
        
        return resultBG
    }
    
    func calculateHbA1CPercentage() -> Double {
        let logs = CoreDataManager.coreDataManager.fetchLogsMonthly(daySelected: Date())
        var totalHbA1C = 0.0
        var countHbA1c = 0.0
        var resultHbA1C = 0.0
        for log in logs{
            //Meds
            if (log.type == 1 && (log.eat_time == 2) && log.action! == "Take") {
                countHbA1c += 1.0
                totalHbA1C += Double(Int(log.bg_check_result!) ?? Int(0.0))
            }
        }
        if (countHbA1c == 0) {
            return 0.0
        }
        resultHbA1C = Double(round((totalHbA1C) / (countHbA1c)))
        return resultHbA1C
    }
    
    
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Statistik"
    }
    
    @objc private func updateItem(){
        
        CoreDataManager.coreDataManager.fetchMeds()
        CoreDataManager.coreDataManager.fetchMedicine()
        
        items = CoreDataManager.coreDataManager.items
        itemsMed = CoreDataManager.coreDataManager.medicines
        
        
        
    }
}

extension CoreDataManager {
    
    func fetchLogsMonthly(daySelected: Date) ->[Log] {
        var logs = [Log]()
        do{
            let request = Log.fetchRequest() as NSFetchRequest<Log>
            
            // Get the current calendar with local time zone
            // Get today's beginning & end
            let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: daySelected))!
            let dateFrom = calendarManager.calendar.startOfDay(for: startOfMonth) // eg. 2016-10-10 00:00:00
            let startDate = calendarManager.calendar.startOfDay(for: daySelected)
            let dateTo = calendarManager.calendar.date(byAdding: .day, value: 1, to: startDate)

            // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time

            // Set predicate as date being today's date
            let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(Log.date))
            
            let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Log.date), dateTo! as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            
            request.predicate = datePredicate
            
            let sort = NSSortDescriptor(key: "time", ascending: true)
            request.sortDescriptors = [sort]
            
            //self.logs = try context.fetch(request)
            
            logs = try context.fetch(request)
            
        }catch{
        }
        return logs
    }
}
