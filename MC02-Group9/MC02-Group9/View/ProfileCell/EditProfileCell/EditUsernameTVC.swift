//
//  EditUsernameTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 13/01/23.
//

import UIKit

class EditUsernameTVC: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLbl.text = FirebaseManager.firebaseManager.name
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUser), name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
        
    }
    
    @objc func refreshUser(){
        nameLbl.text = FirebaseManager.firebaseManager.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
