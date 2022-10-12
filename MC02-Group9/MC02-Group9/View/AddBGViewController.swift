//
//  AddBGViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 11/10/22.
//

import UIKit

class AddBGViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var height = 49.0
    let cellTitle = ["Jenis", "Jadwal"]
    
    var cellFrequencyPicker: BGFrequencyTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemGroupedBackground
        tableView.backgroundColor = .systemGroupedBackground
        
        if let roundedTitleDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: .largeTitle)
            .withDesign(.rounded)?
            .withSymbolicTraits(.traitBold) {
            self.navigationController? // Assumes a navigationController exists on the current view
                .navigationBar
                .largeTitleTextAttributes = [
                    .font: UIFont(descriptor: roundedTitleDescriptor, size: 0) // Note that 'size: 0' maintains the system size class
                ]
        }
        setNavItem()
        
        setNib()
    }
    
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveItem(){
        //tunggu semuanya ke save dlu baru diupdate
        dismiss(animated: true,completion: nil)
    }
    
    private func setNavItem(){
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Tambah Cek Gula Darah"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(saveItem))
        
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
        
        //tunggu kondisi
//  navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setNib(){
        let nibBGType = UINib(nibName: "BGTypeTableViewCell", bundle: nil)
        tableView.register(nibBGType, forCellReuseIdentifier: "bgTypeTableViewCell")
        let nibBGStartDate = UINib(nibName: "BGStartDateTableViewCell",bundle: nil)
        tableView.register(nibBGStartDate, forCellReuseIdentifier: "bgStartDateTableViewCell")
        let nibBGTime = UINib(nibName: "BGTimeTableViewCell",bundle: nil)
        tableView.register(nibBGTime, forCellReuseIdentifier: "bgTimeTableViewCell")
        let nibBGFrequency = UINib(nibName: "BGFrequencyTableViewCell",bundle: nil)
        tableView.register(nibBGFrequency, forCellReuseIdentifier: "bgFrequencyTableViewCell")
        let nibBGSubFrequency = UINib(nibName: "BGSubFrequencyTableViewCell",bundle: nil)
        tableView.register(nibBGSubFrequency, forCellReuseIdentifier: "bgSubFrequencyTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else{
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "bgTypeTableViewCell", for: indexPath) as! BGTypeTableViewCell
                cell.bgTypeLbl.text = "Pilih Jenis Cek Gula Darah"
                return cell
            }
        }
        else if(indexPath.section == 1){
            if(indexPath.row == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "bgStartDateTableViewCell",for:indexPath) as! BGStartDateTableViewCell
                cell.bgStartDateLbl.text = "Tanggal Mulai"
                return cell
            }
            else if(indexPath.row == 1){
                let cell = tableView.dequeueReusableCell(withIdentifier: "bgTimeTableViewCell",for:indexPath) as! BGTimeTableViewCell
                cell.bgTimeLbl.text = "Waktu"
                return cell
            }
            else if(indexPath.row == 2){
                let cell = tableView.dequeueReusableCell(withIdentifier: "bgFrequencyTableViewCell",for:indexPath) as! BGFrequencyTableViewCell
                cell.bgFrequencyLbl.text = "Frekuensi"
                cellFrequencyPicker = cell
                return cell
            }
            else if(indexPath.row == 3){
                let cell = tableView.dequeueReusableCell(withIdentifier: "bgSubFrequencyTableViewCell",for:indexPath) as! BGSubFrequencyTableViewCell
                cell.bgSubFrequencyEveryLbl.text = "Setiap"
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let sectionLabel = UILabel(frame: CGRect(x: 18, y: 0, width:
                                                    tableView.bounds.size.width, height: 5))
        
        sectionLabel.font = .rounded(ofSize: 16, weight: .semibold)
        //        sectionLarebel.font = UIFont(name: "Helvetica Neue", size: 16)
        //        sectionLabel.textColor = UIColor.black
        sectionLabel.text = cellTitle[section]
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? BGFrequencyTableViewCell{
            if !cell.isFirstResponder{
                _ = cell.becomeFirstResponder()
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
