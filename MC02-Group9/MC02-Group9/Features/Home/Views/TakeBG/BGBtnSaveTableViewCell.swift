//
//  BGBtnSaveTableViewCell.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 06/10/22.
//

import UIKit

class BGBtnSaveTableViewCell: UITableViewCell {

    @IBOutlet weak var BGBtnSkip: UIButton!
    @IBOutlet weak var BGBtnSave: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func pressedSkip(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "skipBG"), object: nil)
    }
    
    @IBAction func pressedSave(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "saveBG"), object: nil)
    }
   
    
 
}
