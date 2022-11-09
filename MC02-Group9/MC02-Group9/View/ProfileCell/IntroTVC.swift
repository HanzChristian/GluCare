//
//  IntroTVC.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 07/11/22.
//

import UIKit

class IntroTVC: UITableViewCell {


    @IBOutlet weak var gabungLbl: UILabel!
    @IBOutlet weak var joinBtn: UIButton!
    
    @IBAction func gabungBtn( sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "passLogin"), object: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gabungLbl.font = UIFont.boldSystemFont(ofSize: 20)
        joinBtn.tintColor = hexStringToUIColor(hex: "1E84C6")
    }

    override func setSelected( _ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}

public extension UIView {

    @IBInspectable public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}
