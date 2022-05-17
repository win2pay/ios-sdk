//
//  WPPayView.swift
// WintopaySDK
//
//  Created by 易购付 on 2021/5/31.
//

import UIKit
import IQKeyboardManagerSwift


public enum equipmentType:String {
    case custom = "ios_no"
    case `default` = "ios"
}

public let WPPayView_bottomAnchor_identifier = "WPPayView_bottomAnchor_identifier"

public let WPPayView_TopAnchor_identifier = "WPPayView_TopAnchor_identifier"
 
public protocol WPPayViewDelegate: NSObjectProtocol {
    
    func paymentResult(model:requestResult)
}

open class WPPayView: UIView {
    
//    ///单例
//    public static let sharedInstance = WPPayView.init()
    
    
    ///@parameter
    ///order_id:商户订单号
    ///amount:订单金额，单位 “元”
    ///currency:货币代码
    ///language:支付语言
    ///version:版本号，当前版本号为“20201001”
    ///user_agent:用户代理，请求头的 user_agent
    public init(order_id:String,amount am:String,currency:String,language:String,version:String,user_agent:String) {
        super.init(frame: .zero)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //更新约束
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        self.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        
        topView.addSubview(TopViewPointView)
        TopViewPointView.backgroundColor = UIColor.init(hexStr: "#6D737D")
        
        TopViewPointView.translatesAutoresizingMaskIntoConstraints = false
        TopViewPointView.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        TopViewPointView.topAnchor.constraint(equalTo:topView.topAnchor, constant: 10).isActive = true
        TopViewPointView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        TopViewPointView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        TopViewPointView.layer.cornerRadius = 4/2
        
        topView.addSubview(TitleLabel)
        TitleLabel.PingFangSC(type: .medium, fontSize: 18)
        TitleLabel.tintColor = UIColor.init(hexStr:"#1D2E43")
        TitleLabel.text = "Checkout page"
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        TitleLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 28).isActive = true
        
