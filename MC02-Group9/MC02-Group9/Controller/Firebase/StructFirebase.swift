//
//  StructFire.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 27/10/22.
//

import Foundation


struct LogFire: Codable {
    var action: String
    var bg_check_result: String
    var date: Date
    var dateTake: Date
    var log_id: String
    var log_ref: String
    var medicine_name: String
    var time: String
    var type: Int
    var owner: String
    
    init(action: String, bg_check_result: String, date: Date, dateTake: Date, log_id: String, log_ref: String, medicine_name: String, time: String, type: Int, owner: String) {
        self.action = action
        self.bg_check_result = bg_check_result
        self.date = date
        self.dateTake = dateTake
        self.log_id = log_id
        self.log_ref = log_ref
        self.medicine_name = medicine_name
        self.time = time
        self.type = type
        self.owner = owner
    }

}


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

struct BGFire: Codable{
    var bg_id: String
    var bg_each_frequency: Int16
    var bg_frequency: Int16
    var bg_start_date: Date
    var bg_time: String
    var bg_type: Int16
    var bg_times: [BGTimeFire]
    var owner: String
    
    init(bg_id: String, bg_each_frequency: Int16, bg_frequency: Int16, bg_start_date: Date, bg_time: String, bg_type: Int16, bg_times: [BGTimeFire], owner: String) {
        self.bg_id = bg_id
        self.bg_each_frequency = bg_each_frequency
        self.bg_frequency = bg_frequency
        self.bg_start_date = bg_start_date
        self.bg_time = bg_time
        self.bg_type = bg_type
        self.bg_times = bg_times
        self.owner = owner
    }
}

struct BGTimeFire: Codable {
    var time: Int16
    
    init(time: Int16) {
        self.time = time
    }
}
