//
//  ViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 07/06/22.
//

import UIKit
import FSCalendar

class ViewController: UIViewController, FSCalendarDelegate {
    
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
    
}

extension ViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //berdasarkan variable jumlah cellnya (pake .count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        
        return cell
    }
}

