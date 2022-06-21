//
//  profilePageViewController.swift
//  MC02-Group9
//
//  Created by Noah S on 14/06/22.
//

import UIKit

class profilePageViewController: UIViewController {
    
    var dummyModel = [
        "Metformin",
        "Paracetamol",
        "Aspirin",
        "Milkita"
    ]
    
    
    @IBOutlet weak var obatKamuTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return dummyModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dummyModel[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            //REMOVE FROM CORE DATA HERE!
            dummyModel.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
}
