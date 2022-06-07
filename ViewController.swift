//
//  ViewController.swift
//  Testing
//
//  Created by Hanz Christian on 07/06/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var haloText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func KlikBtn(_ sender: UIButton) {
        haloText.text = "bye"
    }
    
}

