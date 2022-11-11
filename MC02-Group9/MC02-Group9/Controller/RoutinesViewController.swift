//
//  profilePageViewController.swift
//  MC02-Group9
//
//  Created by Noah S on 14/06/22.
//

import UIKit
import CoreData


class RoutinesViewController: UIViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[Medicine]?
    var itemsBG:[BG]?
    var indexPath:IndexPath?
    var tableView:UITableView?
    let coreDataManager = CoreDataManager.coreDataManager
    
    var medsTypeArr = ["Waktu Spesifik","Sebelum Makan", "Setelah Makan", "Bersamaan dengan Makan"]
    var bgTypeArr = ["Gula darah puasa", "Gula darah sesaat", "HbA1c"]
    var bgFreqArr = ["Hari", "Minggu", "Bulan"]
    
    var rutinitasSections = ["Jadwal Minum Obat","Jadwal Cek Gula Darah"]
    
    @IBOutlet weak var daftarRutinitasTableView: UITableView!
    
    func setup(){
        let emptyVC = EmptyRoutinesSpaceVC()
        addChild(emptyVC)
        self.view.addSubview(emptyVC.view)
        
        emptyVC.enableHidden()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        fetchMedicine()
//        fetchBG()
        
        itemsBG = [BG]()
        items = [Medicine]()
        
        
        refresh()
        
//        rutinitasSection.append(RutinitasSection(rutinitasSectionTitle: "Jadwal Minum Obat"))
//        rutinitasSection.append(RutinitasSection(rutinitasSectionTitle: "Jadwal Cek Gula Darah"))
        navigationItem.title = "Daftar Rutinitas"
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        daftarRutinitasTableView.delegate = self
        daftarRutinitasTableView.delegate = self
        
        tableView?.backgroundColor = .systemGroupedBackground
        
//        let nibMedsName = UINib(nibName: "RoutinesMedsTVC", bundle: nil)
//        daftarRutinitasTableView.register(nibMedsName, forCellReuseIdentifier: "routinesMedsTVC")
        let nibBGName = UINib(nibName: "RoutinesBGTVC", bundle: nil)
        daftarRutinitasTableView.register(nibBGName, forCellReuseIdentifier: "routinesBGTVC")

    //make navbar title rounded
//        if let roundedTitleDescriptor = UIFontDescriptor
//          .preferredFontDescriptor(withTextStyle: .largeTitle)
//          .withDesign(.rounded)?
//          .withSymbolicTraits(.traitBold) {
//            self.navigationController? // Assumes a navigationController exists on the current view
//              .navigationBar
//              .largeTitleTextAttributes = [
//                .font: UIFont(descriptor: roundedTitleDescriptor, size: 0) // Note that 'size: 0' maintains the system size class
//              ]
//        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }
    
    @objc func refresh() {
        fetchMedicine()
        fetchBG()

        if(coreDataManager.items!.count > 0 || coreDataManager.bg!.count > 0){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidden"), object: nil)
        }
        else if(coreDataManager.items!.count == 0 || coreDataManager.bg!.count == 0){ //kasih kondisi kalo udah konek baru di unhidden
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhidden"), object: nil)
        }
        
    }
    
    func fetchMedicine(){
        do{
            let request = Medicine.fetchRequest() as NSFetchRequest<Medicine>
            
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.daftarRutinitasTableView.reloadData()
            }
            
        }catch{
            
        }
    }
    
    func fetchBG(){
        do{
            let request = BG.fetchRequest() as NSFetchRequest<BG>
            
            
            self.itemsBG = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.daftarRutinitasTableView.reloadData()
            }
            
        }catch{
            
        }
    }
    
    
    

    @IBAction func didTapAddMed(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Apa yang ingin kamu tambahkan?", message: nil, preferredStyle: .actionSheet)
        let actJadwalMinumObat = UIAlertAction(title: "Jadwal Minum Obat", style: .default) { _ in
            self.performSegue(withIdentifier: "addMedicationViewController", sender: nil)
        }
        let actJadwalCekGulaDarah = UIAlertAction(title: "Jadwal Cek Gula Darah", style: .default){ _ in
            self.performSegue(withIdentifier: "addBGViewController", sender: nil)
        }
//        let actInputHasilGulaDarah = UIAlertAction(title: "Input Hasil Gula Darah", style: .default)
        let actBatal = UIAlertAction(title: "Batal", style: .cancel)
        actionSheet.addAction(actJadwalMinumObat)
        actionSheet.addAction(actJadwalCekGulaDarah)
//        actionSheet.addAction(actInputHasilGulaDarah)
        actionSheet.addAction(actBatal)
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    
}

