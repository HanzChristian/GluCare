//
//  BGTimeTableViewCell.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 11/10/22.
//

import UIKit

class BGTimeTableViewCell: UITableViewCell {
    
    weak var delegate: AddBGViewController?
        @IBOutlet var bgTimeLbl:UILabel!
        @IBOutlet var bgTimePicker: UITextField!
    let time = Date()
    let formatter = DateFormatter()
    let timePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Format Time
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "HH:mm"
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(btnDoneClicked))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.isUserInteractionEnabled = true
        toolBar.items = [space, doneBtn]
        bgTimePicker.inputAccessoryView = toolBar
        bgTimePicker.text = formatter.string(from: time)
        
        // Set Picker Mode
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timePickerValueChange(sender:)), for: UIControl.Event.valueChanged)
        timePicker.preferredDatePickerStyle = .wheels
        
        // Set Date Picker to Text Field
        bgTimePicker.inputView = timePicker
    }
    @objc func timePickerValueChange(sender: UIDatePicker){
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "HH:mm"
        
        bgTimePicker.text = formatter.string(from: sender.date)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "formValidate"), object: nil)
    }
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
