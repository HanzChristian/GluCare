//
//  ViewController+TableViewDataSource.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 24/10/22.
//

import Foundation
import UIKit

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print("dapong \(totalSquares.count)")
        return totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell

        let date = totalSquares[indexPath.item]
        cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))
        let dayOfWeek:String = CalendarHelper().dayOfWeek(date: date)
        print("my substring \(dayOfWeek)")
        let index = dayOfWeek.index(dayOfWeek.startIndex, offsetBy: 1)
        
        let blue = UIColor(red: 30/255, green: 132/255, blue: 198/255, alpha: 1)
        
        if dayOfWeek == "Monday" {
            cell.dayOfWeek.text = "S"
        }else if dayOfWeek == "Tuesday"{
            cell.dayOfWeek.text = "S"
        }else if dayOfWeek == "Wednesday"{
            cell.dayOfWeek.text = "R"
        }else if dayOfWeek == "Thursday"{
            cell.dayOfWeek.text = "K"
        }else if dayOfWeek == "Friday"{
            cell.dayOfWeek.text = "J"
        }else if dayOfWeek == "Saturday"{
            cell.dayOfWeek.text = "S"
        }else if dayOfWeek == "Sunday"{
            cell.dayOfWeek.text = "M"
        }
        cell.dayOfWeek.textColor = blue
        
        cell.dayOfMonth.backgroundColor = UIColor.white
        cell.dayOfMonth.layer.cornerRadius = 32/2
        cell.dayOfMonth.layer.masksToBounds = true
        
        if(date == daySelected)
        {
            cell.backgroundColor = blue
            cell.dayOfWeek.textColor = UIColor.white
            cell.layer.cornerRadius = 25
            
            cell.dayOfMonth.layer.borderWidth = 0
        }
        else
        {
            cell.backgroundColor = UIColor.white
            cell.dayOfMonth.backgroundColor = UIColor.white
            
            if(calendarManager.calendar.isDate(date, inSameDayAs: Date())){
                cell.dayOfMonth.layer.borderWidth = 2
                cell.dayOfMonth.layer.borderColor = CGColor(red: 211/255, green: 63/255, blue: 154/255, alpha: 1)
            }else{
                cell.dayOfMonth.layer.borderWidth = 0
            }
        }
        return cell
    }
}
