//
//  CircleView.swift
//  SampleCoreAnimation
//
//  Created by Christophorus Davin on 13/01/23.
//

import UIKit

class CircleView: UIView {
    
    let _width: CGFloat = 75
    let _height: CGFloat = 75
    let _diff: CGFloat = 32
    
    var circleButton = UIButton()
    var any = 50
    
    let blue75 = #colorLiteral(red: 0.337254902, green: 0.6392156863, blue: 0.831372549, alpha: 1)
    let blue25 = #colorLiteral(red: 0.7803921569, green: 0.8784313725, blue: 0.9450980392, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layer.cornerRadius = (_width + _diff) / 2
        backgroundColor = blue25
        layout()
        style()
    }

    func style(){
        circleButton.backgroundColor = blue75
        circleButton.frame = CGRect(x: 100, y: 100, width: _width, height: _height)
        circleButton.layer.cornerRadius = circleButton.frame.size.width / 2
        circleButton.clipsToBounds = true
        circleButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout(){
        addSubview(circleButton)
        
        NSLayoutConstraint.activate([
            circleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: _diff/2),
            circleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -_diff/2),
            circleButton.topAnchor.constraint(equalTo: topAnchor, constant: _diff/2),
            circleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -_diff/2),
        ])
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: _width + _diff, height: _height + _diff)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