extension UIFont {
    class func rounded(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        let font: UIFont
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: size)
        } else {
            font = systemFont
        }
        return font
    }
}

extension RoutinesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//  LOGICNYA BELUM BS JALAN KARENA GAADA CORE DATA BG-NYA //
//  Kalau mau lihat cell ubah return = 2, tp kalau dihapus crash //
//        1
        
        if (self.items?.count == 0) && (self.itemsBG?.count == 0) {
            print("dapong - no bg + med")
            return 0
        }
        else if (self.items?.count != 0) && (self.itemsBG?.count == 0) {
            print("dapong - med")
            return 1
        }
        else if (self.items?.count == 0) && (self.itemsBG?.count != 0) {
            print("dapong - bg")
            return 1
            
        }
        else if (self.items?.count != 0) && (self.itemsBG?.count != 0) {
            print("dapong - bg + med")
            return 2
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        58
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            let sectionLabel = UILabel(frame: CGRect(x: 21, y: 28, width:
                tableView.bounds.size.width, height: tableView.bounds.size.height))
            sectionLabel.font = .rounded(ofSize: 16, weight: .semibold)
            sectionLabel.textColor = UIColor.black
        if ( self.items?.count == 0) {
            sectionLabel.text = rutinitasSections[section+1] // BG
        } else {
            sectionLabel.text = rutinitasSections[section] // MED
        }
        
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)

            return headerView
        }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            // cari tahu BG atau meds
            if (self.itemsBG?.count != 0 && self.items?.count != 0) {
                return items!.count
            } else if (self.itemsBG?.count != 0 && self.items?.count == 0) {
                print("dapong - bg count \(self.itemsBG?.count)")
                return itemsBG!.count
            } else if (self.itemsBG?.count == 0 && self.items?.count != 0) {
                print("dapong - med count \(self.items?.count)")
                return items!.count
            }
            return 0
        } else if (section == 1){
            return itemsBG!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0 && self.items?.count != 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoutinesMedsTVC
            cell.routinesTitleCellLbl?.text = self.items![indexPath.row].name!
            cell.routinesDescCellLbl?.text = medsTypeArr[Int(self.items![indexPath.row].eat_time)]
            let times = self.items![indexPath.row].time!
            cell.routinesTimeDescLbl?.text = ""
            for t in times {
                cell.routinesTimeDescLbl?.text! += (" \((t as! Medicine_Time).time!) ")
            }
            cell.routinesClockImgView?.image = UIImage(named: "clock")
            cell.routinesArrowImgView?.image = UIImage(named: "right-arrow")
            return cell
        }else if (indexPath.section == 0 && self.itemsBG?.count != 0 && self.items?.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "routinesBGTVC", for: indexPath) as! RoutinesBGTVC
            cell.routinesTitleCellLbl?.text = bgTypeArr[Int(self.itemsBG![indexPath.row].bg_type)]
           // cell.routinesDescCellLbl?.text = "Keterangan Blood Glucose"
            cell.routinesDescCellLbl?.text = "Setiap \(self.itemsBG![indexPath.row].bg_each_frequency) \(bgFreqArr[Int(self.itemsBG![indexPath.row].bg_frequency)]) "
            let times = self.itemsBG![indexPath.row].time!
            cell.routinesTimeDescLbl?.text = self.itemsBG![indexPath.row].bg_time
