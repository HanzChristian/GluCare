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
                        self!.db.collection("account").addDocument(data: [
                            "roleId": self!.role.selectedSegmentIndex,
                            "nama": "\(nama)",
                            "owner": "\(user)"
                        ]){ (error) in
                            if let e = error {
                                print("failed saved data \(e)")
                            }else{
                                print("success saved data")
                                // make segue
                                self!.performSegue(withIdentifier: "daftar", sender: self)
                            }
                        }
                    }
                    
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