//
//  EmptySpaceViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 22/06/22.
//

import UIKit

class EmptySpaceViewController: UIViewController {
    
    let role = RoleHelper.instance.getRole()
    @IBOutlet weak var medBtn:UIButton!
    
    @IBAction func addMedBtn(_ sender: UIButton) {
        if (role == 1){
            let actionSheet = UIAlertController(title: "Apa yang ingin kamu tambahkan?", message: nil, preferredStyle: .actionSheet)
            let actJadwalMinumObat = UIAlertAction(title: "Jadwal Minum Obat", style: .default) { _ in
                self.performSegue(withIdentifier: "addMedicationViewController", sender: nil)
            }
            let actJadwalCekGulaDarah = UIAlertAction(title: "Jadwal Cek Gula Darah", style: .default){ _ in
                self.performSegue(withIdentifier: "addBGViewController", sender: nil)
            }
//            let actInputHasilGulaDarah = UIAlertAction(title: "Input Hasil Gula Darah", style: .default)
            let actBatal = UIAlertAction(title: "Batal", style: .cancel)
            actionSheet.addAction(actJadwalMinumObat)
            actionSheet.addAction(actJadwalCekGulaDarah)
//            actionSheet.addAction(actInputHasilGulaDarah)
            actionSheet.addAction(actBatal)
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var textBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        medBtn.tintColor = hexStringToUIColor(hex: "1E84C6")
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableHidden), name: NSNotification.Name(rawValue: "hidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unableHidden), name: NSNotification.Name(rawValue: "unhidden"), object: nil)
//        view.isHidden = true
        // Do any additional setup after loading the view.
        
        if(role == 1){
            textLbl.text = "Belum ada rutinitas."
            textBtn.setTitle("Tambah Rutinitas", for: .normal)
            textLbl.textAlignment = .center
        }else if (role == 2){ //nanti kasih kondisi && jika belum konek
            textLbl.text = "Anda belum tersambung dengan keluarga\natau\nbelum ada rutinitas."
            textBtn.isHidden = true
//            textBtn.setTitle("Hubungkan Keluarga", for: .normal)
            textLbl.textAlignment = .center
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