        topView.addSubview(CardNumberLabel)
        CardNumberLabel.PingFangSC(type: .medium, fontSize: 18)
        CardNumberLabel.tintColor = UIColor.init(hexStr:"#1D2E43")
        CardNumberLabel.text = "Card number "
        CardNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        CardNumberLabel.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 18).isActive = true
        CardNumberLabel.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: 18).isActive = true
        CardNumberLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 18).isActive = true
        
        
        self.addSubview(CardNumberTextFeildView)
        CardNumberTextFeildView.translatesAutoresizingMaskIntoConstraints = false
        CardNumberTextFeildView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        CardNumberTextFeildView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        CardNumberTextFeildView.topAnchor.constraint(equalTo: CardNumberLabel.bottomAnchor, constant: 18).isActive = true
        CardNumberTextFeildView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.addSubview(ValidityLabel)
        ValidityLabel.PingFangSC(type: .medium, fontSize: 18)
        ValidityLabel.tintColor = UIColor.init(hexStr:"#1D2E43")
        ValidityLabel.text = "Validity "
        ValidityLabel.translatesAutoresizingMaskIntoConstraints = false
        ValidityLabel.leftAnchor.constraint(equalTo:self.leftAnchor, constant: 18).isActive = true
        ValidityLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        ValidityLabel.topAnchor.constraint(equalTo:CardNumberTextFeildView.bottomAnchor, constant: 20).isActive = true
        
        
        self.addSubview(ValidityLabelTextFeildView)
        ValidityLabelTextFeildView.translatesAutoresizingMaskIntoConstraints = false
        ValidityLabelTextFeildView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        ValidityLabelTextFeildView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        ValidityLabelTextFeildView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        ValidityLabelTextFeildView.topAnchor.constraint(equalTo: ValidityLabel.bottomAnchor, constant: 14).isActive = true
        
        
        self.addSubview(payButton)
        payButton.translatesAutoresizingMaskIntoConstraints = false
        payButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        payButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        payButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        payButton.topAnchor.constraint(equalTo:ValidityLabelTextFeildView.bottomAnchor, constant: 26).isActive = true
        
        self.addSubview(tipsLabel)
        tipsLabel.text = "Click the payment confirmation button and I accept the terms. Contract service use and related termsSubscription and data protection policies."
        tipsLabel.numberOfLines = 8
        tipsLabel.PingFangSC(type: .regular, fontSize: 12)
        tipsLabel.textColor = UIColor.init(hexStr: "#1D2E43")
        tipsLabel.translatesAutoresizingMaskIntoConstraints = false
        tipsLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        tipsLabel.topAnchor.constraint(equalTo: payButton.bottomAnchor, constant: 14).isActive = true
        tipsLabel.leftAnchor.constraint(equalTo:self.leftAnchor, constant: 18).isActive = true
        tipsLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        tipsLabel.textAlignment = .left
        
        payButton.setTitle(dollarSignSring + am + " " + currency, for: .normal)
        basicParameter.order_id = order_id
        basicParameter.amount = am
        basicParameter.currency = currency
        basicParameter.language = language
        basicParameter.version = version
        basicParameter.user_agent = user_agent
    }
    
    var basicParameter:WPBasicParameter = WPBasicParameter.init(merchant_id: "", card_number: "", cvv: "", exp_month: "", exp_year: "", order_id: "", amount: "", currency: "", language: "", hash: "", metadata: "", version: "", user_agent: "", equipment: "")
    
    ///设备类型
    ///填写ios或者是android，如果是app端因卡信息加密问题请务必填写，如果是3d交易，使用自定义的成功失败界面时传ios_no或android_no
    public var equipment:equipmentType = equipmentType.default{
        didSet{
            basicParameter.equipment = equipment.rawValue
        }
    }
    
    ///货币符号
    public var dollarSignSring = "Pay "
    
 
    ///头部区域
    lazy var topView:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.init(hexStr:"#F6F7FA")
        return view
    }()
    
    ///圆点
    var TopViewPointView = UIView()
    
    ///标题
    var TitleLabel = UILabel()
    
    ///卡号
    var CardNumberLabel = UILabel()
    
    ///卡号输入框
    var CardNumberTextFeildView = WPCardNumberTextField.init()
    
    ///验证信息
    var ValidityLabel = UILabel()
    
    ///卡验证输入框
    var ValidityLabelTextFeildView = WPValidityTextFieldView.init()
    
    ///代理
    public weak var delegate:WPPayViewDelegate?
    
    ///付款按钮
    lazy var payButton:gifButton = {
        let button = gifButton.init(type: .custom)
       
        button.setTitle("", for: .selected)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(hexStr: "#2971BD")
//        button.backgroundColor = .black
        button.titleLabel?.PingFangSC(type: .medium, fontSize: 18)
        button.addTarget(self, action: #selector(toPay(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 9
        button.setImage(UIImage.WPBundleImage(name:"WPProgressHUD_LIne.png"), for: .selected)
        button.addAnimation()
        button.imageEdgeInsets = UIEdgeInsets.init(top: 4, left: 0, bottom: 4, right: 0)
        return button
    }()
    
 

    
    ///tips
    var tipsLabel = UILabel.init()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    
    ///添加约束
    open func addWPConstranint(){
        
        guard let supView = self.superview else {
            print("supperView is nil")
            return
        }
        supView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftAnchor.constraint(equalTo:supView.leftAnchor, constant: 0).isActive = true
        self.rightAnchor.constraint(equalTo: supView.rightAnchor, constant: 0).isActive = true
        let botttom = self.topAnchor.constraint(equalTo: supView.bottomAnchor, constant: 0)
        botttom.identifier = WPPayView_TopAnchor_identifier
        botttom.isActive = true
        
    }
    
    /// 弹出动画
    ///
    /// - Parameters:
    ///   - animation: 是否有动画效果
    open func show(animation:Bool){
        //        self.translatesAutoresizingMaskIntoConstraints = false
        guard let supView = self.superview else {
            return
        }
        for constraint in supView.constraints {
            if constraint.identifier == WPPayView_TopAnchor_identifier {
                supView.removeConstraint(constraint)
            }
        }
        let bottomConstrain = self.bottomAnchor.constraint(equalTo:supView.bottomAnchor, constant: 0)
        bottomConstrain.identifier = WPPayView_bottomAnchor_identifier
        bottomConstrain.isActive =  true
        self.updateConstraintsIfNeeded()
        if animation == true {
            UIView.animate(withDuration: 0.5) {
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    /// 隐藏
    ///
    /// - Parameters:
    ///   - animation: 是否有动画效果
    open func hide(animation:Bool){
        //        self.translatesAutoresizingMaskIntoConstraints = false
        guard let supView = self.superview else {
            return
        }
        for constraint in supView.constraints {
            if constraint.identifier == WPPayView_bottomAnchor_identifier {
                supView.removeConstraint(constraint)
            }
        }
        let topConstrain = self.topAnchor.constraint(equalTo:supView.bottomAnchor, constant: 0)
        topConstrain.identifier = WPPayView_TopAnchor_identifier
        topConstrain.isActive =  true
        
        if animation == true {
            UIView.animate(withDuration: 0.3) {
                self.superview?.layoutIfNeeded()
            }
        }
        self.endEditing(false)
    }
    
    ///点击button 支付请求
    @objc open func toPay(sender:gifButton){
        
        sender.isUserInteractionEnabled = false
        sender.isSelected = true
        sender.addAnimation()
        sender.imageView?.contentMode = .scaleAspectFit
        //验证失败
        if verifyCreditCard() == false {
            sender.isSelected = false
            sender.isUserInteractionEnabled = true
            return
        }
        //参数
        basicParameter.card_number = CardNumberTextFeildView.textField.text?.encryptCardInformation() ?? ""
        basicParameter.cvv = ValidityLabelTextFeildView.CVVTextField.text?.encryptCardInformation() ?? ""
        basicParameter.exp_year = ValidityLabelTextFeildView.dateTextField.text?.getYear()?.encryptCardInformation() ?? ""
        basicParameter.exp_month = ValidityLabelTextFeildView.dateTextField.text?.getMonth()?.encryptCardInformation() ?? ""
        let manage = WPNetWorkManage.manage
        basicParameter.merchant_id = manage.MerNo
        manage.parameters = RequestModel.init(basic: basicParameter, billing: manage.billAdress!, shipping: manage.shippingAddress!, products: manage.productsInformation!, data: nil)
        manage.payHash()
        
        //请求
        if manage.parameters != nil {
            manage.request(parameter: manage.parameters!) { result in
                sender.isSelected = false
                sender.isUserInteractionEnabled = true
                sender.removeAnimation()
                self.hide(animation: false)
                self.delegate?.paymentResult(model: result)
                //3d?
                if result.redirect_url != nil {
                    let vc = WP3DViewController.init()
                    vc.urlString = result.redirect_url!
//                    vc.PayResult = result
                    let nv = WPTool.getControllerfromview(view: self)?.navigationController
                    if nv != nil {
                        WPTool.getControllerfromview(view: self)?.navigationController?.pushViewController(vc, animated: false)
                    }else{
                        
                    }
                }else{
                    if manage.paymentResultStyle == .wp_view {
                        let vc = WPPayResultViewController.init()
                        vc.PayResult = result
                        let nv = WPTool.getControllerfromview(view: self)?.navigationController
                        if nv != nil {
                            WPTool.getControllerfromview(view: self)?.navigationController?.pushViewController(vc, animated: false)
                        }else{
                            
                        }
                    }
                }
            } failure: { error in
                //网络失败原因
                WPTool.showOnlyTextNoMask(message: error?.localizedDescription ?? "")
            }
        }
        
       
    }
    
    
    ///验证卡信息
    open func verifyCreditCard() -> Bool{
        guard var cardNo = CardNumberTextFeildView.textField.text,let cvv = ValidityLabelTextFeildView.CVVTextField.text,let date = ValidityLabelTextFeildView.dateTextField.text else {
            WPTool.showOnlyTextNoMask(message: "input text is null")
            return false
        }
 

        //去掉空格
        cardNo = cardNo.replacingOccurrences(of: " ", with: "")
        
        ///卡号
        if cardNo.isEmpty == true {
            WPTool.showOnlyTextNoMask(message: "Please enter the card number")
            return false
        }
        
        guard let year = date.getYear(),let month = date.getMonth() else {
            WPTool.showOnlyTextNoMask(message: "Invalid date format")
            return false
        }
        
        if  cardNo.purnInt != true{
            WPTool.showOnlyTextNoMask(message: "Invalid card number format")
            return false
        }
        if  cvv.purnInt != true {
            WPTool.showOnlyTextNoMask(message: "Invalid cvv format")
            return false
        }
        
        if  year.purnInt != true || month.purnInt != true || year.count != 4 || month.count != 2{
            WPTool.showOnlyTextNoMask(message: "Invalid date format !")
            return false
        }
        
        return true
    }
    
    
    // 1.把两张图片绘制成一张图片
    func combine(leftImage: UIImage, rightImage: UIImage) -> UIImage {
        
        // 1.1.获取第一张图片的宽度
        let width = leftImage.size.width
        // 1.2.获取第一张图片的高度
        let height = leftImage.size.height
        
        // 1.3.开始绘制图片的大小
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        // 1.4.绘制第一张图片的起始点
        leftImage.draw(at: CGPoint(x: 0, y: 0))
        // 1.5.绘制第二章图片的起始点
        rightImage.draw(at: CGPoint(x: 0, y:0))
        
        // 1.6.获取已经绘制好的
        let imageLong = UIGraphicsGetImageFromCurrentImageContext()!
        // 1.7.结束绘制
        UIGraphicsEndImageContext()
        
        // 1.8.返回已经绘制好的图片
        return imageLong
    }
    
    
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class gifButton: UIButton {
    
     open func addAnimation(){
      
        let anim = CABasicAnimation.init(keyPath: "transform.rotation.z")
        anim.fromValue = 0
        anim.toValue = Double.pi * 2
        anim.repeatCount = MAXFLOAT
        anim.duration = 0.8
        anim.isRemovedOnCompletion = false
//        self.addSubview(runLoopImageView)
//        runLoopImageView.translatesAutoresizingMaskIntoConstraints = false
//        runLoopImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        runLoopImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//        runLoopImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        runLoopImageView.widthAnchor.constraint(equalTo: runLoopImageView.heightAnchor).isActive = true
//        runLoopImageView.layer.add(anim, forKey: "test")
        self.imageView?.layer.add(anim, forKey: "test")
        
    }
    
    open func removeAnimation(){
        self.imageView?.layer.removeAnimation(forKey: "test")
    }
    
    
    
//    // 1.把两张图片绘制成一张图片
//    func combine(leftImage: UIImage, rightImage: UIImage) -> UIImage {
//
//        // 1.1.获取第一张图片的宽度
//        let width = leftImage.size.width
//        // 1.2.获取第一张图片的高度
//        let height = leftImage.size.height
//
//        // 1.3.开始绘制图片的大小
//        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
//        // 1.4.绘制第一张图片的起始点
//        leftImage.draw(at: CGPoint(x: 0, y: 0))
//        // 1.5.绘制第二章图片的起始点
//        rightImage.draw(at: CGPoint(x: 0, y:0))
//
//        // 1.6.获取已经绘制好的
//        let imageLong = UIGraphicsGetImageFromCurrentImageContext()!
//        // 1.7.结束绘制
//        UIGraphicsEndImageContext()
//
//        // 1.8.返回已经绘制好的图片
//        return imageLong
//    }
    
}
