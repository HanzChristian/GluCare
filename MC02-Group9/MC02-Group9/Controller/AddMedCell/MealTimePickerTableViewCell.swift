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
    // x: 0, y: 200, width: UIScreen.main.bounds.size.width, height: 300
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.dataSource = self
        pickerView.delegate = self

    }

    
    var mealPickerView = UIPickerView()
    public var mealPicked = false

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
        //toolBar.barStyle = .black
        let doneBtn = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        //let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.isUserInteractionEnabled = true
        toolBar.items = [space, doneBtn]
        return toolBar
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
//        mealTimeTextField.text = mealTime[row]
        mealPicked = true
        mealTimeVar.row = row
        mealVars.mealPickedRow = row
        mealTimeLabel.resignFirstResponder()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectTime"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "formValidateNotif"), object: nil)

    }
    
    @objc func doneTapped() {
        self.endEditing(true)
    }
    
    @objc func cancelTapped() {
        mealTimeLabel.text = "Pilih Waktu Minum"
        print("cancelTapped")
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectTime"), object: nil)
        self.endEditing(true)
    }
    
    // Dismiss when done clicked
    @objc func dismissPicker() {
        self.endEditing(true)
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        pickerView.endEditing(true)
    }
    
}

struct mealVars {
    static var mealPickedRow = 4
}
