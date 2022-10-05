//
//  EmptySpaceViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 22/06/22.
//

import UIKit

class EmptySpaceViewController: UIViewController {
    
    

    @IBAction func addMedBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "addMedicationViewController", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableHidden), name: NSNotification.Name(rawValue: "hidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unableHidden), name: NSNotification.Name(rawValue: "unhidden"), object: nil)
//        view.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @objc func enableHidden(){
        view.frame = self.view.bounds
        view.isHidden = true
    }
    
    @objc func unableHidden(){
        view.frame = self.view.bounds
        view.isHidden = false
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
