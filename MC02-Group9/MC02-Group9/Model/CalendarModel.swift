//
//  CalendarModel.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 13/10/22.
//

import Foundation

struct CalendarModel{
    var text:String
    var isSelected:Bool
    var position:Int
    
    init(text:String,isSelected:Bool,position:Int){
        self.text = text
        self.isSelected = isSelected
        self.position = position
    }
}

