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
    
    var roles = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmBtn.layer.cornerRadius = 10
        confirmBtn.backgroundColor = .gray
        confirmBtn.isEnabled = false
        validateForm()
        youAreLbl.font = .rounded(ofSize: 28, weight: .semibold)
    }
    
    @IBAction func didTapCardPBtn(_ sender: UIButton) {
        patientCardBtn.setImage(UIImage(named: "card-patient-click"), for: .normal)
        caregiverCardBtn.setImage(UIImage(named: "card-caregiver"), for: .normal)
        confirmBtn.backgroundColor = .systemBlue
        roles = 1
        validateForm()
    }
    
    @IBAction func didTapCardCBtn(_ sender: UIButton) {
        patientCardBtn.setImage(UIImage(named: "card-patient"), for: .normal)
        caregiverCardBtn.setImage(UIImage(named: "card-caregiver-click"), for: .normal)
        confirmBtn.backgroundColor = .systemBlue
        roles = 2
        validateForm()
    }
    
    @IBAction func didTapConfirmBtn(_ sender: UIButton) {
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Yakin dengan peranmu?", message: "Apabila telah memilih, pilihanmu tidak dapat diubah lagi", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Kembali", style: .cancel, handler: { action in
            print("tapped kembali")
        }))
        
        alert.addAction(UIAlertAction(title: "Ya", style: .default, handler: { action in
            print("tapped Ya")
            print("self.roles ", self.roles)
            userRoles.userRole = self.roles
            print(userRoles.userRole, "user roles")
            self.performSegue(withIdentifier: "goToMain", sender: self)
        }))
        
        present(alert, animated: true)
    }
    
    @objc func validateForm(){
        if (self.roles != 0) {
            confirmBtn.isEnabled = true
        }
    }
}

struct userRoles {
    static var userRole = 0
}




