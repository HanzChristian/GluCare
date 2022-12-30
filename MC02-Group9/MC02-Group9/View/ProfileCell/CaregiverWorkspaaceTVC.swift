//
//  CaregiverWorkspaaceTVC.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 17/12/22.
//

import UIKit

class CaregiverWorkspaaceTVC: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLbl?.text = listCaregiver.caregiverList[0].name
    }
    
    @IBAction func quitBtn(_ sender: UIButton) {

    }
}
