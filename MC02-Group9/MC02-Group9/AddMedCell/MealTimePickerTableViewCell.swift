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
//        self.pickerView.inputAccessoryView = toolbarMD
        
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender: )))
//        pickerView.addGestureRecognizer(gesture)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 392, height: 80)) //cons belum dari frame
        toolBar.barStyle = UIBarStyle.default
        toolBar.tintColor = UIColor.systemBlue
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped(sender:)))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(sender:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([cancelBtn, space, doneBtn], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.pickerView.addSubview(toolBar)
//        pickerView.inputAccessoryView = toolBar
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
        //mealTimeLabel.resignFirstResponder()
    }
    
    @objc func doneTapped(sender: UIBarButtonItem) {
        print("done tapped")
        mealTimeLabel.resignFirstResponder()
        pickerView.resignFirstResponder()
        
    }
    
    @objc func cancelTapped(sender: UIBarButtonItem) {
        mealTimeLabel.text = "Pilih Waktu Minum"
        print("cancel tapped")
        mealTimeLabel.resignFirstResponder()
        pickerView.resignFirstResponder()
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
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = .default
        toolBar.tintColor = UIColor.systemBlue
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: select)
 //       let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([space, doneBtn], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}

struct mealVars {
    static var mealPickedRow = 4
    
}
