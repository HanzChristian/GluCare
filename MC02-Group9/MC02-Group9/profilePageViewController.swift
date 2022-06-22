//
//  profilePageViewController.swift
//  MC02-Group9
//
//  Created by Noah S on 14/06/22.
//

import UIKit
import CoreData

class profilePageViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[Medicine]?
    
    /*
    var dummyModel = [
        "Metformin",
        "Paracetamol",
        "Aspirin",
        "Milkita"
    ]
     */
    
    
    @IBOutlet weak var obatKamuTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMedicine()
        
        obatKamuTableView.delegate = self
        obatKamuTableView.delegate = self
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
                self.obatKamuTableView.reloadData()
            }
            
        }catch{
            
        }
    }
    
    @IBAction func editMedicationPressed(_ sender: Any) {
        obatKamuTableView.isEditing = !obatKamuTableView.isEditing
        
        if obatKamuTableView.isEditing {
            editButton.title = "Selesai"
        } else {
            editButton.title = "Ubah"
        }

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.items![indexPath.row].name
        return cell
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
            
            do{
                try self.context.save()
            }catch{
                
            }
            
            self.fetchMedicine()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            
            tableView.endUpdates()
        }
    }
    
}
