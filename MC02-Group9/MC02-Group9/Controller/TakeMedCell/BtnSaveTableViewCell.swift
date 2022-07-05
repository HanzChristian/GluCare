//
//  BtnSaveTableViewCell.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 05/07/22.
//

import UIKit

class BtnSaveTableViewCell: UITableViewCell {

    @IBOutlet weak var btnSave: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnSave.titleLabel?.text = "Simpan"
    }
    
    
    @IBAction func didTapBtn(_ sender: Any) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
