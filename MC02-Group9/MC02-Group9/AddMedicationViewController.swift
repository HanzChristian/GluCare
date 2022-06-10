//
//  AddMedicationViewController.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 08/06/22.
//

import UIKit

class AddMedicationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissSelf))
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    
}
