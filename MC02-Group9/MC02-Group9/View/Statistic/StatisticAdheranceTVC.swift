//
//  StatisticAdheranceTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 17/11/22.
//

import UIKit

class StatisticAdheranceTVC: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var adherancePercentageLbl: UILabel!
    
    @IBOutlet weak var adheranceTargetLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
