//
//  EditPayAddressViewController.swift
//  PayDemo
//
//  Created by 易购付 on 2022/4/7.
//

import UIKit
import WintopaySDK

class EditPayAddressViewController: UIViewController {
    
    var userAgent = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        let manage = WPNetWorkManage.manage
        manage.Md5key = "yd#hUqBS)tC7"
        manage.MerNo = "70183"
        manage.gateway = "https://stg-gateway.wintopay.com/api/v2/gateway/payment"
        manage.referer = "www.wintopay.cn"
        userAgent = WPTool.getUserAgent() ?? ""

        let productsArray = [WPProductsEncodable.init(sku: "", name: "product A", amount: "188.00", quantity: "1", currency:"USD"),WPProductsEncodable.init(sku: "", name: "product B", amount: "208.00", quantity: "1",currency:"USD"),WPProductsEncodable.init(sku: "", name: "product C", amount: "88.00", quantity: "1", currency:"USD")]

        //小票信息
        manage.receiptModel = WPReceiptModel.init(date: "Today，July 29th，10:00AM", freight: 20, currency: "USD", products: productsArray)
        
        ///需要传入产品信息
        manage.productsInformation = WPProductsInformationParameter.init(productsArray:productsArray)
        manage.paymentResultStyle = .wp_view
        
        let PayButton = UIButton.init(type: .custom)
        self.view.addSubview(PayButton)

        PayButton.setTitle("带地址信息支付", for: .normal)
        PayButton.setTitleColor(.white, for: .normal)
        PayButton.translatesAutoresizingMaskIntoConstraints = false
        PayButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        PayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        PayButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        PayButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        PayButton.backgroundColor = UIColor.init(named:"#2971BD")
        PayButton.layer.cornerRadius = 20
        PayButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        PayButton.addTarget(self, action: #selector(toPay), for: .touchUpInside)
        
        
    }


    @objc func toPay(){
        let random = arc4random_uniform(10000) + 1
        let vc = WPEditablePayViewController.init(order_id: "testSSM" + String(random), amount: "504", currency: "USD", language: "en", version: "20201001", user_agent: userAgent )
        vc.delegate = self
        vc.equipment = .default
        
        //地址信息
        let billAdress = WPBillingAddressParameter.init(billing_first_name: "Zach-test", billing_last_name: "Wigginton", billing_email: "742823994@qq.com", billing_phone: "+1 04695308545", billing_postal_code: "33333", billing_address: "wichita", billing_city: "wichita", billing_state: "KS", billing_country: "US", ip: WPTool.getPublicIPAddress())
        let shipadress = WPShippingAddressParameter.init(shipping_first_name: "Za2ch-test", shipping_last_name: "Wigginton", shipping_email: "742853394@qq.com", shipping_phone: "+1 046925308545", shipping_postal_code: "67207", shipping_address: "2018SCr2anbrookSt", shipping_city: "wichi2ta", shipping_state: "KS", shipping_country: "US")
        vc.bill = billAdress
        vc.shipping = shipadress        
        self.navigationController?.pushViewController(vc, animated: false)
    }

}

extension EditPayAddressViewController:WPPayViewDelegate{
    func paymentResult(model: requestResult) {
        print("支付结果",model)
    }

}