//            for t in times {
//                cell.routinesTimeDescLbl?.text! += (" \((t as! BG_Time).bg_date_item) ")
//            }
            cell.routinesClockImgView?.image = UIImage(named: "clock")
            cell.routinesArrowImgView?.image = UIImage(named: "right-arrow")
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "routinesBGTVC", for: indexPath) as! RoutinesBGTVC
            cell.routinesTitleCellLbl?.text = bgTypeArr[Int(self.itemsBG![indexPath.row].bg_type)]
           // cell.routinesDescCellLbl?.text = "Keterangan Blood Glucose"
            cell.routinesDescCellLbl?.text = "Setiap \(self.itemsBG![indexPath.row].bg_each_frequency) \(bgFreqArr[Int(self.itemsBG![indexPath.row].bg_frequency)]) "
            let times = self.itemsBG![indexPath.row].time!
            cell.routinesTimeDescLbl?.text = self.itemsBG![indexPath.row].bg_time
//            for t in times {
//                cell.routinesTimeDescLbl?.text! += (" \((t as! BG_Time).bg_date_item) ")
//            }
            cell.routinesClockImgView?.image = UIImage(named: "clock")
            cell.routinesArrowImgView?.image = UIImage(named: "right-arrow")
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
       // return
        var medDeleted = false
        var bgDeleted = false
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            if (indexPath.section == 0) {
                if (self.itemsBG?.count != 0 && self.items?.count != 0) {
                    let medicine = self.items![indexPath.row]
                    let id = medicine.id
                    
                    // delete on firebase
                    MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeMedToFirestore(id: id!)
                    
                    self.context.delete(medicine)
                    let deletedId: [String] = [medicine.id!]
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: deletedId)
                    medDeleted = true
                    do{
                        try self.context.save()
                    }catch{
                    }
                    self.fetchMedicine()
                    
                    
                } else if (self.itemsBG?.count != 0 && self.items?.count == 0) {
                    let bg = self.itemsBG![indexPath.row]
                    let idBG = bg.bg_id
                    
                    // delete on firebase
                    coreDataManager.removeAllLogBGAfter(bg: bg, date: Date())
                    MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeBGToFirestore(id: idBG!)
                    
                    self.context.delete(bg)
                    let deletedIdBG: [String] = [bg.bg_id!]
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: deletedIdBG)
                    bgDeleted = true
                    do{
                        try self.context.save()
                    }catch{
                    }
                    self.fetchBG()
                    
                    
                } else if (self.itemsBG?.count == 0 && self.items?.count != 0) {
                    let medicine = self.items![indexPath.row]
                    let id = medicine.id
                    
                    // delete on firebase
                    MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeMedToFirestore(id: id!)
                    
                    self.context.delete(medicine)
                    let deletedId: [String] = [medicine.id!]
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: deletedId)
                    medDeleted = true
                    do{
                        try self.context.save()
                    }catch{
                    }
                    self.fetchMedicine()
                    
                }
            } else if (indexPath.section == 1){
                let bg = self.itemsBG![indexPath.row]
                let idBG = bg.bg_id
                
                // delete on firebase
                coreDataManager.removeAllLogBGAfter(bg: bg, date: Date())
                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeBGToFirestore(id: idBG!)
                
                self.context.delete(bg)
                let deletedIdBG: [String] = [bg.bg_id!]
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: deletedIdBG)
                bgDeleted = true
                
                do{
                    try self.context.save()
                }catch{
                }
                
                self.fetchBG()
                
            }
            
            
            tableView.reloadData()
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("Ini nilai indexpathsection dan items count" ,indexPath.section, self.items!.count)
            if((indexPath.section == 0 && self.items!.count > 0 && self.itemsBG!.count > 0 && bgDeleted == false) || (indexPath.section == 0 && self.items!.count == 0  && self.itemsBG!.count > 0 && medDeleted == false)){
                print("JUMLAH MED \(self.items!.count)")
            }else{
                if (indexPath.section == 0 && self.items!.count == 0) {
                    tableView.deleteSections(IndexSet(integer: 0), with: .fade)
                } else if (indexPath.section == 1 && self.itemsBG!.count == 0 && self.items!.count != 0) {
                    tableView.deleteSections(IndexSet(integer: 1), with: .fade)
                }
            }
                
//            tableView.deleteSections(IndexSet(integer: 0), with: .fade)
            tableView.endUpdates()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        }
    }
}
