//
//  TakeMedTableViewCell.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 05/10/22.
//

import UIKit
import RxSwift

class TakeMedTableViewCell: UITableViewCell {
    
    private(set) var disposeBag = DisposeBag()
    
    var idx = -1
    var identity = JadwalVars(type: "BG", idx: 0)
    
    var log = Log()
    
    var indexPath:Int = 0
    var isSkipped:Bool = false
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellBtn: UIButton!
    @IBOutlet weak var medLbl: UILabel!
    @IBOutlet weak var freqLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        medLbl.font = .rounded(ofSize: 16, weight: .medium)
        freqLbl.textColor = .systemGray
        timeLbl.font = .rounded(ofSize: 20, weight: .bold)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var takeBtn: UIButton!
    
    @IBAction func takeBtn(_ sender: Any) {
        
//        var isSkippedd:Int = 0
//        if(self.isSkipped == false){
//            isSkippedd = 0
//        }else{
//            isSkippedd = 1
//        }
//        print("INI TVC \(self.indexPath)")
//        print("INI TVC SKIP\(self.isSkipped)")
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "takeMed"),
//                                        object: nil,
//                                        userInfo:["indexPath": self.indexPath, "isSkipped": isSkippedd])
    }
    
}


    


