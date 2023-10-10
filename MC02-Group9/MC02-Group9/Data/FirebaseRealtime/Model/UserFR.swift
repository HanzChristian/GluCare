//
//  UserFR.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 10/10/23.
//

import Foundation
import FirebaseAuth

struct AuthCredentials {
  let email: String
  let password: String
  let fullname: String
}

struct UserFR {
  var uid: String
  var fullname: String
  var email: String
  var caregiver: Bool
  var patient: Bool

  init(uid:String, dictionary: [String: AnyObject]){
    self.uid = uid
    self.fullname = dictionary["fullname"] as? String ?? ""
    self.email = dictionary["email"] as? String ?? ""
    self.caregiver = dictionary["caregiver"] as? Bool ?? false
    self.patient = dictionary["patient"] as? Bool ?? false
  }
}
