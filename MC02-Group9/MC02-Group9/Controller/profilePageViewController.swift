//
//  profilePageViewController.swift
//  MC02-Group9
//
//  Created by Noah S on 14/06/22.
//

import UIKit
import CoreData

class RutinitasSection {
    var rutinitasSectionTitle: String?
    init(rutinitasSectionTitle: String) {
        self.rutinitasSectionTitle = rutinitasSectionTitle
    }
}

class profilePageViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var rutinitasSection = [RutinitasSection]()
    var items:[Medicine]?
    
    @IBOutlet weak var daftarRutinitasTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMedicine()
        rutinitasSection.append(RutinitasSection.init(rutinitasSectionTitle: "Jadwal Minum Obat"))
        rutinitasSection.append(RutinitasSection.init(rutinitasSectionTitle: "Jadwal Cek Gula Darah"))
        
        daftarRutinitasTableView.delegate = self
        daftarRutinitasTableView.delegate = self
        view.backgroundColor = .systemGroupedBackground
        

    //make navbar title rounded
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }
    
    @objc func refresh() {
        fetchMedicine()
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
    
    
    

    @IBAction func didTapAddMed(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Apa yang ingin kamu tambahkan?", message: nil, preferredStyle: .actionSheet)
        let actJadwalMinumObat = UIAlertAction(title: "Jadwal Minum Obat", style: .default) { _ in
            self.performSegue(withIdentifier: "addMedicationViewController", sender: nil)
        }
        let actJadwalCekGulaDarah = UIAlertAction(title: "Jadwal Cek Gula Darah", style: .default){ _ in
            self.performSegue(withIdentifier: "addBGViewController", sender: nil)
        }
        let actInputHasilGulaDarah = UIAlertAction(title: "Input Hasil Gula Darah", style: .default)
        let actBatal = UIAlertAction(title: "Batal", style: .cancel)
        actionSheet.addAction(actJadwalMinumObat)
        actionSheet.addAction(actJadwalCekGulaDarah)
        actionSheet.addAction(actInputHasilGulaDarah)
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

extension profilePageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
//        if self.items?.count == 0 {
//            return 0
//        }
//        else {
//            return 1
//        }
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
            sectionLabel.text = rutinitasSection[section].rutinitasSectionTitle
            sectionLabel.sizeToFit()
            headerView.addSubview(sectionLabel)

            return headerView
        }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = self.items![indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoutinesTVC
        cell.routinesTitleCellLbl?.text = self.items![indexPath.row].name!
        cell.routinesDescCellLbl?.text = "Ini keterangan"
        let times = self.items![indexPath.row].time!
        cell.routinesTimeDescLbl?.text = ""
        for t in times {
            cell.routinesTimeDescLbl?.text! += (" \((t as! Medicine_Time).time!) ")
        }
        cell.routinesClockImgView?.image = UIImage(named: "clock")
        cell.routinesArrowImgView?.image = UIImage(named: "right-arrow")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            //REMOVE FROM CORE DATA HERE!
            // dummyModel.remove(at: indexPath.row)
            let medicine = self.items![indexPath.row]
            self.context.delete(medicine)
            let deletedId: [String] = [medicine.id!]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: deletedId)
            
            do{
                try self.context.save()
            }catch{
            }
            
            self.fetchMedicine()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
//            context.delete(Medicine[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
            do{
                try self.context.save()
            }catch{
                
            }
//            self.saveData()
        }
    }
    
}
