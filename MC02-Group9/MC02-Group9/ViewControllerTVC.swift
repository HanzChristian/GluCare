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
    @IBOutlet weak var indicatorImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let fontSize: CGFloat = 32
//            let systemFont = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
//            let roundedFont: UIFont
//            if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
//                roundedFont = UIFont(descriptor: descriptor, size: fontSize)
//            } else {
//                roundedFont = systemFont
//            }
        
    
//        freqLbl.font =
        freqLbl.alpha = 0.5
        timeLbl.font = UIFont.boldSystemFont(ofSize: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
