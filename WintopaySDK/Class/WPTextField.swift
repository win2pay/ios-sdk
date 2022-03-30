//
//  WPTextField.swift
//  WintopaySDK
//
//  Created by 易购付 on 2021/6/1.
//

import UIKit

open class WPCardNumberTextField: UIView,UITextFieldDelegate {
    ///输入框
    open var textField = UITextField.init()
    ///输入框卡icon
    public let imageNames = ["wtp_ic_ae.png","wtp_ic_din.png","wtp_ic_jcb.png","wtp_ic_dc.png","wtp_ic_master.png","wtp_ic_visa.png"]
    
    ///bank
    var imageViewArray:[UIImageView] = [UIImageView]()
    
    public init(){
        super.init(frame: .zero)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(hexStr:"#A2B9CC").cgColor
        self.layer.cornerRadius = 8
        
        self.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        textField.rightAnchor.constraint(equalTo:self.rightAnchor, constant: -12).isActive = true
        

        textField.keyboardType = .numberPad
        textField.delegate = self
        
        for index in 0..<imageNames.count  {
                let imageView = UIImageView.init(image:UIImage.WPBundleImage(name: imageNames[index]))
                self.addSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
                imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -(CGFloat(12 + (6 + 24) * index))).isActive = true
                imageViewArray.append(imageView)
            }
        //添加观察者
        textField.addObserver(self, forKeyPath: "selectedTextRange", options: [.new,.old], context: nil)
       
    }
    
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //设置光标始终再最后一位
        if keyPath == "selectedTextRange" {
            let newPosition = textField.endOfDocument
            //延迟加载 无法更新光标位置
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [self] in
                self.textField.selectedTextRange = self.textField.textRange(from: newPosition, to: newPosition)
            }
            
        }
    
    }
        
      
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.layer.borderColor = UIColor.init(hexStr: "#2971BD").cgColor
        self.layer.borderWidth = 1.5
       
        return true
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        ///不超过15位
        if range.location > 19 {
            return false
        }
        textField.textColor = .black
        print(range.location)
        if range.location % 5 == 0 && range.length == 0{
            textField.text?.append(" ")
        }
        
        if range.location % 5 == 1 && range.length == 1 {
            textField.text?.removeLast()
        }
        
        //
        if range.location == 1 && range.length == 1 {
            //重置图片
            for item in 1..<imageViewArray.count {
                imageViewArray[item].isHidden = false
            }
            imageViewArray.first?.image = UIImage.WPBundleImage(name: "wtp_ic_ae.png")
        }else{
            //显示卡号对应的图片
            for item in 1..<imageViewArray.count {
                imageViewArray[item].isHidden = true
            }
            //前俩位
            if textField.text!.count < 3 {
                //输入第二位
                if range.location == 2 {
                    imageViewArray.first?.image =  WPTool.showEditingCardBrandImage(textFieldText: String.init(textField.text!.last!) + string)
                }else{
                  imageViewArray.first?.image =  WPTool.showEditingCardBrandImage(textFieldText: string)
                }
            }
        }
    
        return true
    }
    
    
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(hexStr:"#A2B9CC").cgColor
        
        guard let cardNumber = textField.text?.replacingOccurrences(of: " ", with: "")else{return}
        print(cardNumber)
        
        if cardNumber.count != 16  {
            textField.textColor = .red
        }else{
            textField.textColor = .black
        }
        
    }
        
    deinit {
        self.textField.removeObserver(self, forKeyPath: "selectedTextRange")
    }

  
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

