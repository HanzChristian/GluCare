//
//  UserFR.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 10/10/23.
//

import Foundation
import FirebaseAuth

struct UserFR {
  var fullname: String
  let email: String
  var bio: String
  let uid: String
  var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
  var profileImageUrl: String
  var balance: Int

  init(uid:String, dictionary: [String: AnyObject]){
    self.uid = uid

    self.fullname = dictionary["fullname"] as? String ?? ""
    self.email = dictionary["email"] as? String ?? ""
    self.bio = dictionary["bio"] as? String ?? ""
    self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    self.balance = dictionary["balance"] as? Int ?? 0
  }
}
