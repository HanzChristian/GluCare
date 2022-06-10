//
//  AddMedicationViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 08/06/22.
//

import UIKit

class AddMedicationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setNavItem()
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
