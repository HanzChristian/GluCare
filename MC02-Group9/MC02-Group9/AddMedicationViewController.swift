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
    
    let cellTitle = ["Nama Obat", "Waktu Minum","", "Frekuensi Minum"]
    let textFieldShadow = ["Misal: Metformin 250g", "Pilih Waktu Minum", "", ""]
    //class: MedDesc
    let mealTime = ["Waktu Spesifik", "Sebelum Makan", "Setelah Makan", "Bersamaan dengan Makan", "Pilih Waktu Minum"]
    let mealTimeDesc = ["Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat",
                    "Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat lalu makan",
                    "Notifikasi muncul 1 jam sebelum waktu yang ditentukan untuk makan lalu meminum obat",
                    "Notifikasi muncul 30 menit sebelum waktu yang ditentukan untuk meminum obat dan makan",
                    "Keterangan tentang notifikasi akan muncul setelah memilih waktu minum"]
    var newMealVars = 4
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("overr", mealVars.mealPickedRow)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let nibName = UINib(nibName: "MedNameTextFieldTVC", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "medNameTextFieldTVC")
        let nibNamePicker = UINib(nibName: "MealTimePickerTableViewCell", bundle: nil)
        tableView.register(nibNamePicker, forCellReuseIdentifier: "mealTimePickerTableViewCell")
        let nibMedDescPicker = UINib(nibName: "MedDescTableViewCell", bundle: nil)
        tableView.register(nibMedDescPicker, forCellReuseIdentifier: "medDescTableViewCell")
        let nibFrequencyPicker = UINib(nibName: "FrequencyPickerTableViewCell", bundle: nil)
        tableView.register(nibFrequencyPicker, forCellReuseIdentifier: "frequencyPickerTableViewCell")
        
        
        view.backgroundColor = .systemBackground
        
        setNavItem()
    }
    
    //tableviewfunction
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //logic if-else mod2
        print("AddMed TVC: mealVars", mealVars.mealPickedRow)
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "medNameTextFieldTVC", for: indexPath) as! MedNameTextFieldTVC
            cell.medNameLabel.text = cellTitle[indexPath.row]
            cell.medNameTextField?.placeholder = textFieldShadow[indexPath.row]
            return cell
        } else if (indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "mealTimePickerTableViewCell", for: indexPath) as! MealTimePickerTableViewCell
            cell.mealTimeLabel.text = cellTitle[indexPath.row]
            cell.mealTimeTextField?.placeholder = textFieldShadow[indexPath.row]
            return cell
        } else if (indexPath.row == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "medDescTableViewCell", for: indexPath) as! MedDescTableViewCell
            // mealVars.mealPickedRow
            cell.mealDescTitle.text = mealTime[mealVars.mealPickedRow]
            cell.mealDesc.text = mealTimeDesc[mealVars.mealPickedRow]
            cell.mealImage.image = UIImage(named: "MealDesc\(2)")
//            if (mealVars.mealPickedRow == 4) {
//                newMealVars = mealVars.mealPickedRow
//                print("newMeal", newMealVars)
//                tableView.reloadData()
//                mealVars.mealPickedRow = 5
//            }
            return cell
        } else {
            // tableView.reloadData()
            let cell = tableView.dequeueReusableCell(withIdentifier: "frequencyPickerTableViewCell", for: indexPath) as! FrequencyPickerTableViewCell
            cell.lblFrequency.text = cellTitle[indexPath.row]
            return cell
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //end of tableview function
    
    //pickerview function
    
    //end of pickerview function
    
    
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.tintColor = hexStringToUIColor(hex: "#D33F9A")
        
        navigationItem.title = "Tambah Jadwal Obat"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(dismissSelf))
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
        // Tambahin logic save disini
        
        dismiss(animated: true, completion: nil)
    }
    
}
