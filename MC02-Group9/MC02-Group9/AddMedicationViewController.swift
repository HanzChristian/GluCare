//
//  AddMedicationViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 08/06/22.
//

import UIKit

class AddMedicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate {
    @IBOutlet var tableView: UITableView!
    //var pickerView = UIPickerView()
    
    let cellTitle = ["Nama Obat", "Waktu Minum", "Jadwal Minum Obat"]

        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self

            
            let nibName = UINib(nibName: "MedNameTextFieldTVC", bundle: nil)
            tableView.register(nibName, forCellReuseIdentifier: "medNameTextFieldTVC")
            let nibNamePicker = UINib(nibName: "MealTimePickerTableViewCell", bundle: nil)
            tableView.register(nibNamePicker, forCellReuseIdentifier: "mealTimePickerTableViewCell")
            let nibSchedulePicker = UINib(nibName: "SchedulePickerTableViewCell", bundle: nil)
            tableView.register(nibSchedulePicker, forCellReuseIdentifier: "schedulePickerTableViewCell")
            let nibAddNewSchedulePicker = UINib(nibName: "AddNewScheduleTableViewCell", bundle: nil)
            tableView.register(nibAddNewSchedulePicker, forCellReuseIdentifier: "addNewScheduleTableViewCell")
            
            
            view.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
            tableView.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
            
            setNavItem()
            self.hideKeyboard()
        }
        
        
        //tableviewfunction
        func numberOfSections(in tableView: UITableView) -> Int {
            return 3
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if (section == 1 || section == 2) {
                return 2
            } else{
                return 1
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //logic if-else mod2

            
            if(indexPath.section == 0){
                // SECTION 1

                if (indexPath.row == 0) {
                // SECTION 1 ROW 1
                let cell = tableView.dequeueReusableCell(withIdentifier: "medNameTextFieldTVC", for: indexPath) as! MedNameTextFieldTVC
                cell.medNameTextField?.placeholder = "Misal: Metformin 250g"
                cell.backgroundColor = hexStringToUIColor(hex: "#FAFAFA")
                return cell
                }
                
                
            } else if (indexPath.section == 1){
                // SECTION 2
                
                if (indexPath.row == 0){
                    // SECTION 2 ROW 1
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "mealTimePickerTableViewCell", for: indexPath) as! MealTimePickerTableViewCell
                    cell.mealTimeLabel.text = "Pilih waktu minum"
                    cell.mealTimeLabel.textColor = hexStringToUIColor(hex: "#A0A4A8")
                    cell.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
                    
                    return cell
                    
                } else if (indexPath.row == 1){
                    // SECTION 2 ROW 2 (Keterangan Waktu)
                }
                
            } else if (indexPath.section == 2){
                // SECTION 3
                
                if (indexPath.row == 0){
                    // SECTION 3 ROW 1
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "schedulePickerTableViewCell", for: indexPath) as! SchedulePickerTableViewCell
                    cell.mealTimeLabel.text = "Jadwal 1"
                    cell.delegate = self // To add super view to cell
                    cell.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
                    return cell
                    
                } else if (indexPath.row == 1){
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "addNewScheduleTableViewCell", for: indexPath) as! AddNewScheduleTableViewCell
                    cell.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
                    return cell
                }
//                } else {
//
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "schedulePickerTableViewCell", for: indexPath) as! SchedulePickerTableViewCell
//                    cell.mealTimeLabel.text = "Jadwal \(indexPath.row)"
//                    cell.delegate = self // To add super view to cell
//                    cell.backgroundColor = hexStringToUIColor(hex: "FAFAFA")
//                    return cell
//
//                    tableView.beginUpdates()
//                    tableView.insertRowsAtIndexPaths([
//                        NSIndexPath(forRow: indexPath.row-1, inSection: 2)], withRowAnimation: .Automatic)
//                    tableView.endUpdates()
//                }
                
            }
            return UITableViewCell()
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: false)
            if let cell = tableView.cellForRow(at: indexPath) as? MealTimePickerTableViewCell {
              if !cell.isFirstResponder {
                _ = cell.becomeFirstResponder()
              }
             }
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60.0
        }
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()

            let sectionLabel = UILabel(frame: CGRect(x: 19, y: 0, width:
                tableView.bounds.size.width, height: 30))
            sectionLabel.font = UIFont(name: "Helvetica Neue", size: 16)
            sectionLabel.textColor = UIColor.black
            sectionLabel.text = cellTitle[section]
            sectionLabel.sizeToFit()
            headerView.addSubview(sectionLabel)

            return headerView
        }

        //end of tableview function
        
        
        private func setNavItem(){
            navigationController?.navigationBar.prefersLargeTitles = true
            
            navigationItem.title = "Tambah Jadwal Obat"
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(saveItem))
        }
        
        // Function buat pake hex color
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
        
        @objc private func dismissSelf(){
            dismiss(animated: true, completion: nil)
        }
        
        @objc private func saveItem(){
            // Tambahin logic save disini
            
            tableView
            
            dismiss(animated: true, completion: nil)
        }
        
    }

    extension UIViewController {
        func hideKeyboard() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissView))
            tap.cancelsTouchesInView = false
            
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissView() {
            view.endEditing(true)
        }
    
}
