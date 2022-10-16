//
//  BGStartDateTableViewCell.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 11/10/22.
//

import UIKit

class BGStartDateTableViewCell: UITableViewCell {
    
    weak var delegate: BGStartDateTableViewCell?
        @IBOutlet var bgStartDateLbl:UILabel!
        @IBOutlet var bgStartDatePicker: UITextField!
    
    let currentTime = Date()
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currentDate()
        createDatePicker()
    }
    
    func createToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(btnDoneClicked))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.isUserInteractionEnabled = true
        toolBar.items = [space, doneBtn]
        return toolBar
    }
    
    func currentDate() {
        dateFormatter.locale = Locale(identifier: "en_gb")
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        bgStartDatePicker.text = dateFormatter.string(from: currentTime)
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerValueChange(sender:)), for: UIControl.Event.valueChanged)
        bgStartDatePicker.inputView = datePicker
        bgStartDatePicker.inputAccessoryView = createToolbar()
    }
  
    @objc func datePickerValueChange(sender: UIDatePicker) {
        dateFormatter.locale = Locale(identifier: "en_gb")
        //dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        bgStartDatePicker.text = dateFormatter.string(from: sender.date)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "formValidateNotif"), object: nil)
        
    }
  
    @objc func btnDoneClicked(){
//        self.bgStartDatePicker.text = dateFormatter.string(from: datePicker.date)
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
