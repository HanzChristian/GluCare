//
//  StatisticBG.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 17/11/22.
//

import UIKit

class StatisticBGTVC: UITableViewCell {

    
    @IBOutlet weak var bgTitleLbl: UILabel!
    
    @IBOutlet weak var bgPercentageLbl: UILabel!
    @IBOutlet weak var bgTargetLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
