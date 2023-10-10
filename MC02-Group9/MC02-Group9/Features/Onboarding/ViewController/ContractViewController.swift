//
//  ViewController.swift
//  SampleCoreAnimation
//
//  Created by Christophorus Davin on 13/01/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import RxSwift

class ContractViewController: UIViewController {

  // MARK: - UI Properties
  @IBOutlet weak var greetingsLabel: UILabel!
  @IBOutlet weak var attributedLabel: UILabel!
  var circleView = CircleView()
  let _width: CGFloat = 75
  let _height: CGFloat = 75
  let _diff: CGFloat = 32
  let blue75 = #colorLiteral(red: 0.337254902, green: 0.6392156863, blue: 0.831372549, alpha: 1)
  let blue25 = #colorLiteral(red: 0.7803921569, green: 0.8784313725, blue: 0.9450980392, alpha: 1)

  // MARK: - Properties
  var userType: UserType?
  private let navigator = DefaultOnboardingNavigator()
  private let disposeBag = DisposeBag()
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

    observeValues()

    attributedLabel.attributedText = attributedText(
      withString: "Tahan tombol di bawah ini sebagai bentuk komitmen kamu untuk mencapai tujuan!", boldString: "Tahan tombol",
      font: attributedLabel.font)

    setupCircleView()
  }

  func observeValues() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    AuthService.shared.fetchUser(uid: uid).subscribe(onNext: { [weak self] user in
      guard let self = self else { return }
      self.greetingsLabel.text = "Hi \(user.fullname)"
    })
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
      guard let self = self else { return }

      if self.action.count > 0 && self.action[0] == id{
        self.isFinishAnimating = true
        self.circleView.layer.transform = CATransform3DMakeScale(CGFloat(scaleSize),CGFloat(scaleSize),1)

        // Faster Speed
        animation.keyPath = "transform.scale"
        animation.fromValue = scaleSize
        animation.toValue = 50
        animation.duration = 1.25

        self.circleView.layer.add(animation, forKey: "basic")
        self.circleView.layer.transform = CATransform3DMakeScale(CGFloat(50),CGFloat(50),1)

        AuthService.shared.addRole(userType: self.userType) { [weak self] error, _ in
          guard let self = self else { return }
          self.navigator.navigateToHomeKonfirmasiFromContract(from: self)
        }
      }
    }

  }
}

