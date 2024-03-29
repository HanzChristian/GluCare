//
//  BGCalendarTableViewCell.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 13/10/22.
//

import UIKit

class BGCalendarTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var calendarCollectionView:UICollectionView!
    var calendarModel = [CalendarModel]()
    var calendarMonthModel:[CalendarModel]?
    var calendarWiden:Bool = false

    
    override func awakeFromNib() {
        super.awakeFromNib()
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        
        collectionViewLayout()
        let nibBGCalendarCV = UINib(nibName: "BGCalendarCollectionViewCell", bundle: nil)
        calendarCollectionView.register(nibBGCalendarCV, forCellWithReuseIdentifier: "bgCalendarCollectionViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.wideCalendarSelected), name: NSNotification.Name(rawValue: "wideCalendar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.narrowCalendarSelected), name: NSNotification.Name(rawValue: "narrowCalendar"), object: nil)
        
    }
    
    @objc func wideCalendarSelected(){
        calendarWiden = true
    }
    
    @objc func narrowCalendarSelected(){
        calendarWiden = false
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with model: [CalendarModel]){
        self.calendarModel = model

        calendarCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "bgCalendarCollectionViewCell", for: indexPath) as! BGCalendarCollectionViewCell?
        cell?.configure(with: calendarModel[indexPath.row])
        let blue = UIColor(red: 30/255, green: 132/255, blue: 198/255, alpha: 1)
        
        //belom kelar
//        if(CalendarViewModel.calendarViewModel.calendarModel![indexPath.row].isSelected == true){
//            cell!.backgroundColor = .systemGroupedBackground
//            cell!.layer.cornerRadius = 20
//        }
        
        cell!.backgroundColor = .white
        cell!.layer.cornerRadius = 0
        cell!.calendarLbl.textColor = .black
        cell!.calendarLbl.layer.cornerRadius = 0
        
        if(calendarWiden == false){
            if(CalendarViewModel.calendarViewModel.calendarModel![indexPath.row].isSelected == true){
                cell!.backgroundColor = blue
                cell!.calendarLbl.textColor = .white
                cell!.calendarLbl.layer.cornerRadius = 20
                cell!.layer.cornerRadius = 20
                print("TESTESTESTESTES")
            }
//            }else{
//                cell!.backgroundColor = .white
//                cell!.layer.cornerRadius = 0
//                print("TISTISTISTISTIS")
//            }
        }else{
            if(CalendarViewModel.calendarViewModel.calendarMonthModel![indexPath.row].isSelected == true){
                cell!.backgroundColor = blue
                cell!.calendarLbl.textColor = .white
                cell!.layer.cornerRadius = 20
                cell!.calendarLbl.layer.cornerRadius = 20
                print("TESTESTESTESTES")
            }
            
            
        }
//        reloadCollectionView()
        return cell!
        
    }
    
    func reloadCollectionView(){
        do{
            DispatchQueue.main.async {
                self.calendarCollectionView.reloadData()
            }
        }catch{

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if(calendarWiden == false){
            print("kontolodon megalodon \(CalendarViewModel.calendarViewModel.calendarModel![indexPath.row])")
            
            if(CalendarViewModel.calendarViewModel.calendarModel![indexPath.row].isSelected == false){
                CalendarViewModel.calendarViewModel.calendarModel![indexPath.row].isSelected = true
                reloadCollectionView()
            }else{
                CalendarViewModel.calendarViewModel.calendarModel![indexPath.row].isSelected = false
                reloadCollectionView()
            }
        }else{
            print("kontolodon megalodon \(CalendarViewModel.calendarViewModel.calendarMonthModel![indexPath.row])")
            
            if(CalendarViewModel.calendarViewModel.calendarMonthModel![indexPath.row].isSelected == false){
                CalendarViewModel.calendarViewModel.calendarMonthModel![indexPath.row].isSelected = true
                reloadCollectionView()
            }else{
                CalendarViewModel.calendarViewModel.calendarMonthModel![indexPath.row].isSelected = false
                reloadCollectionView()
            }
        }
        
        
    }
    
    func collectionViewLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = (calendarCollectionView.frame.size.width) / 7
        let height = (calendarCollectionView.frame.size.height)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: width, height: height)
        calendarCollectionView!.collectionViewLayout = layout
    }
    
    
    
}
