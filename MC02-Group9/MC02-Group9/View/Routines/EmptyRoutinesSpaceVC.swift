//
//  EmptyRoutinesSpaceVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 06/10/22.
//

//import FoundatioN
import UIKit

class EmptyRoutinesSpaceVC: UIViewController {
    
    @IBAction func addRoutinesBtn(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Apa yang ingin kamu tambahkan?", message: nil, preferredStyle: .actionSheet)
        let actJadwalMinumObat = UIAlertAction(title: "Jadwal Minum Obat", style: .default) { _ in
            self.performSegue(withIdentifier: "addMedicationViewController", sender: nil)
        }
        let actJadwalCekGulaDarah = UIAlertAction(title: "Jadwal Cek Gula Darah", style: .default){ _ in
            self.performSegue(withIdentifier: "addBGViewController", sender: nil)
        }
        let actInputHasilGulaDarah = UIAlertAction(title: "Input Hasil Gula Darah", style: .default)
        let actBatal = UIAlertAction(title: "Batal", style: .cancel)
        actionSheet.addAction(actJadwalMinumObat)
        actionSheet.addAction(actJadwalCekGulaDarah)
        actionSheet.addAction(actInputHasilGulaDarah)
        actionSheet.addAction(actBatal)
        present(actionSheet, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableHidden), name: NSNotification.Name(rawValue: "hidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unableHidden), name: NSNotification.Name(rawValue: "unhidden"), object: nil)
    }
    
    @objc func enableHidden(){
        view.frame = self.view.bounds
        view.isHidden = true
    }
    
    @objc func unableHidden(){
        view.frame = self.view.bounds
        view.isHidden = false
    }
}

