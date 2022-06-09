//
//  ViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 07/06/22.
//

import UIKit
import FSCalendar

class ViewController: UIViewController, FSCalendarDelegate {
    
    var medicines = ["Panadol","Metformin","Mebaral","Metaglip"]
    var freqs = ["1 time","2 times","3 times","4 times"]
    
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var AddMedicationBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        calendar.scope = .week
        title = "Medication Today"
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YYYY"
        let dateSelected = formatter.string(from: date)
        print("\(dateSelected)")
    }
    
    @IBAction func didTapBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "AddMedication", sender: self)
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
            return medicines.count //berdasarkan variable jumlah cellnya (pake .count)
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ViewControllerTVC
            
            cell.medLbl.text = medicines[indexPath.row]
            cell.freqLbl.text = freqs[indexPath.row]
            cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
            cell.cellImgView.layer.cornerRadius = cell.cellImgView.frame.height / 2
            
            return cell
    }
}

