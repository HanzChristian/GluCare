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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var msgLabel: UILabel!
    @IBAction func masukBtn(_ sender: Any) {
        if let email = emailTextField.text, let pass = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: pass){ [weak self] authResult, error in
                
                if let e = error {
                    self!.msgLabel.text = "\(e.localizedDescription)"
                }else{
                    self!.msgLabel.text = "login berhasil"
                    // make segue
                }
            }
        }
    }
    
    func alreadyLogin(){
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                
                // User is signed in. Show home screen
                FirebaseManager.firebaseManager.getAccountInfo()
                DispatchQueue.main.asyncAfter(deadline: .now()){
                    self.performSegue(withIdentifier: "masuk", sender: self)
                    print("Already Login")
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alreadyLogin()
    }
    
}
