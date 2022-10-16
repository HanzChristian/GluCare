//
//  RoutinesTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 06/10/22.
//

import UIKit

class RoutinesTVC: UITableViewCell {
    
    @IBOutlet weak var routinesView: UIView!
    @IBOutlet weak var routinesClockImgView: UIImageView!
    @IBOutlet weak var routinesArrowImgView: UIImageView!
    @IBOutlet weak var routinesTitleCellLbl: UILabel!
    @IBOutlet weak var routinesDescCellLbl: UILabel!
    @IBOutlet weak var routinesTimeDescLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
