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
        
        
        cell.configureCell(title: "Title", result: "110 mg/dl")
        
        return cell
    }
    
    
    
}
