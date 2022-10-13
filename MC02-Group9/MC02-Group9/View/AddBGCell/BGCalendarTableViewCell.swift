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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        
        let nibBGCalendarCV = UINib(nibName: "BGCalendarCollectionViewCell", bundle: nil)
        calendarCollectionView.register(nibBGCalendarCV, forCellWithReuseIdentifier: "bgCalendarCollectionViewCell")
        
        
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
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        print("kontolodon megalodon \(CalendarViewModel.calendarViewModel.calendarModel)")
        CalendarViewModel.calendarViewModel.calendarModel![indexPath.row].isSelected = true
    }
    
    
    
}
