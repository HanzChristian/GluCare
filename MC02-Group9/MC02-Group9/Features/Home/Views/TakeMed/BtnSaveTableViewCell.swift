//
//  BtnSaveTableViewCell.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 05/07/22.
//

import UIKit

class BtnSaveTableViewCell: UITableViewCell {

    var cellMedNameTV: MedNameTextFieldTVC?
    let coreDataManager = CoreDataManager.coreDataManager
    
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnSave.titleLabel?.text = "Simpan"
        
        
    }
    
    
    @IBAction func didTapBtn(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "save"), object: nil)
    }
    
    @IBAction func didTapSkipBtn(_ sender: Any){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "skip"),object: nil)
    }
 
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
