//
//  BGFrequencyTableViewCell.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 11/10/22.
//

import UIKit

class BGFrequencyTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var bgFrequencyLbl:UILabel!
    @IBOutlet var bgFrequencyScheduleLbl:UILabel!
    
    let scheduleTime = ["Hari","Minggu"]
    let pickerView = UIPickerView()
    var pickedFreq = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(0, inComponent: 0, animated: false)
        bgFrequencyScheduleLbl.textColor = UIColor.gray
    }
    
    var schedulePickerView = UIPickerView()
    public var schedulePicked = false
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
    
    override var inputAccessoryView: UIView?{
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.isUserInteractionEnabled = true
        toolBar.items = [space, doneBtn]
        return toolBar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return scheduleTime.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return scheduleTime[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bgFrequencyScheduleLbl.textColor = .black
        bgFrequencyScheduleLbl.text = scheduleTime[row]
        
        if(bgFrequencyScheduleLbl.text == "Hari"){
            pickedFreq = 0
        }
        else if(bgFrequencyScheduleLbl.text == "Minggu"){
            pickedFreq = 1
        }else{
            pickedFreq = 2
        }
        bgFrequencyScheduleLbl.textColor = UIColor.gray
        schedulePicked = true
        scheduleVars.schedulePickedRow = row
        scheduleTimeVar.row = row
        print("INI BG FREQNYA = \(scheduleVars.schedulePickedRow)")
        
        bgFrequencyScheduleLbl.resignFirstResponder()
        //ngubah label di sub frequency
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeSub"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "formValidate"), object: nil)
        if(bgFrequencyScheduleLbl.text == "Hari"){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calendarOff"), object: nil)
        }
        else{
            if(bgFrequencyScheduleLbl.text == "Minggu"){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calendarOn"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "narrowCalendar"), object: nil)
            }
            else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calendarOn"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "wideCalendar"), object: nil)
            }
        }
        //melakukan validasi total
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "formValidate"), object: nil)
    }
    
    @objc func doneTapped() {
        self.endEditing(true)
    }
    
    @objc func dismissPicker() {
        self.endEditing(true)
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        pickerView.endEditing(true)
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        if (pickerView.isHidden == true){
            pickerView.isHidden = false
        }
    }
}

struct scheduleVars {
    static var schedulePickedRow = 3
}
