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
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var msg: UILabel!
    @IBOutlet weak var role: UISegmentedControl!
    @IBOutlet weak var registerBtn : UIButton!
    
    @IBOutlet weak var nama: UITextField!
    
    
    @IBAction func login(_ sender: Any) {
        if let email = email.text, let pass = pass.text {
            Auth.auth().signIn(withEmail: email, password: pass){ [weak self] authResult, error in
                
                if let e = error {
                    self!.msg.text = "\(e.localizedDescription)"
                }else{
                    self!.msg.text = "login berhasil"
                    // make segue
                    self!.performSegue(withIdentifier: "login", sender: self)
                }
            }
        }
    }
    
    @IBAction func register(_ sender: Any) {
        print("register tapped")
        if let email = email.text, let pass = pass.text {
            Auth.auth().createUser(withEmail: email, password: pass){ [weak self] authResult, error in
                if let e = error{
                    print(e)
                    self!.msg.text = "\(e.localizedDescription)"
                    print("gagal buat akun")
                }else{
                    self!.msg.text = "register berhasil"
                    
                    if  let user = Auth.auth().currentUser?.email,
                        let nama = self!.nama.text, nama != ""
                        {
                        print(user)
                        
                        let roleUserDefault = UserDefaults.standard.integer(forKey: "role") - 1
//                        "roleId": self!.role.selectedSegmentIndex
                        self!.db.collection("account").addDocument(data: [
                            "roleId": roleUserDefault,
                            "nama": "\(nama)",
                            "owner": "\(user)"
                        ]){ (error) in
                            if let e = error {
                                print("failed saved data \(e)")
                            }else{
                                print("success saved data")
                                // make segue
                                FirebaseManager.firebaseManager.getAccountInfo()
                                DispatchQueue.main.asyncAfter(deadline: .now()){
                                    if email.count > 5 && pass.count > 5 {
                                        
                                    }
                                    
                                    self!.performSegue(withIdentifier: "daftar", sender: self)
                                    print("Already Login")

                                }
                                
                            }
                        }
                    }
                    
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
                    self.performSegue(withIdentifier: "masuk2", sender: self)
                    print("Already Login")
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        alreadyLogin()
        registerBtn.tintColor = hexStringToUIColor(hex: "1E84C6")
        // Do any additional setup after loading the view.
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
