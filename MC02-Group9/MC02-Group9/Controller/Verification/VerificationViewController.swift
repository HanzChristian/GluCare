//
//  VerificationViewController.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 20/01/23.
//

import UIKit
import FirebaseAuth

class VerificationViewController: UIViewController {

    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        resendVerificationEmail(self)
        
        
    }


    @IBAction func continuePressed(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else{
            return
        }
        
        user.reload{ [weak self] error in
            switch user.isEmailVerified {
            case true:
                self!.performSegue(withIdentifier: "daftar", sender: self)
            case false:
                self!.errorLabel.isHidden = false
                self!.errorLabel.text = "Your email has not been verified"
            }
        }
//        self.errorLabel.isHidden = false
//        self.errorLabel.text = "Your email has not been verified"
    }
    
    @IBAction func resendVerificationEmail(_ sender: Any)
    {
        
        if count == 0{
            guard let user = Auth.auth().currentUser else{
                return
            }
            user.sendEmailVerification{ error in
                guard let error = error else{
                    print("email was send")
                    return
                }
                
            }
            
            print("email not send")
            count = 30
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [unowned self] (Timer) in
                
                if self.count > 0 {
                    self.count -= 1
                    resendButton.setTitle("Resend verification Email (\(self.count))", for: .normal)
                    resendButton.setTitleColor(UIColor.systemGray, for: .normal)
                } else {
                    self.setNormalButton()
                    Timer.invalidate()
                }
            }
        }else{
            
        }
    }
    
    func setNormalButton(){
        print("set normal button")
        resendButton.setTitle("Resend verification Email", for: .normal)
        resendButton.setTitleColor(UIColor.systemBlue, for: .normal)
    }
    
}
