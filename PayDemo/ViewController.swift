//
//  ViewController.swift
//  PayDemo
//
//  Created by 易购付 on 2021/5/31.
//

import UIKit
import WintopaySDK




class ViewController: UIViewController{
    

    
//    let payView = WPPayView.sharedInstance
    
    lazy var payView:WPPayView = {
        let pay = WPPayView.init(order_id: "test288822122", amount: "188", currency: "USD", language: "en", version: "20201001", user_agent: WPTool.getUserAgent() ?? "")
        return pay
    }()
    
    lazy var maskView:UIView = {
        let mask = UIView()
        mask.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        mask.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action:#selector(self.hideMask)))
        mask.frame = self.view.frame
        mask.isHidden = true
        return mask
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        let manage = WPNetWorkManage.manage
        manage.Md5key = "yd#hUqBS)tC7"
        manage.MerNo = "70183"
        manage.gateway = "https://stg-gateway.wintopay.com/api/v2/gateway/payment"
        manage.referer = "www.wintopay.cn"
        
        //地址信息
        let billAdress = WPBillingAddressParameter.init(billing_first_name: "Zach-test", billing_last_name: "Wigginton", billing_email: "742823994@qq.com", billing_phone: "+1 04695308545", billing_postal_code: "67207", billing_address: "wichita", billing_city: "wichita", billing_state: "KS", billing_country: "US", ip: WPTool.getPublicIPAddress())
        let shipadress = WPShippingAddressParameter.init(shipping_first_name: "Za2ch-test", shipping_last_name: "Wigginton", shipping_email: "742853394@qq.com", shipping_phone: "+1 046925308545", shipping_postal_code: "67207", shipping_address: "2018SCr2anbrookSt", shipping_city: "wichi2ta", shipping_state: "KS", shipping_country: "US")
        manage.billAdress = billAdress
        manage.shippingAddress = shipadress
        manage.productsInformation = WPProductsInformationParameter.init(productsArray:[WPProductsEncodable.init(sku: "abdc", name: "what is this", amount: "", quantity: "1", currency: "USD")])
        manage.paymentResultStyle = .wp_view
        
        let PayButton = UIButton.init(type: .custom)
        self.view.addSubview(PayButton)

        PayButton.setTitle("支付", for: .normal)
        PayButton.setTitleColor(.white, for: .normal)
        PayButton.translatesAutoresizingMaskIntoConstraints = false
        PayButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        PayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        PayButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        PayButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        PayButton.backgroundColor = UIColor.init(named:"#2971BD")
        PayButton.layer.cornerRadius = 20
        PayButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        PayButton.addTarget(self, action: #selector(toPay), for: .touchUpInside)
        
        self.view.addSubview(maskView)
        self.view.addSubview(payView)
        payView.addWPConstranint()
        payView.delegate = self
        payView.equipment = .default
        
        
    }
    
    @objc func hideMask() {
        maskView.isHidden = true
        payView.hide(animation: true)
    }

    @objc func toPay(){
        
        maskView.isHidden = false
        payView.show(animation: true)
    }

}

extension ViewController:WPPayViewDelegate{
    
    ///支付结果代理回调
    func paymentResult(model: requestResult) {
        maskView.isHidden = true
        print("支付结果",model)
    }
    
}



