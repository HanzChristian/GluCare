//
//  PickerTableViewCell.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 11/06/22.
//

import UIKit

class PickerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var cell2NameLabel: UILabel!
    @IBOutlet var cell2PickerView: UIPickerView!
    let mealTime = ["1 Jam Sebelum Makan", "30 Menit Sebelum Makan","Dengan Makan",
                    "30 Menit Setelah Makan", "1 Jam Setelah Makan"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cell2PickerView.dataSource = self
        cell2PickerView.delegate = self

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mealTime.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mealTime[row]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        40
    }
}


