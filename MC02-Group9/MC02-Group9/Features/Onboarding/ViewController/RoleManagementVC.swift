//
//  RoleManagementVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 24/10/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RoleManagementVC: UIViewController {
  @IBOutlet weak var youAreLbl: UILabel!
  @IBOutlet weak var patientCardBtn: UIButton!
  @IBOutlet weak var caregiverCardBtn: UIButton!
  @IBOutlet weak var warningImg: UIImageView!
  @IBOutlet weak var warningLbl: UILabel!
  @IBOutlet weak var confirmBtn: UIButton!

  private let navigator = DefaultOnboardingNavigator()
  var blue = "1E84C6"
  var roleType: UserType?

  override func viewDidLoad() {
    super.viewDidLoad()
    confirmBtn.layer.cornerRadius = 10
    confirmBtn.setTitleColor(.white, for: .normal)
    confirmBtn.tintColor = .gray
    
    confirmBtn.isEnabled = false
    
    
    validateForm()
  }
  
  
  @IBAction func didTapCardPBtn(_ sender: UIButton) {
    patientCardBtn.setImage(UIImage(named: "card-patient-click"), for: .normal)
    caregiverCardBtn.setImage(UIImage(named: "card-caregiver"), for: .normal)
    confirmBtn.backgroundColor = hexStringToUIColor(hex: "1E84C6")
    roleType = .patient
    validateForm()
  }
  
  @IBAction func didTapCardCBtn(_ sender: UIButton) {
    patientCardBtn.setImage(UIImage(named: "card-patient"), for: .normal)
    caregiverCardBtn.setImage(UIImage(named: "card-caregiver-click"), for: .normal)
    confirmBtn.backgroundColor = hexStringToUIColor(hex: "1E84C6")
    roleType = .caregiver
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
    
    alert.addAction(UIAlertAction(title: "Ya", style: .default, handler: { [weak self] action in
      guard let self = self else { return }
      print("tapped Ya")
      self.navigator.navigateToContractFromRoleManagement(from: self, userType: roleType)
    }))
    
    present(alert, animated: true)
  }
  
  @objc func validateForm(){
    if (self.roleType != nil) {
      confirmBtn.isEnabled = true
    }
  }    
}





