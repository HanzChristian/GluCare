//
//  OnBoardingViewController.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 26/10/22.
//

import UIKit

class OnBoardingViewController: UIViewController {
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var onboardImg: UIImageView!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var pageCtrlImg: UIImageView!
    
    @IBAction func skipBtnAction(_ sender: UIButton) {
        showItem(at: 2)
        thirdShow(true)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        currPage = 0
        firstShow(true)
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        if currPage == 0 {
            currPage = 1
            secondShow(true)
        }
        else if currPage == 1 {
            thirdShow(true)
        }
    }
    @IBAction func signupBtnAction(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRoleManagementVC", sender: self)
    }
    
    var currPage = 0
    
    let titleArray = ["Bantu kamu ingat minum obat",
                           "Buat target diabetes kamu",
                           "Kelola bersama keluarga"
    ]
    let subtitleArray = ["Catat seluruh jadwal obat kamu di satu aplikasi, GluCare siap bantu kamu ingatkan minum obat",
                              "Kelola diabetesmu dengan target yang jelas! Studi menunjukkan bahwa target dapat membantu kamu lebih termotivasi.",
                              "Ajak keluarga kamu untuk mencapai target pengelolaan diabetes kamu di dalam satu aplikasi!"
    ]
    let imageArray = [
        ImageHelper.onboard1,
        ImageHelper.onboard2,
        ImageHelper.onboard3
    ]
}

class Core{
    static let shared = Core()
    func isNewUser() -> Bool{
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    func notNewUser(){
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}

extension OnBoardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        firstShow(true)
        backBtn.layer.cornerRadius = 12
        nextBtn.layer.cornerRadius = 12
        signupBtn.layer.cornerRadius = 12
        signupBtn.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Core.shared.isNewUser(){
            Core.shared.notNewUser()
        }
        else{

            let mainAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main")
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window{
                window.rootViewController = mainAppViewController
                UIView.transition(with: window,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve,
                                  animations: nil,
                                  completion: nil)
                
            }
        }
    }
}

extension OnBoardingViewController {
    private func firstShow(_ bool: Bool) {
        onboardImg.image = UIImage(named: "onboard1")
        pageCtrlImg.image = UIImage(named: "ctrl-page-1")
        backBtn.isHidden = bool
        nextBtn.isHidden = !bool
        skipBtn.isHidden = !bool
        signupBtn.isHidden = bool
        titleLbl.text = titleArray[0]
        subtitleLbl.text = subtitleArray[0]
    }
    
    private func secondShow(_ bool: Bool) {
        onboardImg.image = UIImage(named: "onboard2")
        pageCtrlImg.image = UIImage(named: "ctrl-page-2")
        backBtn.isHidden = !bool
        nextBtn.isHidden = !bool
        skipBtn.isHidden = !bool
        signupBtn.isHidden = bool
        
        titleLbl.text = titleArray[1]
        subtitleLbl.text = subtitleArray[1]
    }
    
    private func thirdShow(_ bool: Bool) {
        onboardImg.image = UIImage(named: "onboard3")
        pageCtrlImg.image = UIImage(named: "ctrl-page-3")
        backBtn.isHidden = bool
        nextBtn.isHidden = bool
        skipBtn.isHidden = bool
        signupBtn.isHidden = !bool
        titleLbl.text = titleArray[2]
        subtitleLbl.text = subtitleArray[2]
    }
    
    private func showItem(at index: Int) {
        firstShow(index == 0)
        secondShow(index == 1)
        thirdShow(index == 2)
        let indexPath = IndexPath(item: index, section: 0)
    }
}
