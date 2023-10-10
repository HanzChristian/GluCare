//
//  AuthService.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 10/10/23.
//

import UIKit
import Firebase
import FirebaseAuth
import RxSwift

enum FirebaseError: Error{
  case FileNotFound
  case DecodeFailed
}

enum UserType: Int, CaseIterable {
  case patient
  case caregiver

  var string: String {
    switch self {
    case .patient:
      return "patient"
    case .caregiver:
      return "caregiver"
    }
  }
}

struct AuthService{
  static let shared = AuthService()  //   ((AuthDataResult?, (any Error)?) -> Void)?'

  func loginUser(email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void){
    Auth.auth().signIn(withEmail: email, password: password, completion: completion)
  }

  func registerUser(credentials: AuthCredentials, completions: @escaping(Error?, DatabaseReference?) -> Void){
    let email = credentials.email
    let password = credentials.password
    let fullname = credentials.fullname

    Auth.auth().createUser(withEmail: email, password: password){ (result, error) in
      if let error = error {
        completions(error, nil)
      }
      guard let uid = result?.user.uid else { return }
      let values = ["email": email, "fullname": fullname]
      REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completions)
    }
  }

  func addRole(userType: UserType?, completions: @escaping(Error?, DatabaseReference?) -> Void){
    if let uid = Auth.auth().currentUser?.uid, let userType = userType {
      let values = [userType.string: true]
      REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completions)
    }
  }

  func fetchUser(uid: String) -> Observable<UserFR> {
    return Observable<UserFR>.create { observer in
      REF_USERS.child(uid).observe(.value, with:  { snapshot in
        guard let dictionary = snapshot.value as? [String: AnyObject] else {
          observer.onError(FirebaseError.DecodeFailed)
          return
        }
        let user = UserFR(uid: uid, dictionary: dictionary)
        observer.onNext(user)
      }){
        error in
        observer.onError(error)
      }
      return Disposables.create()
    }
  }

}

