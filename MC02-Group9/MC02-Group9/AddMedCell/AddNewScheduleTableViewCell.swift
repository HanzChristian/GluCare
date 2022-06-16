//
//  AddNewScheduleTableViewCell.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 16/06/22.
//

import UIKit

class AddNewScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var lblBtnAdd: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblBtnAdd.text = "Tambah Jadwal"
        lblBtnAdd.textColor = .link
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override var canResignFirstResponder: Bool{
        return true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
