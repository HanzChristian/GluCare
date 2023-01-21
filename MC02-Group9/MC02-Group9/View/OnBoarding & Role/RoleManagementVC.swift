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
    let db = Firestore.firestore()
    
    @IBOutlet weak var youAreLbl: UILabel!
    @IBOutlet weak var patientCardBtn: UIButton!
    @IBOutlet weak var caregiverCardBtn: UIButton!
    @IBOutlet weak var warningImg: UIImageView!
    @IBOutlet weak var warningLbl: UILabel!
    
    @IBOutlet weak var confirmBtn: UIButton!
    let coreDataManager = CoreDataManager.coreDataManager
    
    var blue = "1E84C6"
    
    var roles = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        confirmBtn.layer.cornerRadius = 10
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.tintColor = .gray
        
        confirmBtn.isEnabled = false
        
        
        validateForm()
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
    
    @IBAction func didTapCardPBtn(_ sender: UIButton) {
        patientCardBtn.setImage(UIImage(named: "card-patient-click"), for: .normal)
        caregiverCardBtn.setImage(UIImage(named: "card-caregiver"), for: .normal)
        confirmBtn.backgroundColor = hexStringToUIColor(hex: "1E84C6")
        roles = 1
        validateForm()
    }
    
    @IBAction func didTapCardCBtn(_ sender: UIButton) {
        patientCardBtn.setImage(UIImage(named: "card-patient"), for: .normal)
        caregiverCardBtn.setImage(UIImage(named: "card-caregiver-click"), for: .normal)
        confirmBtn.backgroundColor = hexStringToUIColor(hex: "1E84C6")
        roles = 2
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
            print("tapped Ya")
            UserDefaults.standard.set(self!.roles, forKey: "role")
            
            // add role to firebase
            self!.addRoleDataToFirebase()
    
        }))
        
        present(alert, animated: true)
    }
    
    func addRoleDataToFirebase(){
        
        performSegue(withIdentifier: "goToContract", sender: self)
        
//        if  let user = Auth.auth().currentUser?.email{
//    
//            let roleUserDefault = UserDefaults.standard.integer(forKey: "role") - 1
//            let nama = UserDefaults.standard.string(forKey: "nama")
//            
//            self.db.collection("account").addDocument(data: [
//                "roleId": roleUserDefault,
//                "nama": "\(nama!)",
//                "owner": "\(user)"
//            ]){ (error) in
//                if let e = error {
//                    print("failed saved data \(e)")
//                }else{
//                    print("success saved data")
//                    // make segue
//                    FirebaseManager.firebaseManager.getAccountInfo()
//                    self.performSegue(withIdentifier: "goToContract", sender: self)
//                }
//            }
//        }
    }
    
    @objc func validateForm(){
        if (self.roles != 0) {
            confirmBtn.isEnabled = true
        }
    }
    
//    func hexStringToUIColor (hex:String) -> UIColor {
//        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//
//        if (cString.hasPrefix("#")) {
//            cString.remove(at: cString.startIndex)
//        }
//
//        if ((cString.count) != 6) {
//            return UIColor.gray
//        }
//
//        var rgbValue:UInt64 = 0
//        Scanner(string: cString).scanHexInt64(&rgbValue)
//
//        return UIColor(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
//    }
    
}





