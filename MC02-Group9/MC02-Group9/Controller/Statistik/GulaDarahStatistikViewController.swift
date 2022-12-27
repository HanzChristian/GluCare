//
//  GulaDarahStatistikViewController.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 18/11/22.
//

import UIKit
import Charts
import TinyConstraints
import Fastis

class GulaDarahStatistikViewController: UIViewController, ChartViewDelegate{
    
    var chartDataEntries = [ChartDataEntry]()
    let coredatamanager = CoreDataManager.coreDataManager
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var leftArrow: UIButton!
    @IBOutlet weak var rightArrow: UIButton!
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let calendarHelper = CalendarHelper()
    let datePicker = UIDatePicker()
    let week = ["M","S","S","R","K","J","S"]
    var day = [String]()
    var selected = 0
    
    let today = Date()
    var dateController = 0
    
    @IBAction func tapTextField2(_ sender: Any) {
        chooseRange()
        self.view.endEditing(true)
    }
    @IBAction func tapTextField(_ sender: Any) {
        chooseRange()
    }
    
    @IBOutlet weak var dateField: UILabel!
    
    @IBAction func rightBtn(_ sender: Any) {
        dateController += 1
        updateDateField()
    }
    
    @IBAction func leftBtn(_ sender: Any) {
        dateController -= 1
        updateDateField()
    }
    
    var currentValue: FastisValue? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            if let rangeValue = self.currentValue as? FastisRange {
                if(formatter.string(from: rangeValue.fromDate) == formatter.string(from: rangeValue.toDate)){
                    self.textField.text = formatter.string(from: rangeValue.fromDate)
                }else{
                    self.textField.text = formatter.string(from: rangeValue.fromDate) + " - " + formatter.string(from: rangeValue.toDate)
                }
                
            } else if let date = self.currentValue as? Date {
                self.textField.text = formatter.string(from: date)
            } else {
                self.textField.text = "Choose a date"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .secondarySystemBackground
        
        setupLineChartView()
        
        currentValue = nil
        textField.textAlignment = .center


        updateDateField()
        
        segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
    }
    
    
    
    func dayInit(){
        for i in 0...25{
            if(i >= 10){
                day.append("\(i):00")
            }else{
                day.append("0\(i):00")
            }
            
        }
    }
    
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            print("Select 0")
            selected = 0
            lineChartView = setupDailyView(chartView: lineChartView)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            print("Select 1")
            selected = 1
            lineChartView = setupWeeklyView(chartView: lineChartView)
        } else if segmentedControl.selectedSegmentIndex == 2 {
            print("Select 2")
            selected = 2
            
        }
        
        dateController = 0
        updateDateField()
        
        lineChartView.data?.notifyDataChanged()
        lineChartView.notifyDataSetChanged()
        

    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    let weekSampleValues: [ChartDataEntry] = [
//        ChartDataEntry(x: 0, y: 100),
//        ChartDataEntry(x: 1, y: 120),
        ChartDataEntry(x: 2, y: 105),
//        ChartDataEntry(x: 3, y: 150),
        ChartDataEntry(x: 4, y: 110),
//        ChartDataEntry(x: 5, y: 90),
//        ChartDataEntry(x: 6, y: 85),
    ]
    
    let daySampleValues: [ChartDataEntry] = [

        ChartDataEntry(x: 200, y: 110),
        ChartDataEntry(x: 700, y: 120),
        ChartDataEntry(x: 1000, y: 100),
    ]
    
    let monthSampleValues: [ChartDataEntry] = [

        ChartDataEntry(x: 3, y: 110),
        ChartDataEntry(x: 20, y: 120),
        ChartDataEntry(x: 28, y: 100),
    ]
    
    
}
