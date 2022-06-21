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
        print("mealVars", mealVars.mealPickedRow)
        mealTimeLabel.resignFirstResponder()
        
    }
    // Dismiss when done clicked
    @objc func btnDoneClicked(){
        self.endEditing(true)
    }
}
//    @IBAction public func addRow(_ sender: UIPickerView){
//        if (mealVars.mealPickedRow != 4) {
//            print("triggered")
//            self.tableView.performBatchUpdates({
//                self.tableView.insertRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
//            }, completion: nil)
//        }

struct mealVars {
    static var mealPickedRow = 4
    
}
public func findIndex() {
    
}
