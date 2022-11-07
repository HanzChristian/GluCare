//
//  EmptySpaceViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 22/06/22.
//

import UIKit

class EmptySpaceViewController: UIViewController {
    
    let role = UserDefaults.standard.integer(forKey: "role")

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
        }else if (role == 2){ //nanti kasih kondisi && jika belum konek
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableHidden), name: NSNotification.Name(rawValue: "hidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unableHidden), name: NSNotification.Name(rawValue: "unhidden"), object: nil)
//        view.isHidden = true
        // Do any additional setup after loading the view.
        
        if(role == 1){
            textLbl.text = "Belum ada rutinitas."
            textBtn.setTitle("Tambah Rutinitas", for: .normal)
            textLbl.textAlignment = .center
        }else if (role == 2){ //nanti kasih kondisi && jika belum konek
            textLbl.text = "Anda belum tersambung dengan keluarga."
            textBtn.setTitle("Hubungkan Keluarga", for: .normal)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
