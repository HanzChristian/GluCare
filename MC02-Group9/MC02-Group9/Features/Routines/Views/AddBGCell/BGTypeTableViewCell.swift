//
//  BGTypeTableViewCell.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 11/10/22.
//

import UIKit

class BGTypeTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var bgTypeLbl:UILabel!
    
    let bgType = ["Gula Darah Puasa","Gula Darah Sewaktu","HbA1c"]
    // hide hbA1c
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
        typeVars.typePickedRow = row
        bgTypePicked = true
        bgTypeLbl.resignFirstResponder()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "formValidate"), object: nil)
    }
    
    @objc func doneTapped() {
        
        if bgTypeLbl.text == "Pilih Jenis Cek Gula Darah"{
            bgTypeLbl.textColor = .black
            bgTypeLbl.text = bgType[0]
            typeVars.typePickedRow = 0
            bgTypePicked = true
            bgTypeLbl.resignFirstResponder()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "formValidate"), object: nil)
        }
        
       
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

struct typeVars {
    static var typePickedRow = 3
}