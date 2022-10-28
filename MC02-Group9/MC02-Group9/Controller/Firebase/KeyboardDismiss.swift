//
//  KeyboardDismiss.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 28/10/22.
//

import Foundation
import UIKit

// Put this piece of code anywhere you like
extension LoginViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
