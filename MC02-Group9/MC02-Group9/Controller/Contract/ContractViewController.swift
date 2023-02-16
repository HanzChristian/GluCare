//
//  ViewController.swift
//  SampleCoreAnimation
//
//  Created by Christophorus Davin on 13/01/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ContractViewController: UIViewController {
    let db = Firestore.firestore()
    var circleView = CircleView()
    
    let _width: CGFloat = 75
    let _height: CGFloat = 75
    let _diff: CGFloat = 32
    
    let blue75 = #colorLiteral(red: 0.337254902, green: 0.6392156863, blue: 0.831372549, alpha: 1)
    
    let blue25 = #colorLiteral(red: 0.7803921569, green: 0.8784313725, blue: 0.9450980392, alpha: 1)

    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var attributedLabel: UILabel!
    
    var isFinishAnimating = false
    
    var action = [String]()
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        greetingsLabel.text = "Hi \(UserDefaults.standard.value(forKey: "nama")!)"
        
        attributedLabel.attributedText = attributedText(
            withString: "Tahan tombol di bawah ini sebagai bentuk komitmen kamu untuk mencapai tujuan!", boldString: "Tahan tombol",
            font: attributedLabel.font)
        
        setupCircleView()
    }
    
    func setupCircleView(){
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(circleView)
        
        circleView.circleButton.addTarget(self, action: #selector(didTap), for: .touchDown)
        circleView.circleButton.addTarget(self, action: #selector(didRelease), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            circleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
    
    
    
    @objc func didTap(){
        
        print("DID TAP")
        if isFinishAnimating == false{
            action.append(UUID().uuidString)
            
            animate()
        }
        
    }
    
    @objc func didRelease(){
        
        print("DID RELEASE")
        if isFinishAnimating == false{
            action.remove(at: 0)
            
            self.circleView.layer.removeAllAnimations()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func animate(){
        let animation = CABasicAnimation()
        let durationFinish: Double = 1.75
        let scaleSize = 1.5
        
        animation.keyPath = "transform.scale"
        animation.fromValue = 1
        animation.toValue = scaleSize
        animation.duration = durationFinish
        
        circleView.layer.add(animation, forKey: "basic")
        
        let id = action[0]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + durationFinish){ [weak self] in

            if self!.action.count > 0 && self!.action[0] == id{
    
                self!.isFinishAnimating = true
                self!.circleView.layer.transform = CATransform3DMakeScale(CGFloat(scaleSize),CGFloat(scaleSize),1)
                
                // Faster Speed
                animation.keyPath = "transform.scale"
                animation.fromValue = scaleSize
                animation.toValue = 50
                animation.duration = 1.25
                
                self!.circleView.layer.add(animation, forKey: "basic")
                self!.circleView.layer.transform = CATransform3DMakeScale(CGFloat(50),CGFloat(50),1)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    self!.addRoleDataToFirebase()
                }
            }
        }
        
    }
    func addRoleDataToFirebase(){
        
        if  let user = Auth.auth().currentUser?.uid{
    
            let roleUserDefault = RoleHelper.instance.getRole() - 1
            let nama = UserDefaults.standard.string(forKey: "nama")
            
            self.db.collection("account").addDocument(data: [
                "roleId": roleUserDefault,
                "nama": "\(nama!)",
                "owner": "\(user)"
            ]){ (error) in
                if let e = error {
                    print("failed saved data \(e)")
                }else{
                    print("success saved data")
                    // make segue
                    FirebaseManager.firebaseManager.getAccountInfo()
                    self.performSegue(withIdentifier: "goToHomeKonfirmasi", sender: self)
                }
            }
        }
    }
    


}

