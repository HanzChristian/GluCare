//
//  PickerTableViewCell.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 11/06/22.
//

import UIKit

class MealTimePickerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    

    @IBOutlet var mealTimeLabel: UILabel!
        
    let mealTime = ["Waktu Spesifik", "Sebelum Makan",
                    "Setelah Makan", "Bersamaan dengan Makan"]
    
    
    let pickerView = UIPickerView()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.dataSource = self
        pickerView.delegate = self
        
    }
    
    var mealPickerView = UIPickerView()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override var canResignFirstResponder: Bool{
        return true
    }
    
    override var inputView: UIView? {
        return pickerView
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mealTimeLabel.textColor = .black
        mealTimeLabel.text = mealTime[row]
        
    }
    // Dismiss when done clicked
    @objc func btnDoneClicked(){
        self.endEditing(true)
    }
    
   
}



