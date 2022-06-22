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
        
        let screenWidth = UIScreen.main.bounds.size.width
//        let screenHeight = UIScreen.main.bounds.size.height
//        self.pickerView.inputAccessoryView = toolbar

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44)) //cons belum dari frame width392
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.systemBlue
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped(sender:)))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(sender:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([cancelBtn, space, doneBtn], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.pickerView.addSubview(toolBar)
//        self.pickerView.bringSubviewToFront(toolBar)
        guard let superview = pickerView.superview else { return }
        superview.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolBar.topAnchor.constraint(equalTo: superview.topAnchor),
            toolBar.leftAnchor.constraint(equalTo: superview.leftAnchor),
            toolBar.rightAnchor.constraint(equalTo: superview.rightAnchor),
            toolBar.bottomAnchor.constraint(equalTo: pickerView.topAnchor)
        ])
//        toolBar.isHidden = false
//        toolBar.becomeFirstResponder()
//        mealTimeLabel.inputAccessoryView = toolBar
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
    
    @objc func doneTapped(sender: UIBarButtonItem) {
        print("done tapped")
        resignFirstResponder()
        // updateMealDesc()
        self.endEditing(true)
        
    }
    
    @objc func cancelTapped(sender: UIBarButtonItem) {
        mealTimeLabel.text = "Pilih Waktu Minum"
        print("cancel tapped")
        //mealTimeLabel.resignFirstResponder()
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
