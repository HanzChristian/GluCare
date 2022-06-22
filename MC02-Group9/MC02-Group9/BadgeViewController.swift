//
//  BadgeViewController.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 21/06/22.
//

import UIKit

class BadgeViewController: UIViewController {
    
//    private let lblStreak: UILabel = {
//       let lblStreak = UILabel()
//        lblStreak.textAlignment = .center
//        lblStreak.text = """
//                         1/7
//                         day(s) streak
//                         """
//        lblStreak.font = .systemFont(ofSize: 12, weight: .light)
//        return lblStreak
//    }()
    
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblStreak: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configuration()
        circleBar()
        

    }
    
    func configuration(){
        title = "Badge"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // config label
        lblDays.text = "1/7"
        lblStreak.text = "day streaks"
//        lblStreak.sizeToFit()
//        view.addSubview(lblStreak)
//        lblStreak.center = view.center
    }
    
    func circleBar(){
        let circlePath = UIBezierPath(arcCenter: view.center, radius: 150, startAngle: -(.pi/2), endAngle: .pi*2, clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circlePath.cgPath
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.lineWidth = 15
        trackShape.strokeColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(trackShape)
        
        let shape = CAShapeLayer()
        shape.path = circlePath.cgPath
        shape.lineWidth = 15 // border
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeEnd = 0
        shape.strokeColor = UIColor.blue.cgColor
        view.layer.addSublayer(shape)
        
        // animation
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0.4
        animation.duration = 2
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        shape.add(animation, forKey: "animation")
    }

}
