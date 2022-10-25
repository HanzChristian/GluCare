//
//  RoleManagementVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 24/10/22.
//

import UIKit

class RoleManagementVC: UIViewController {
    @IBOutlet weak var youAreLbl: UILabel!
    @IBOutlet weak var patientCardBtn: UIButton!
    @IBOutlet weak var caregiverCardBtn: UIButton!
    @IBOutlet weak var warningImg: UIImageView!
    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTapCardPBtn(_ sender: UIButton) {
        patientCardBtn.setImage(UIImage(named: "card-patient-click"), for: .normal)
        caregiverCardBtn.setImage(UIImage(named: "card-caregiver"), for: .normal)
    }
    
    @IBAction func didTapCardCBtn(_ sender: UIButton) {
        patientCardBtn.setImage(UIImage(named: "card-patient"), for: .normal)
        caregiverCardBtn.setImage(UIImage(named: "card-caregiver-click"), for: .normal)
    }
    
    @IBAction func didTapConfirmBtn(_ sender: Any) {
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Yakin dengan peranmu?", message: "Apabila telah memilih, pilihanmu tidak dapat diubah lagi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Kembali", style: .cancel, handler: { action in
            print("tapped kembali")
        }))
        
        alert.addAction(UIAlertAction(title: "Ya", style: .default, handler: { action in
            print("tapped kembali")
        }))
        
        present(alert, animated: true)
    }
    
    
    
}




