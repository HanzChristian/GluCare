////
////  GuideViewController.swift
////  MC02-Group9
////
////  Created by Hanz Christian on 26/06/22.
////
//
//import UIKit
//import Gecco
//
//class GuideViewController: SpotlightViewController {
//    
//    @IBOutlet var annotationViews: [UIView]!
//    
//    var index = 0
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        delegate = self
//
//        // Do any additional setup after loading the view.
//    }
//    
//    func next(_ labelAnimated:Bool){
//        updateAnnotationView(labelAnimated)
////        let screenSize = UIScreen.main.bounds.size
//        switch index {
//        case 0 :
//            spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: 0, y: 190), size: CGSize(width: 800, height: 87), cornerRadius: 10))
//        case 1 :
//            spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: 0, y: 273), size: CGSize(width: 800, height: 68), cornerRadius: 10))
//        case 2 :
//            spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: 65, y: 790), size: CGSize(width: 65, height: 65), cornerRadius: 10))
//        case 3 :
//            spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: 195, y: 790), size: CGSize(width: 65, height: 65), cornerRadius: 10))
//        case 4 :
//            spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: 325, y: 790), size: CGSize(width: 65, height: 65), cornerRadius: 10))
//        case 5 :
//            dismiss(animated: true,completion: nil)
//        default:
//            break
//        }
//        
//        index += 1
//    }
//    
//    func updateAnnotationView(_ animated: Bool){
//        annotationViews.enumerated().forEach{(arg0) in
//            let (index, view) = arg0
//            UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
//                view.alpha = index == self.index ? 1 : 0
//            })
//        }
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//extension GuideViewController: SpotlightViewControllerDelegate{
//    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
//        next(false)
//    }
//    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
//        spotlightView.disappear()
//    }
//    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {
//        next(true)
//    }
//    
//}
