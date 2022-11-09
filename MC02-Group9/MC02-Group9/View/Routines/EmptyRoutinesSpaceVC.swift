//
//  EmptyRoutinesSpaceVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 06/10/22.
//

//import FoundatioN
import UIKit

class EmptyRoutinesSpaceVC: UIViewController {
    @IBOutlet weak var routineBtn: UIButton!
    
    @IBAction func addRoutinesBtn(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Apa yang ingin kamu tambahkan?", message: nil, preferredStyle: .actionSheet)
        let actJadwalMinumObat = UIAlertAction(title: "Jadwal Minum Obat", style: .default) { _ in
            self.performSegue(withIdentifier: "addMedicationViewController", sender: nil)
        }
        let actJadwalCekGulaDarah = UIAlertAction(title: "Jadwal Cek Gula Darah", style: .default){ _ in
            self.performSegue(withIdentifier: "addBGViewController", sender: nil)
        }
//        let actInputHasilGulaDarah = UIAlertAction(title: "Input Hasil Gula Darah", style: .default)
        let actBatal = UIAlertAction(title: "Batal", style: .cancel)
        actionSheet.addAction(actJadwalMinumObat)
        actionSheet.addAction(actJadwalCekGulaDarah)
//        actionSheet.addAction(actInputHasilGulaDarah)
        actionSheet.addAction(actBatal)
//        print("user roles", userRoles.userRole)
        present(actionSheet, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableHidden), name: NSNotification.Name(rawValue: "hidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unableHidden), name: NSNotification.Name(rawValue: "unhidden"), object: nil)
        view.backgroundColor = .systemGroupedBackground
        routineBtn.tintColor = hexStringToUIColor(hex: "1E84C6")
        
    }
    
    @objc func enableHidden(){
        view.frame = self.view.bounds
        view.isHidden = true
    }
    
    @objc func unableHidden(){
        view.frame = self.view.bounds
        view.isHidden = false
    }
    
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
}

