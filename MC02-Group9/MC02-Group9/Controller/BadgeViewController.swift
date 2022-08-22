//
//  BadgeViewController.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 21/06/22.
//

import UIKit
import CoreData

class BadgeViewController: UIViewController {
    
    
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblStreak: UILabel!
    @IBOutlet weak var lblBtmTitle: UILabel!
    @IBOutlet weak var lblBtmTxt: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var streaks:[Streak]?
    
    var maxStreak:Int = 10
    let debugStreak:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchStreak()
        configuration()
        circleBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newStreak"), object: nil)
    }
    
    @objc func refresh() {
        fetchStreak()
        configuration()
        circleBar()
    }
    
    func fetchStreak(){
        do{
            let request = Streak.fetchRequest() as NSFetchRequest<Streak>
            
            self.streaks = try context.fetch(request)
            
        }catch{
            
        }
        if(streaks!.count + debugStreak <= 10){
            maxStreak = 10
        }else{
            maxStreak = 10
            while(streaks!.count + debugStreak - 1 >= maxStreak){
                maxStreak = maxStreak * 2
            }
        }
    }

    func configuration(){
        
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
        
//        title = "Pencapaian"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // config label day
        lblDays.text = "\(streaks!.count + debugStreak) / \(maxStreak)" // Set logicny
        lblDays.font = .rounded(ofSize: 34, weight: .semibold)
        
        // Config lbl day txt
        lblStreak.text = "day streaks"
        lblStreak.font = .rounded(ofSize: 20, weight: .semibold)
        
        // Config bottom title
        lblBtmTitle.text = "Lanjutkan Perjuanganmu!"
        lblBtmTitle.font = .rounded(ofSize: 20, weight: .semibold)
        
        // Config bottom description
        lblBtmTxt.text = "Dengan membangun streak, kamu dapat membangun rutinitas konsumsi obat yang baik."
        lblBtmTxt.font = .systemFont(ofSize: 16, weight: .regular)
//        lblStreak.sizeToFit()
//        view.addSubview(lblStreak)
//        lblStreak.center = view.center
    }
    
    func streaksCount(){
        // Logic Streak
    }
    
    func circleBar(){
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.center.x, y: 350), radius: 150, startAngle: -(.pi/2), endAngle: .pi*1.5, clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circlePath.cgPath
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.lineWidth = 15
        trackShape.strokeColor = hexStringToUIColor(hex: "#EAEAEA").cgColor
        view.layer.addSublayer(trackShape)
        
        let shape = CAShapeLayer()
        shape.path = circlePath.cgPath
        shape.lineWidth = 15 // border
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeEnd = 0
        shape.strokeColor = hexStringToUIColor(hex: "#56A3D4").cgColor
        view.layer.addSublayer(shape)
        
        // animation
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        if(streaks!.count + debugStreak <= 10){
            animation.toValue = 0.00 + Float(Float(streaks!.count + debugStreak) / Float(maxStreak))
        }else{
            animation.toValue = 0.00 + Float(Float(streaks!.count + debugStreak - (maxStreak/2)) / Float(maxStreak/2)) // value akhir buat animationnya
        }
        
        animation.duration = 2
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        shape.add(animation, forKey: "animation")
    }
    
    // Function buat pake hex color
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
