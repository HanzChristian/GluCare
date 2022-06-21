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
    let toolbarMD = UIToolbar().toolbarPicker(select: #selector(dismissPicker))
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.dataSource = self
        pickerView.delegate = self
//        self.pickerView.inputAccessoryView = toolbarMD
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender: )))
        pickerView.addGestureRecognizer(gesture)
        
//        mealTimeLabel.inputAccessoryView = toolbar
    }

    
    var mealPickerView = UIPickerView()
    public var mealPicked = false

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
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
    
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
        mealVars.mealPickedRow = row
        mealTimeLabel.resignFirstResponder()
    }
    
    @objc func doneTapped() {
        pickerView.endEditing(true)
    }
    
    @objc func cancelTapped() {
        mealTimeLabel.text = "Pilih Waktu Minum"
        pickerView.endEditing(true)
    }
    
    // Dismiss when done clicked
    @objc func dismissPicker() {
        self.endEditing(true)
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        pickerView.endEditing(true)
    }
}

extension UIToolbar {
    func toolbarPicker(select: Selector) -> UIToolbar {
        let toolbarMD = UIToolbar()
        toolbarMD.sizeToFit()
        toolbarMD.barStyle = .default
        toolbarMD.tintColor = UIColor.systemBlue
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: select)
 //       let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbarMD.setItems([space, doneBtn], animated: true)
        toolbarMD.isUserInteractionEnabled = true
        
        return toolbarMD
    }
}

struct mealVars {
    static var mealPickedRow = 4
    
}
