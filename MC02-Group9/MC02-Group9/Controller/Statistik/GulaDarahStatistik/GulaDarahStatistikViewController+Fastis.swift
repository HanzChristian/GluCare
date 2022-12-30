//
//  GulaDarahStatistikViewController+Fastis.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 14/12/22.
//

import UIKit
import Fastis

extension GulaDarahStatistikViewController{
    @objc func chooseRange() {
        let fastisController = FastisController(mode: .range)
        fastisController.title = "Choose range"
        fastisController.minimumDate = Calendar.current.date(byAdding: .month, value: -24, to: Date())
        fastisController.maximumDate = Date()
        fastisController.allowToChooseNilDate = true
        fastisController.shortcuts = [.today, .lastWeek, .lastMonth]
        fastisController.doneHandler = { newValue in
            self.currentValue = newValue
        }
        fastisController.present(above: self)
    }
    
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        toolbar.setItems([space,doneBtn], animated: true)
        
        textField.textAlignment = .center
        // assign toolbar
        textField.inputAccessoryView = toolbar
        
        // assign datepicker
        textField.inputView = datePicker
        
        // date picker mode
        datePicker.datePickerMode = .date
        
        datePicker.preferredDatePickerStyle = .wheels
        
    }
    
    @objc func donePressed(){
        // formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        textField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
}
