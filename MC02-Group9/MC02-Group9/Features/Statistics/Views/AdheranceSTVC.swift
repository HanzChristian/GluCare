//
//  AdheranceSTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 09/12/22.
//

import UIKit

class AdheranceSTVC: UITableViewCell {

    @IBOutlet weak var percentageAdheranceLbl: UILabel!
    @IBOutlet weak var descAdheranceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
