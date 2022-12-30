//
//  GulaDarahStatistik+TableView.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 20/12/22.
//

import UIKit

extension GulaDarahStatistikViewController: UITableViewDelegate{
    
    
}

extension GulaDarahStatistikViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statisticsCell", for: indexPath) as! StatisticsTableViewCell
        
        var title = ""
        var result = ""
        
        if indexPath.row == 0 {
            title = "Range "
            result = range()
        }else if indexPath.row == 1 {
            title = "Rata-rata "
            
            let ratarata = ratarata()
            if Int(ratarata) == 0{
                result = "-"
            }else{
                result = "\(String(format: "%.1f", ratarata))"
            }
            
        }
        
        if id == 1{
            title += "Gula Darah "
        }else if id == 2{
            title += "HbA1c "
        }
        
        if selected == 0 {
            title += "Harian"
        }else if selected == 1 {
            title += "Mingguan"
        }else if selected == 2 {
            title += "Bulanan"
        }
        
        cell.configureCell(title: title, result: result,id: id!)
        
        return cell
    }
    
}
