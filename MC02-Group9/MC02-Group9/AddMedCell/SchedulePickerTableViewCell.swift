//
//  SchedulePickerTableViewCell.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 16/06/22.
//

import UIKit

class SchedulePickerTableViewCell: UITableViewCell {

    weak var delegate: AddMedicationViewController?
        @IBOutlet weak var mealTimeLabel: UILabel!
        @IBOutlet weak var btnTimePicker: UITextField!
        let time = Date()
        let formatter = DateFormatter()
        let timePicker = UIDatePicker()
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            
            // Format Time
            formatter.locale = Locale(identifier: "en_gb")
            formatter.dateFormat = "HH:mm"
            let toolBar = UIToolbar()
            toolBar.barStyle = .black
            toolBar.sizeToFit()
            let doneBtn = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(btnDoneClicked))
            toolBar.items = [doneBtn]
            toolBar.isUserInteractionEnabled = true
            btnTimePicker.inputAccessoryView = toolBar
            btnTimePicker.text = formatter.string(from: time)
            
            // Set Picker Mode
            timePicker.datePickerMode = .time
            timePicker.addTarget(self, action: #selector(timePickerValueChange(sender:)), for: UIControl.Event.valueChanged)
            timePicker.preferredDatePickerStyle = .wheels
            
            // Set Date Picker to Text Field
            btnTimePicker.inputView = timePicker
        }
        
        // Change Text Field on Value Changed
        @objc func timePickerValueChange(sender: UIDatePicker){
            formatter.locale = Locale(identifier: "en_gb")
            formatter.dateFormat = "HH:mm"
            
            btnTimePicker.text = formatter.string(from: sender.date)
        }
        
        // Dismiss when done clicked
        @objc func btnDoneClicked(){
            self.endEditing(true)
        }
        
        func hexStringToUIColor (hex:String) -> UIColor {
            var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }

            if ((cString.count) != 6) {
                return UIColor.gray
            }

            var rgbValue:UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)

            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    
}
