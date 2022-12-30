//
//  InvitesTextTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 03/11/22.
//

import UIKit

class InvitesTextTVC: UITableViewCell {
    
    @IBOutlet weak var invitesTitleLbl: UILabel!
    @IBOutlet weak var invitesDescLbl: UILabel!
    @IBOutlet weak var invitesCapsuleView: UIView!
    @IBOutlet weak var invitesAddBtn: UIButton!
    @IBOutlet weak var inviteTextField: UITextField!
    
    let capsuleView = UIView()
    let role = UserDefaults.standard.integer(forKey: "role")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        invitesCapsuleView.layer.cornerRadius = 15;
        invitesCapsuleView.layer.borderWidth = 2
        invitesCapsuleView.layer.borderColor = UIColor.lightGray.cgColor
        invitesAddBtn.layer.cornerRadius = 24
        invitesAddBtn.layer.borderWidth = 2
        invitesAddBtn.layer.borderColor = UIColor.lightGray.cgColor
        inviteTextField.placeholder = "Masukkan email anggota keluarga..."
        
        if(role == 2){
            invitesTitleLbl.text = "Masuk ke Workspace Pasien"
            invitesDescLbl.text = "Masuk ke dalam workspace anggota keluargamu dengan memasukkan email mereka yang telah terdaftar di Glucare."
        }
    }
    
    @IBAction func invite(_ sender: Any) {
        if self.inviteTextField.text == ""{return}
        
        let firebaseManager = FirebaseManager.firebaseManager
        
        if firebaseManager.role == 1{
            // patient
            let invite = firebaseManager.sendInvitationToCaregiver(emailCaregiver: self.inviteTextField.text!)
            print(invite)
                        
        }else if firebaseManager.role == 2{
            // caregiver
            let invite = firebaseManager.sendInvitationToPatient(emailPatient: self.inviteTextField.text!)
            print(invite)
            
        }
        self.inviteTextField.text = ""
        
    }
    
    
}
