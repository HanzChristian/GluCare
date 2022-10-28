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

class LoginViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var msg: UILabel!
    @IBOutlet weak var role: UISegmentedControl!
    
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
                    
                    if let user = Auth.auth().currentUser?.email {
                        print(user)
                        self!.db.collection("role").addDocument(data: [
                            "roleId": self!.role.selectedSegmentIndex,
                            "owner": "\(user)"
                        ]){ (error) in
                            if let e = error {
                                print("e \(e)")
                            }else{
                                print("success saved data")
                            }
                        }
                    }
                    // make segue
                }
                
            }
        }
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }

}
