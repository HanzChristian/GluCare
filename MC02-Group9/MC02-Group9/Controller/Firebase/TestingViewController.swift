//
//  TestingViewController.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 28/10/22.
//


import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class TestingViewController: UIViewController {
    let db = Firestore.firestore()
    var role = -1
    var patientEmail = ""
    
    @IBOutlet weak var patientEmailToConnect: UITextField!
    @IBOutlet weak var patientConnectButton: UIButton!
    
    @IBOutlet weak var caregiverInviteLabel: UILabel!
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var newDataField: UITextField!
    
    @IBOutlet weak var caregiverInviteButton: UIButton!
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem){
    
        print("hello")
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            
        }
    }
    
    @IBAction func addSampleData (_ sender:Any ){
//        if role != 0 {
//            errorMsg.text = "you can't add new data"
//            return
//        }
//        
//        let medicineTimes = [
//            MedicineTimeFire(time: "16.00"),
//            MedicineTimeFire(time: "20.00")
//        ]
//        
//        if let user = Auth.auth().currentUser?.email,
//           let medicine_name = newDataField.text, medicine_name != "" {
//            let medicine = MedicineFire(medicine_name: medicine_name, medicine_time: medicineTimes, medicine_eat_time: 1, owner: user, id: UUID().uuidString, start_date: medicine)
//            
//            do{
//                try db.collection("medicine").document().setData(from: medicine)
//                self.errorMsg.text = "success add new medicine"
//            }catch let error{
//                print(" error msg \(error)")
//            }
//        }
    }
    
    @IBAction func connectToPatient (_ sender: Any){
        print("pressed")
        if  let user = Auth.auth().currentUser?.email,
            let emailPatient = patientEmailToConnect.text{
            print(user)
            self.db.collection("link").addDocument(data: [
                "patient": "\(emailPatient)",
                "owner": "\(user)",
                "status": false
            ]){ (error) in
                if let e = error {
                    print("e \(e)")
                }else{
                    self.errorMsg.text = "invitation send to \(emailPatient)"
                }
            }
        }
    }
    
    @IBAction func acceptInvitation(_ sender: Any) {
        if let user = Auth.auth().currentUser?.email {
            db.collection("link").whereField("patient", isEqualTo: "\(user)")
                .getDocuments { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let data = document.data()
                            if  let caregiver = data["owner"] as? String,
                                let caregiverInviteLabel = self!.caregiverInviteLabel.text
                            {
                                if caregiverInviteLabel == caregiver {
                                    document.reference.updateData([
                                        "status": true
                                    ])
                                }
                            }
                        }
                    }
                }
        }
        
    }
    
    func getRole() {
        if let user = Auth.auth().currentUser?.email {
            db.collection("account").whereField("owner", isEqualTo: "\(user)")
                .getDocuments { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if  let roleId = data["roleId"] as? Int
                            {
                                self!.role = roleId
                                if(roleId == 0){
                                    self!.navigationItem.title = "Patient"
                                    RoleHelper.instance.setRole(role: .Patient)
                                }else{
                                    self!.navigationItem.title = "Caregiver"
                                    UserDefaults.standard.set(2
                                                              , forKey: "role")
                                }
                                
                                self!.navigationController!.setNavigationBarHidden(false, animated: true)
                                print("hey \(roleId)")
                                
                                self!.setupCaregiverView()
                                self!.fetchInvitationFromCaregiver()
                                
                                if self!.role == 0 {
                                    //self!.loadMedicine()
                                }else{
                                    self!.getPatientEmail()
                                }
                            }
                        }
                    }
                }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = "x"
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        caregiverInviteLabel.text = ""
        caregiverInviteButton.isHidden = true
        patientEmailToConnect.isHidden = true
        patientConnectButton.isHidden = true
        
        errorMsg.text = ""
        
        dataLabel.text = ""
        
        DispatchQueue.main.async { [weak self] in
            self!.getRole()
        }
        
    }
    
    func fetchInvitationFromCaregiver() {
        if let user = Auth.auth().currentUser?.email {
            db.collection("link")
                .whereField("patient", isEqualTo: "\(user)")
                .whereField("status", isEqualTo: false)
                .addSnapshotListener { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if  let caregiver = data["owner"] as? String
                            {
                                self!.caregiverInviteLabel.text! = "\(caregiver)"
                                self!.caregiverInviteButton.isHidden = false
                            }
                        }
                        
                        if querySnapshot!.isEmpty{
                            self!.caregiverInviteLabel.text = ""
                            self!.caregiverInviteButton.isHidden = true
                            print("No Invitation from caregiver -")
                        }
                    }
                }
        }
    }
    
    func setupCaregiverView(){
        if role == 1 {
            print("My role is caregiver")
            patientEmailToConnect.isHidden = false
            patientConnectButton.isHidden = false
        }
    }
    
    func getPatientEmail(){
        if let user = Auth.auth().currentUser?.email {
            db.collection("link")
                .whereField("owner", isEqualTo: "\(user)")
                .whereField("status", isEqualTo: true)
                .getDocuments { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if  let patientEmail = data["patient"] as? String
                            {
                                print(patientEmail)
                                UserDefaults.standard.set("\(patientEmail)", forKey: "patient")
                                self!.patientEmail = patientEmail
                                self!.errorMsg.text = "Connected with patient \(patientEmail)"
//                                self!.loadMedicine()
                                
                                return
                            }
                        }
                    }
                }
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
