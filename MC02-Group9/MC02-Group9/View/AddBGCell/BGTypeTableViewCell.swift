//
//  BGTypeTableViewCell.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 11/10/22.
//

import UIKit

class BGTypeTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var bgTypeLbl:UILabel!
    @IBOutlet var bgTypeBtn:UIButton!
    
    let bgType = ["Gula Darah Puasa","Gula Darah Sesaat","HbA1c"]
    let pickerView = UIPickerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    var bgTypePickerView = UIPickerView()
    public var bgTypePicked = false
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override var canResignFirstResponder: Bool{
        return true
    }
    
    override var inputView: UIView? {
        return pickerView
    }
    
    override var inputAccessoryView: UIView? {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.isUserInteractionEnabled = true
        toolBar.items = [space, doneBtn]
        return toolBar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bgType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bgType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bgTypeLbl.textColor = .black
        bgTypeLbl.text = bgType[row]
        bgTypePicked = true
        bgTypeLbl.resignFirstResponder()
    }
    
    @objc func doneTapped() {
        self.endEditing(true)
    }
    
    @objc func dismissPicker() {
        self.endEditing(true)
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        pickerView.endEditing(true)
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        if (pickerView.isHidden == true){
            pickerView.isHidden = false
        }
    }
}
