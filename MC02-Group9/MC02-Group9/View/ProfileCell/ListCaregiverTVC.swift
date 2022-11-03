//
//  ListCaregiverTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 03/11/22.
//

import UIKit

class ListCaregiverTVC: UITableViewCell {
    
    
    
    @IBOutlet weak var caregiverNameLbl: UILabel!
    @IBOutlet weak var confirmCaregiverBtn: UIButton!
    @IBOutlet weak var waitingConfirmBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    // TINGGAL DIMAININ IS HIDDEN NYA
        confirmCaregiverBtn.isHidden = true
        waitingConfirmBtn.isHidden = true
//        STATUS CAREGIVER
//        0 = SUDAH ACCEPT
//        1 = BUTTON KONFIRMASI
//        2 = MENUNGGU KONFIRMASI
//
//        if (caregiverStatus == 0) {
//            caregiver(true)
//        } else if (caregiverStatus == 1) {
//            caregiverConfirm(true)
//        } else if (caregiverStatus == 2) {
//            caregiverWaiting(true)
//        }
//
        
        // Initialization code
    }
}

extension ListCaregiverTVC {
    private func caregiver(_ bool: Bool) {
        confirmCaregiverBtn.isHidden = true
        waitingConfirmBtn.isHidden = true
    }
    private func caregiverConfirm(_ bool: Bool) {
        confirmCaregiverBtn.isHidden = false
        waitingConfirmBtn.isHidden = true
    }
    private func caregiverWaiting(_ bool: Bool) {
        confirmCaregiverBtn.isHidden = true
        waitingConfirmBtn.isHidden = false
    }
    
}
