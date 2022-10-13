//
//  BGSubFrequencyTableViewCell.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 11/10/22.
//

import UIKit

class BGSubFrequencyTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    @IBOutlet var bgSubFrequencyEveryLbl: UILabel!
    @IBOutlet var bgFrequencyLbl: UILabel!
    @IBOutlet var bgSubFrequencyDay: UILabel!
    
    let scheduleTime = ["Hari","Minggu","Bulan"]
    var days = [String]()
    

    let pickerView = UIPickerView()
    
    func giveArrayNumber(){
        for i in 1 ... 31{
            days.append(String(i))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgFrequencyLbl.textColor = .systemBlue
        bgSubFrequencyDay.textColor = .systemBlue
        giveArrayNumber()
        
        pickerView.dataSource = self
        pickerView.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "changeSub"), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var daysPickerView = UIPickerView()
    public var schedulePicked = false
    
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
        return days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return days[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bgSubFrequencyDay.textColor = .black
        bgSubFrequencyDay.text = days[row]
        schedulePicked = true
        daysVars.dayPickedRow = row
        bgSubFrequencyDay.resignFirstResponder()
        bgSubFrequencyDay.textColor = .systemBlue
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
    
    @objc func refresh(){
        bgFrequencyLbl.text = scheduleTime[scheduleTimeVar.row]
        super.setSelected(isSelected, animated: true)
    }
    
}

struct daysVars {
    static var dayPickedRow = 31
}
