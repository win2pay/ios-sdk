 //
//  WPPayTestField.swift
//  WintopaySDK
//
//  Created by 易购付 on 2022/4/8.
//

import UIKit

///输入框类型
enum WPPayTextFieldType {
    ///正常
   case normal
    ///选择器
   case addressPick
}

///地址输入框名字
enum WPAdressPayTextFieldName:String {
    ///卡号
    case CardNumber = "Card number"
    ///日期
    case CardDate = "Date"
    ///CVC
    case CardCVC = "CVC"
    
    case first_name = "First Name"
    case last_name = "Last Name"
    case Country = "Country"
    case State = "State/Province"
    case City = "City"
    case Address = "Address"
    case PostCode = "PostCode"
    case Phone = "Phone"
    case Ssuing = "Ssuing Bank"
    case Email = "Email"
}

class WPPayTextField: UITextField {
    
    ///输入框类型
    var type:WPPayTextFieldType = .normal
    
    ///标题名字
    var name:WPAdressPayTextFieldName = .first_name
    
    ///所在的位置
    var indexPath:IndexPath = IndexPath.init(row: 0, section: 0)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 14, height: 0))
        self.leftViewMode = .always
      
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
       
    }
    
}


