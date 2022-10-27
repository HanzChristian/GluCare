//
//  UsernameTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 27/10/22.
//

import UIKit

class UsernameTVC: UITableViewCell {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userNameLbl.font = .rounded(ofSize: 16, weight: .semibold)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
