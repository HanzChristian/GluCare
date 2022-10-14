//
//  BGCalendarCollectionViewCell.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 13/10/22.
//

import UIKit

class BGCalendarCollectionViewCell: UICollectionViewCell {

    @IBOutlet var calendarLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with model: CalendarModel){
        self.calendarLbl.text = model.text
    }
}
