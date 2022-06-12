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
    
    let cellTitle = ["Nama Obat", "Waktu Minum", "Frekuensi Minum"]
    let textFieldShadow = ["Misal: Metformin 250g", "Misal: sebelum makan", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let nibName = UINib(nibName: "TextFieldTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "textFieldTableViewCell")
        let nibNamePicker = UINib(nibName: "PickerTableViewCell", bundle: nil)
        tableView.register(nibNamePicker, forCellReuseIdentifier: "pickerTableViewCell")
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
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
            cell.cell1NameLabel.text = cellTitle[indexPath.row]
            cell.cell1TextField?.placeholder = textFieldShadow[indexPath.row]
            return cell
        } else if (indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "pickerTableViewCell", for: indexPath) as! PickerTableViewCell
            cell.cell2NameLabel.text = cellTitle[indexPath.row]
            return cell
        } else {
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
