
import UIKit

class TakeMedTimeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblTakeMedTime: UILabel!
    @IBOutlet weak var btnDatePicker: UITextField!
    
    let time = Date()
    let formatter = DateFormatter()
    let timePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblTakeMedTime.text = "Waktu Minum"
        
        // Format Time
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "HH:mm"
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        //toolBar.barStyle = .black
        let doneBtn = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(btnDoneClicked))
        //let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.isUserInteractionEnabled = true
        toolBar.items = [space, doneBtn]
        btnDatePicker.inputAccessoryView = toolBar
        btnDatePicker.text = formatter.string(from: time)
        
        // Set Picker Mode
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timePickerValueChange(sender:)), for: UIControl.Event.valueChanged)
        timePicker.preferredDatePickerStyle = .wheels
        
        // Set Date Picker to Text Field
        btnDatePicker.inputView = timePicker
    }
    
    
    // Change Text Field on Value Changed
    @objc func timePickerValueChange(sender: UIDatePicker){
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "HH:mm"
        
        btnDatePicker.text = formatter.string(from: sender.date)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "formValidateNotif"), object: nil)
    }
    
    // Dismiss when done clicked
    @objc func btnDoneClicked(){
        self.endEditing(true)
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//
//        lblTakeMedTime.text = "Waktu Minum"
//
//        // Set Default waktunya yang dari core data
//        btnDatePicker.text
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
