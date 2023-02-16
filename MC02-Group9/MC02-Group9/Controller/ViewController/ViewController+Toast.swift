//
//  ViewController+Toast.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 16/02/23.
//

import UIKit

extension ViewController{
    
    func showToastSkip(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 16, y: 690, width: 358, height: 48))
        
        toastLabel.backgroundColor = UIColor(rgb: 0xDE6FB3)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToastTake(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 16, y: 690, width: 358, height: 48))
        
        toastLabel.backgroundColor = UIColor(rgb: 0x56A3D4)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToastUndo(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 16, y: 690, width: 358, height: 48))
        toastLabel.backgroundColor = .gray
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
}

