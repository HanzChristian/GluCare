//
//  MedDescTableViewCell.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 15/06/22.
//

import UIKit

class MedDescTableViewCell: UITableViewCell {
    
    @IBOutlet var mealDescTitle: UILabel!
    @IBOutlet var mealDesc: UILabel!
    @IBOutlet var mealImage: UIImageView!
    
    let mealTime = ["Waktu Spesifik", "Sebelum Makan", "Setelah Makan", "Bersamaan dengan Makan"]
    let mealTimeDesc = ["Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat",
                    "Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat lalu makan",
                    "Notifikasi muncul 1 jam sebelum waktu yang ditentukan untuk makan lalu meminum obat",
                    "Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat dan makan"]


    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "selectTime"), object: nil)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func refresh(){
        mealDescTitle.text = mealTime[mealTimeVar.row]
        mealDesc.text = mealTimeDesc[mealTimeVar.row]
        mealImage.image = UIImage(named: "MealDesc\(mealTimeVar.row)")
        super.setSelected(isSelected, animated: true)
    }
    
}
