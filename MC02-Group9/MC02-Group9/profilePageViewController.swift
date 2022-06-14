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
    override func viewDidLoad() {
        super.viewDidLoad()
        obatKamuTableView.delegate = self
        obatKamuTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editMedicationPressed(_ sender: Any) {
        obatKamuTableView.isEditing = !obatKamuTableView.isEditing
    }
    
//    @IBAction func btnClicked(_ sender: Any) {
//        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMedicationViewController") as? AddMedicationViewController else {
//            print("Error")
//            return
//        }
//
//        let navVC = UINavigationController(rootViewController: vc)
//
//        present(navVC, animated: true)
//
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
