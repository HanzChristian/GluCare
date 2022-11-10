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
    @IBOutlet weak var loginBtn: UIButton!
    
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
        hideKeyboardWhenTappedAround()
        loginBtn.tintColor = hexStringToUIColor(hex: "1E84C6")
        alreadyLogin()
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
