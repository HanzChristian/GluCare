//
//  RoleHelper.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 16/02/23.
//

import Foundation
//  ROLE ID UserDefaults:
//  1 = PATIENT
//  2 = CAREGIVER

//  ROLE ID Firebase
//  0 = PATIENT
//  1 = CAREGIVER

enum RoleEnum: Int {
    case Patient = 1
    case Caregiver = 2
}

class RoleHelper {
    static let instance = RoleHelper()
    private init(){}
    
    func setRole(role: RoleEnum){
        UserDefaults.standard.set(role.rawValue, forKey: "role")
    }
    
    func getRole() -> Int{
        return UserDefaults.standard.integer(forKey: "role")
    }
}

/*
    BEFORE  UserDefaults.standard.integer(forKey: "role")
    AFTER   let role: Int = RoleHelper.instance.getRole()
 
    BEFORE  UserDefaults.standard.set(1, forKey: "role")
    AFTER   RoleHelper.instance.setRole(role: .Patient)
 
    BEFORE  UserDefaults.standard.set(2, forKey: "role")
    AFTER   RoleHelper.instance.setRole(role: .Caregiver)
*/
