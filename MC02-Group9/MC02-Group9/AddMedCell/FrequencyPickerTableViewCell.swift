

import UIKit

class FrequencyPickerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var lblFrequency: UILabel!
    @IBOutlet weak var pickerViewFrequency: UIPickerView!
    
    let frequency = ["1 times a day", "2 times a day", "3 times a day", "4 times a day", "5 times a day", "6 times a day", "7 times a day"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerViewFrequency.dataSource = self
        pickerViewFrequency.delegate = self

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // No of column
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequency.count // No of component
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return frequency[row] // Data for each component
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        40
    }
}


