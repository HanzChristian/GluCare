//
//  GulaDarahStatistikViewController+DateSelector.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 14/12/22.
//

import UIKit
import Charts

extension GulaDarahStatistikViewController{
    
    func updateDateField(){
        var newDate: Date?
        let dateFormatter = DateFormatter()
        
        chartDataEntries.removeAll()
        
        if selected == 0 {
            newDate = calendarHelper.addDays(date: today, days: dateController)
            dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
            dateField.text = "\(dateFormatter.string(from: newDate!))"
            
            if id == 1{
                hari(date: newDate!, jenis: 0)
                hari(date: newDate!, jenis: 1)
            }else if id == 2{
                hari(date: newDate!, jenis: 2)
            }
            
            
            
        }else if selected == 1{
            
            let startWeek = calendarHelper.sundayForDate(date: today)
            print("dapong-chartStartWeek \(startWeek)")

            
            newDate = calendarHelper.addDays(date: startWeek, days: (dateController * 7))
            let endDate = calendarHelper.addDays(date: newDate!, days: 6)
            
            dateFormatter.dateFormat = "d"
            let startDateString = "\(dateFormatter.string(from: newDate! ))"
            dateFormatter.dateFormat = "d MMMM yyyy"
            let endDateString = "\(dateFormatter.string(from: endDate))"
            
            dateField.text = "\(startDateString) - \(endDateString)"
            
            if id == 1 {
                minggu(date: newDate!, jenis: 0)
                minggu(date: newDate!, jenis: 1)
            }else if id == 2{
                minggu(date: newDate!, jenis: 2)
            }
            
            
        }else{
            newDate = calendarHelper.calendar.date(byAdding: .month, value: dateController, to: today)!
        
            var startOfMonth = calendarHelper.firstOfMonth(date: newDate!)
            let endOfMonth =  calendarHelper.addDays(date: calendarHelper.plusMonth(date: startOfMonth), days: -1)
            
            print("startOfMonth ==> \(startOfMonth.description(with: .current))\n endOfMonth ==> \(endOfMonth.description(with: .current))")
            
            let numberOfDays = calendarHelper.calendar.dateComponents([.day], from: startOfMonth, to: endOfMonth).day! + 1
            
            print("numberOfDays \(numberOfDays)")
            
            dateFormatter.dateFormat = "MMMM yyyy"
            let startDateString = "\(dateFormatter.string(from: startOfMonth))"
            
            dateField.text = "\(startDateString)"
            
            lineChartView = setupMonthView(chartView: lineChartView, numberOfDays: numberOfDays)
            
            if id == 1 {
                bulan(numberOfDays: numberOfDays, date: startOfMonth, jenis: 0)
                bulan(numberOfDays: numberOfDays, date: startOfMonth, jenis: 1)
            }else if id == 2{
                bulan(numberOfDays: numberOfDays, date: startOfMonth, jenis: 2)
            }
        }
        
        setData()
        
        tableView.reloadData()
    }
    
    func ratarata() -> Double {
        var total = 0.0
        var count = 0
        for data in chartDataEntries{
            total += data.y
            count += 1
        }
        
        if count == 0{
            return 0
        }
        
        return total/Double(count)
    }
    
    func range() -> String {
        var range = ""
        var low = 999.0
        var high = -999.0
        for data in chartDataEntries{
            if data.y < low {
                low = data.y
            }
            if data.y > high {
                high = data.y
            }
        }
        
        if low == high{
            range = "\(low)"
        }else{
            range = "\(low)-\(high)"
        }
        
        if chartDataEntries.isEmpty{
            range = "-"
        }
    
        return range
    }
    
    func hari(date: Date, jenis: Int16){
        for log in coredatamanager.fetchBGLogSelectedDate(date: date, jenis: jenis){
            
            if let bgResult = Double(log.bg_check_result!){
                if bgResult == -1{
                    continue
                }
                
                var minutes = 0.0
                minutes += Double(String(log.time![0]))! * 600
                
                minutes += Double(String(log.time![1]))! * 60
                minutes += Double(String(log.time![3]))!
                minutes += Double(String(log.time![4]))!
                
                print("dapong-chartdata \(minutes)")
                
                chartDataEntries.append(ChartDataEntry(x: minutes, y: bgResult))
            }
        }
    }
    
    func minggu(date: Date, jenis: Int16){
        var newDate = date
        for i in 0...6{
            for log in coredatamanager.fetchBGLogSelectedDate(date: newDate, jenis: jenis){
                
                if let bgResult = Double(log.bg_check_result!){
                    if bgResult == -1{
                        continue
                    }
                    
                    chartDataEntries.append(ChartDataEntry(x: Double(i), y: bgResult))
                }
            }
            newDate = calendarHelper.addDays(date: newDate, days: 1)
        }
    }
    
    func bulan(numberOfDays: Int, date: Date, jenis: Int16){
        var startOfMonth = date
        for i in 0...numberOfDays-1{
            for log in coredatamanager.fetchBGLogSelectedDate(date: startOfMonth, jenis: jenis){
                
                if let bgResult = Double(log.bg_check_result!){
                    if bgResult == -1{
                        continue
                    }
                    chartDataEntries.append(ChartDataEntry(x: Double(i+1), y: bgResult))
                }
            }
            startOfMonth = calendarHelper.addDays(date: startOfMonth, days: 1)
        }
    }
}
