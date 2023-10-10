//
//  ViewController+TableViewDelegate.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 24/10/22.
//

import Foundation
import UIKit

// MARK: - UITableViewDelegate
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    private func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        daySelected = totalSquares[indexPath.item]
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        /*
         Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
         09/12/2018                        --> MM/dd/yyyy
         09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
         Sep 12, 2:11 PM                   --> MMM d, h:mm a
         September 2018                    --> MMMM yyyy
         Sep 12, 2018                      --> MMM d, yyyy
         Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
         2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
         12.09.18                          --> dd.MM.yy
         10:41:02.112                      --> HH:mm:ss.SSS
         */
        
        // change format date to str
        let strDate = dateFormatter.string(from: daySelected)
        let strToday = dateFormatter.string(from: Date())
        
        // Start Of Day
        let calendar = NSCalendar.current
        
        let from = calendar.startOfDay(for: Date())
        let to = calendar.startOfDay(for: daySelected)
        
        // numberOfDaysBetween
        let numberOfDays = Calendar.current.dateComponents([.day], from: from, to: to).day
        
        if(strDate == strToday)
        {
            self.navigationItem.title = "Hari ini"
        }else if(numberOfDays == -1){
            self.navigationItem.title = "Kemarin"
        }else if(numberOfDays == 1){
            self.navigationItem.title = "Besok"
        }else{
            self.navigationItem.title = strDate
        }
        
        collectionView.reloadData()
        refresh()
    }
}

// MARK: - UITabBarControllerDelegate

extension ViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         let tabBarIndex = tabBarController.selectedIndex
         if tabBarIndex == 0 {
             DispatchQueue.main.async { [weak self] in
                 self!.navigationItem.title = "Hari ini"
                 daySelected = Date()
                 self!.setupWeekView()
                 self!.refresh()
                 self!.collectionView.scrollToItem(at: IndexPath(row: self!.indexSelected, section: 0), at: .centeredHorizontally, animated: false)
             }
         }
    }
}
