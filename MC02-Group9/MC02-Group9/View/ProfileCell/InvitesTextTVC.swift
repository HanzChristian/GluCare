//
//  InvitesTextTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 03/11/22.
//

import UIKit

class InvitesTextTVC: UITableViewCell {
    
    
    @IBOutlet weak var invitesTitleLbl: UILabel!
    @IBOutlet weak var invitesDescLbl: UILabel!
    @IBOutlet weak var invitesCapsuleView: UIView!
    @IBOutlet weak var invitesCodeBtn: UIButton!
    @IBOutlet weak var invitesAddBtn: UIButton!
    let capsuleView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        invitesCapsuleView.layer.cornerRadius = 15;
        invitesCapsuleView.layer.borderWidth = 2
        invitesCapsuleView.layer.borderColor = UIColor.lightGray.cgColor
        invitesAddBtn.layer.cornerRadius = 24
        invitesAddBtn.layer.borderWidth = 2
        invitesAddBtn.layer.borderColor = UIColor.lightGray.cgColor
        
//        invitesCapsuleView.layer.masksToBounds = true;
        // Initialization code
    }
}
