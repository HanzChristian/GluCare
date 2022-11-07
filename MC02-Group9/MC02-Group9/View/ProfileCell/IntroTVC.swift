//
//  IntroTVC.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 07/11/22.
//

import UIKit

class IntroTVC: UITableViewCell {


    @IBOutlet weak var gabungLbl: UILabel!

    @IBAction func gabungBtn( sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "passLogin"), object: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gabungLbl.font = UIFont.boldSystemFont(ofSize: 20)

    }

    override func setSelected( _ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

public extension UIView {

    @IBInspectable public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}
