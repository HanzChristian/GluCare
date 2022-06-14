//
//  ViewControllerTVC.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 08/06/22.
//

import UIKit

class ViewControllerTVC: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImgView: UIImageView!
    @IBOutlet weak var medLbl: UILabel!
    @IBOutlet weak var freqLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
