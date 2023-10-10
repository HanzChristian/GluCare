//
//  OnboardingNavigator.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 10/10/23.
//

import UIKit

protocol OnboardingNavigator {
  func navigateToVerificationFromRegister(from viewController: UIViewController)

  func navigateToVerificationFromLogin(from viewController: UIViewController)
  func navigateToRoleManagementFromLogin(from viewController: UIViewController)

  func navigateToRoleManagementFromVerification(from viewController: UIViewController)

  func navigateToContractFromRoleManagement(from viewController: UIViewController, userType: UserType?)
  func navigateToHomeKonfirmasiFromContract(from viewController: UIViewController)
}

struct DefaultOnboardingNavigator: OnboardingNavigator {
  init() {}

  func navigateToVerificationFromRegister(from viewController: UIViewController) {
    viewController.performSegue(withIdentifier: "goToVerify", sender: nil)
  }

  func navigateToVerificationFromLogin(from viewController: UIViewController) {
    viewController.performSegue(withIdentifier: "FromLoginToVerify", sender: nil)
  }

  func navigateToRoleManagementFromLogin(from viewController: UIViewController) {
    viewController.performSegue(withIdentifier: "FromLoginToRoleManagement", sender: nil)
  }

  func navigateToRoleManagementFromVerification(from viewController: UIViewController) {
    viewController.performSegue(withIdentifier: "daftar", sender: nil)
  }

  func navigateToContractFromRoleManagement(from viewController: UIViewController, userType: UserType?) {
    viewController.performSegue(withIdentifier: "goToContract", sender: userType)
  }

  func navigateToHomeKonfirmasiFromContract(from viewController: UIViewController) {
    viewController.performSegue(withIdentifier: "goToHomeKonfirmasi", sender: nil)
  }

}

// Example to send data to other vc

// MARK: - Handle Navigate To Contract From RoleManagement
extension RoleManagementVC {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToContract" {
      guard let nextVC = segue.destination as? ContractViewController else { return }
      guard let userType = sender as? UserType else { return }
      nextVC.userType = userType
      print("\(userType) in RoleManagement")
    }
  }
}



