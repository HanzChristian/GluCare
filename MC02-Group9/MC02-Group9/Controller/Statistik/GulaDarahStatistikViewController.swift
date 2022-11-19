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
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var lineChartView: LineChartView!
    let datePicker = UIDatePicker()
    let week = ["M","S","S","R","K","J","S"]
    var day = [String]()
    var selected = 0
    
    @IBAction func tapTextField2(_ sender: Any) {
        chooseRange()
        self.view.endEditing(true)
    }
    @IBAction func tapTextField(_ sender: Any) {
        
        chooseRange()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLineChartView()
        currentValue = nil
        textField.textAlignment = .center
//        createDatePicker()

        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)

        setData()


        segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
    
        
        
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
    
    @objc private func chooseRange() {
        let fastisController = FastisController(mode: .range)
        fastisController.title = "Choose range"
        fastisController.minimumDate = Calendar.current.date(byAdding: .month, value: -24, to: Date())
        fastisController.maximumDate = Date()
        fastisController.allowToChooseNilDate = true
        fastisController.shortcuts = [.today, .lastWeek, .lastMonth]
        fastisController.doneHandler = { newValue in
            self.currentValue = newValue
        }
        fastisController.present(above: self)
    }
    
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        toolbar.setItems([space,doneBtn], animated: true)
        
        textField.textAlignment = .center
        // assign toolbar
        textField.inputAccessoryView = toolbar
        
        // assign datepicker
        textField.inputView = datePicker
        
        // date picker mode
        datePicker.datePickerMode = .date
        
        datePicker.preferredDatePickerStyle = .wheels
        
    }
    
    @objc func donePressed(){
        // formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        
        
        textField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func setupLineChartView() {
        
        dayInit()
    
        lineChartView.drawBordersEnabled = true
        lineChartView.borderColor = .systemPink
        
        
        lineChartView.rightAxis.enabled = false
        
        let yAxsis = lineChartView.leftAxis
        yAxsis.labelFont = .boldSystemFont(ofSize: 12)
        yAxsis.setLabelCount(4, force: true)

        yAxsis.labelTextColor = .systemPink
        yAxsis.axisLineColor = .black
        yAxsis.labelPosition = .outsideChart
        
        let xAxsis = lineChartView.xAxis
        xAxsis.labelPosition = .bottom
        xAxsis.labelFont = .boldSystemFont(ofSize: 12)
        xAxsis.labelTextColor = .systemPink
        xAxsis.axisLineColor = .black
        
        lineChartView.animate(xAxisDuration: 1)
        
        lineChartView = setupDailyView(chartView: lineChartView)

    }
    
//    lazy var lineChartView: LineChartView = {
//        dayInit()
//        var chartView = LineChartView()
////        chartView.backgroundColor = .gray
//        chartView.drawBordersEnabled = true
//        chartView.borderColor = .systemPink
//
//
//        chartView.rightAxis.enabled = false
//
//        let yAxsis = chartView.leftAxis
//        yAxsis.labelFont = .boldSystemFont(ofSize: 12)
//        yAxsis.setLabelCount(4, force: true)
//
//        yAxsis.labelTextColor = .systemPink
//        yAxsis.axisLineColor = .black
//        yAxsis.labelPosition = .outsideChart
//
//        let xAxsis = chartView.xAxis
//        xAxsis.labelPosition = .bottom
//        xAxsis.labelFont = .boldSystemFont(ofSize: 12)
//        xAxsis.labelTextColor = .systemPink
//        xAxsis.axisLineColor = .black
//
//        chartView.animate(xAxisDuration: 1)
//
//        chartView = setupDailyView(chartView: chartView)
//
//
//        return chartView
//    }()
    
    func setupWeeklyView(chartView: LineChartView) -> LineChartView{
        chartView.xAxis.setLabelCount(week.count, force: true)
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: week)
        
        return chartView
    }
    
    func setupDailyView(chartView: LineChartView) -> LineChartView{
        chartView.xAxis.setLabelCount(5, force: true)
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: day)
        
        return chartView
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
        
        setData()
        
        
        lineChartView.data?.notifyDataChanged()
        lineChartView.notifyDataSetChanged()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData() {
        var set1 = LineChartDataSet(entries: daySampleValues,label: "Gula Darah")
        
        if selected == 0 {
            set1 = LineChartDataSet(entries: daySampleValues,label: "Gula Darah")
        }else if selected == 1{
            set1 = LineChartDataSet(entries: weekSampleValues,label: "Gula Darah")
        }
        
        set1.label = ""
        set1.colors = [.white]
        
        set1.lineWidth = 0
        set1.setCircleColor(.systemPink)
        set1.circleHoleColor = .systemPink
        set1.circleRadius = 5
        
        set1.highlightColor = .systemPink
        
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
    }
    
    let weekSampleValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0, y: 100),
        ChartDataEntry(x: 1, y: 120),
        ChartDataEntry(x: 2, y: 105),
        ChartDataEntry(x: 3, y: 150),
        ChartDataEntry(x: 4, y: 110),
        ChartDataEntry(x: 5, y: 90),
        ChartDataEntry(x: 6, y: 85),
    ]
    
    let daySampleValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0, y: 130),
        ChartDataEntry(x: 4, y: 100),
        ChartDataEntry(x: 8, y: 110),
        ChartDataEntry(x: 12, y: 170),
        ChartDataEntry(x: 14, y: 210),
        ChartDataEntry(x: 18, y: 180),
        ChartDataEntry(x: 24, y: 125),
    ]
    
    
}
