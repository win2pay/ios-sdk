//
//  WPValidityTextFieldView.swift
//  WintopaySDK
//
//  Created by 易购付 on 2021/6/2.
//

import UIKit

class WPValidityTextFieldView: UIView,UITextFieldDelegate{
    
    ///年月
   open var dateTextField:UITextField = UITextField.init()
    
    ///CVV
   open var CVVTextField:UITextField = UITextField.init()
    
    ///间隔
   open var wall:UIView = UIView()
    
 
  
    init(){
        super.init(frame: .zero)
    
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(hexStr:"#A2B9CC").cgColor
        self.layer.cornerRadius = 8
        
        self.addSubview(dateTextField)

        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        dateTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 2).isActive = true
        dateTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 6).isActive = true
        dateTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5, constant: -6).isActive = true
      
        
        let basicView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 34, height: 30))
        let cardImageView = UIImageView()
        cardImageView.image = UIImage.WPBundleImage(name: "card.png")
        basicView.addSubview(cardImageView)
        cardImageView.frame = CGRect.init(x: 0, y:0, width: 22, height: 18)
        cardImageView.center = basicView.center
        dateTextField.leftView = basicView
        dateTextField.leftViewMode = .always
        dateTextField.keyboardType = .numberPad
        dateTextField.delegate = self
        dateTextField.placeholder = "MM/YYYY"
        
        self.addSubview(CVVTextField)
        
        CVVTextField.translatesAutoresizingMaskIntoConstraints = false
        CVVTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        CVVTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 2).isActive = true
        CVVTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        CVVTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5, constant: 0).isActive = true
        
        
        CVVTextField.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 0))
        CVVTextField.leftViewMode = .always
        
        let CVVBasicView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 34, height: 30))
        let CVVImageView = UIImageView()
        CVVImageView.image = UIImage.WPBundleImage(name: "cvc.png")
        CVVBasicView.addSubview(CVVImageView)
        CVVImageView.frame = CGRect.init(x: 0, y:0, width: 22, height: 18)
        CVVImageView.center = basicView.center
        CVVTextField.rightView = CVVBasicView
        CVVTextField.rightViewMode = .always
        
        CVVTextField.keyboardType = .numberPad
        CVVTextField.delegate = self
        CVVTextField.placeholder = "CVC"
        
   
        
        
        self.addSubview(wall)
        wall.backgroundColor = UIColor.init(hexStr: "#A2B9CC")
        wall.translatesAutoresizingMaskIntoConstraints = false
        wall.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        wall.widthAnchor.constraint(equalToConstant: 1).isActive = true
        wall.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        wall.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.layer.borderColor = UIColor.init(hexStr: "#2971BD").cgColor
        self.layer.borderWidth = 1.5
        return true
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(hexStr:"#A2B9CC").cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == dateTextField {
            if range.location > 6 {
                return false
            }
            
            print(range.length,range.location,string)
            if range.location > 0 {
                let newRang = range.location + 1
                if newRang % 3 == 0 && range.length == 0 && range.location != 5 {
                    textField.text?.append("/")
                }

                if  range.location % 3 == 0 && range.length == 1 && range.location == 3 {
                    textField.text?.removeLast()
                }
            }else{
                //日期提示输入
                if range.length == 0 {
                    if Int(string) ?? 0 > 1 {
                        print(string,"string")
                        textField.text = "0"
                    }
                    
                }
                
            }
        }
        if textField == CVVTextField {
            if range.location > 3 {
                return false
            }
        }
        
        
        return true
    }
    
    
}


