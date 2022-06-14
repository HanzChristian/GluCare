//
//  TimePickerTableViewCell.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 13/06/22.
//

import UIKit

class TimePickerTableViewCell: UITableViewCell{
    
   
    weak var delegate: AddMedicationViewController?
    @IBOutlet weak var lblTimePicker: UILabel!
    @IBOutlet weak var btnTimePicker: UITextField!
    let time = Date()
    let formatter = DateFormatter()
    let timePicker = UIDatePicker()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "HH:mm"
        btnTimePicker.text = formatter.string(from: time)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(btnDoneClicked))
        toolbar.items = [doneBtn]
        btnTimePicker.inputAccessoryView = toolbar
        
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timePickerValueChange(sender:)), for: UIControl.Event.valueChanged)
        timePicker.frame.size = CGSize(width: 0, height: 250)
        timePicker.preferredDatePickerStyle = .wheels
        
        btnTimePicker.inputView = timePicker
    }
    
    @objc func timePickerValueChange(sender: UIDatePicker){
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "HH:mm"
        
        btnTimePicker.text = formatter.string(from: sender.date)
    }
    
    @objc func btnDoneClicked(){
        self.endEditing(true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}



