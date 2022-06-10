//
//  ViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 07/06/22.
//

import UIKit
import FSCalendar
import CoreData

class ViewController: UIViewController, FSCalendarDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /*
    var medicines = ["Panadol","Metformin","Mebaral","Metaglip"]
    var freqs = ["1 time","2 times","3 times","4 times"]
    */
    
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var AddMedicationBtn: UIBarButtonItem!
    
    var items:[Medicine_Time]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        calendar.scope = .week
        title = "Medication Today"
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    
        dummyData()
        fetchMedicine()
        
    }
    
    func dummyData(){
    
        // create medicine
        let medicine = Medicine(context: context)
        medicine.name = "Panadol"
        medicine.rules = "After"
        medicine.strength = "500 mg"
        
        // Add time
        let medicine_time1 = Medicine_Time(context: context)
        medicine_time1.time = "07.00"
        
        let medicine_time2 = Medicine_Time(context: context)
        medicine_time2.time = "12.00"
        
        let medicine_time3 = Medicine_Time(context: context)
        medicine_time3.time = "18.00"
        
        // Add Time to Medicine
        medicine.addToTime(medicine_time1)
        medicine.addToTime(medicine_time2)
        medicine.addToTime(medicine_time3)
        
        do{
            try self.context.save()
        }catch{
            
        }
    }
    
    func fetchMedicine(){
        do{
            let request = Medicine_Time.fetchRequest() as NSFetchRequest<Medicine_Time>
            
            let sort = NSSortDescriptor(key: "time", ascending: true)
            request.sortDescriptors = [sort]
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }catch{
            
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YYYY"
        let dateSelected = formatter.string(from: date)
        print("\(dateSelected)")
    }
    
    @IBAction func didTapBtn(_ sender: Any) {
        let vc = AddMedicationViewController()
        
        let navVC = UINavigationController(rootViewController: vc)
        
        present(navVC, animated: true)
    }
    
}

extension ViewController:UITableViewDelegate{
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            //Take button swipe
            let takeAction = UITableViewRowAction(style: .normal, title: "Take"){ _, indexPath in
                //Logic belom diisi
            }
            //Delete button swipe
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete"){ _, indexPath in
                //Logic belom diisi
            }

            takeAction.backgroundColor = .systemBlue
            return [takeAction,deleteAction]
        }
}

extension ViewController:UITableViewDataSource{
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            /*
            return medicines.count //berdasarkan variable jumlah cellnya (pake .count)
            */
             
            return self.items?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            /*
            
            cell.medLbl.text = medicines[indexPath.row]
            cell.freqLbl.text = freqs[indexPath.row]
            */
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ViewControllerTVC
            
            let medicine_time = self.items![indexPath.row]
            
            cell.medLbl.text = medicine_time.medicine?.name
            cell.freqLbl.text = medicine_time.time
            
            cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
            cell.cellImgView.layer.cornerRadius = cell.cellImgView.frame.height / 2
            
            return cell
    }
}

