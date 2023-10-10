//
//  LoginViewController.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 01/11/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import RxSwift

class LoginViewController: UIViewController {

  private let navigator = DefaultOnboardingNavigator()
  private let disposeBag = DisposeBag()

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var msgLabel: UILabel!
  @IBOutlet weak var loginBtn: UIButton!
  @IBAction func masukBtn(_ sender: Any) {
    if let email = emailTextField.text, let pass = passwordTextField.text {
      Auth.auth().signIn(withEmail: email, password: pass){ [weak self] authResult, error in
        guard let self = self else { return }
        if let e = error {
          self.msgLabel.text = "\(e.localizedDescription)"
        }else{
          guard let user = Auth.auth().currentUser else{
            return
          }
          user.reload{ [weak self] error in
            guard let self = self else { return }
            switch user.isEmailVerified {
            case true:
              AuthService.shared.fetchUser(uid: user.uid).subscribe(onNext: { user in
                if user.caregiver == false && user.patient == false {
                  // MARK: Handle User that already verified but dont have role
                  self.navigator.navigateToRoleManagementFromLogin(from: self)
                }else {
                  // MARK: Handle User that completely registered
                  
                }
              }).disposed(by: disposeBag)
              break
            case false:
              // MARK: Handle User that already register but email is not verified
              self.navigator.navigateToVerificationFromLogin(from: self)
            }
          }
        }
      }
    }
  }

  @objc func goToMain(){
    CoreDataManager.coreDataManager.fromLogin = true
    self.performSegue(withIdentifier: "masuk", sender: self)
    print("Already Login")
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    loginBtn.tintColor = hexStringToUIColor(hex: "1E84C6")
    listCaregiver.caregiverList.removeAll()

    NotificationCenter.default.addObserver(self, selector: #selector(self.goToMain), name: NSNotification.Name(rawValue: "finishGetAccountInfo"), object: nil)
  }

}
