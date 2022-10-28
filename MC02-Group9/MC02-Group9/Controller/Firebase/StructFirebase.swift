//
//  StructFire.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 27/10/22.
//

import Foundation

struct MedicineFire: Codable {
    var medicine_name: String
    var medicine_time: [MedicineTimeFire]
    var medicine_eat_time: Int
    var owner: String
    var id: String
    
    init(medicine_name: String, medicine_time: [MedicineTimeFire], medicine_eat_time: Int, owner: String, id: String) {
        self.medicine_name = medicine_name
        self.medicine_time = medicine_time
        self.medicine_eat_time = medicine_eat_time
        self.owner = owner
        self.id = id
    }
}

struct MedicineTimeFire: Codable {
    
    var time: String
    
    init(time: String) {
        self.time = time
    }
}
