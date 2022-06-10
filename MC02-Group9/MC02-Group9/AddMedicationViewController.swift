//
//  AddMedicationViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 08/06/22.
//

import UIKit

class AddMedicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    let cellTitle = ["Nama Obat", "Waktu Minum"]
    let textFieldShadow = ["Misal: Metformin 250g", "Misal: sebelum makan"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "TextFieldTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "cell1")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        view.backgroundColor = .systemBackground
        
        setNavItem()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TextFieldTableViewCell
        cell.cell1NameLabel.text = cellTitle[indexPath.row]
        cell.cell1TextField?.placeholder = textFieldShadow[indexPath.row]
        cell.cell1TextField.isSecureTextEntry = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
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
