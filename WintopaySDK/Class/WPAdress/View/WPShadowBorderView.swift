//
//  WPShadowBorderView.swift
//  payAdress
//
//  Created by 易购付 on 2022/4/12.
//

import UIKit

class WPShadowBorderView: UIView {

    override func draw(_ rect: CGRect) {
        let shadowView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        shadowView.layer.shadowColor = UIColor.init(hexStr: "#12253E").cgColor
        shadowView.layer.shadowOffset = CGSize.init(width: 0, height: 0.5)
        shadowView.layer.shadowOpacity = 0.21
        shadowView.layer.shadowRadius = 1
        shadowView.layer.cornerRadius = 4
        shadowView.layer.shadowPath = UIBezierPath.init(roundedRect: bounds, cornerRadius: 4).cgPath
        shadowView.backgroundColor = .white
        shadowView.isUserInteractionEnabled = true
        layer.insertSublayer(shadowView.layer, at: 0)

        let bordeLayer = CALayer.init()
        bordeLayer.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        bordeLayer.borderWidth = 0.4
        bordeLayer.cornerRadius = 4
        bordeLayer.borderColor = UIColor.init(hexStr: "#ECF0F4").cgColor
        layer.addSublayer(bordeLayer)
    
    }
}
