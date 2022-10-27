//
//  OnBoardingVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 24/10/22.
//

import UIKit

class OnBoardingVC: UIViewController {
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func skipBtnAction(_ sender: UIButton) {
        showItem(at: 2)
        thirdShow(true)
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
    }
    @IBAction func nextBtnAction(_ sender: UIButton) {
    }
    @IBAction func signupBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func pageValueChanged(_ sender: Any) {
        showItem(at: pageControl.currentPage)
    }
    
    
    
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

// - View Life Cycle
extension OnBoardingVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        backBtn.layer.cornerRadius = 12
        nextBtn.layer.cornerRadius = 12
        signupBtn.layer.cornerRadius = 12
        signupBtn.isHidden = true
        
        pageControl.page = 0
        
    }
}

extension OnBoardingVC {
    private func firstShow(_ bool: Bool) {
        backBtn.isHidden = bool
        nextBtn.isHidden = !bool
        skipBtn.isHidden = !bool
        signupBtn.isHidden = bool
    }
    
    private func secondShow(_ bool: Bool) {
        backBtn.isHidden = !bool
        nextBtn.isHidden = !bool
        skipBtn.isHidden = !bool
        signupBtn.isHidden = bool
    }
    
    private func thirdShow(_ bool: Bool) {
        backBtn.isHidden = bool
        nextBtn.isHidden = bool
        skipBtn.isHidden = bool
        signupBtn.isHidden = !bool
    }
    
    private func showItem(at index: Int) {
        firstShow(index == 0)
        secondShow(index == 1)
        thirdShow(index == 2)
        pageControl.page = index
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
    }
}

// UICollection View Delegate & DataSources
extension OnBoardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardingCVCell", for: indexPath) as! OnBoardingCVCell
//        cell.onboardImageWidthConstraint.constant = normalize(value: 260.0)
        cell.onboardImgView.image = imageArray[indexPath.row]
        cell.titleLbl.text = titleArray[indexPath.row]
        cell.subtitleLbl.text = subtitleArray[indexPath.row]
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        pageControl.page = page
        firstShow(page == 0)
        secondShow(page == 1)
    }
    
    
}

extension UIPageControl {
    var page: Int {
        get {
            return currentPage
        }
        set {
            currentPage = newValue
//            setIndicatorImage(ImageHelper.pageSelected, forPage: newValue)
            for index in 0..<numberOfPages where index != newValue {
                setIndicatorImage(ImageHelper.page, forPage: index)
//                preferredIndicatorImage = ImageHelper.page
            }
            setIndicatorImage(ImageHelper.pageSelected, forPage: newValue)
        }
    }
}

func normalize(value: CGFloat) -> CGFloat {
    let scale = UIScreen.main.bounds.width / 375.0
    return value * scale
}
