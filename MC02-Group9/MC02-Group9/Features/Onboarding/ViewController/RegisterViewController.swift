//
//  LoginViewController.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 26/10/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

  // MARK: - UI Properties
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var pass: UITextField!
  @IBOutlet weak var msg: UILabel!
  @IBOutlet weak var role: UISegmentedControl!
  @IBOutlet weak var registerBtn : UIButton!
  @IBOutlet weak var nama: UITextField!
  @IBAction func register(_ sender: Any) {
    if let _email = email.text,
       let _pass = pass.text,
       let _nama = nama.text {

      let authCredential = AuthCredentials(email: _email, password: _pass, fullname: _nama)
      AuthService.shared.registerUser(credentials: authCredential) { [weak self] error, _ in
        guard let self = self else { return }
        if let error = error {
          self.msg.text = "\(error.localizedDescription)"
          print(error.localizedDescription)
        }else {
          print("success")
          self.navigator.navigateToVerificationFromRegister(from: self)
        }
      }
    }
  }

  // MARK: - Properties
  private let navigator = DefaultOnboardingNavigator()

  // MARK: - Lifecycles
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    registerBtn.tintColor = hexStringToUIColor(hex: "1E84C6")
  }

}
