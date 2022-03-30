//
//  WPPayResultViewController.swift
//  WintopaySDK
//
//  Created by 易购付 on 2022/2/23.
//

import UIKit

class WPPayResultViewController: UIViewController {
    
    var PayResult:requestResult?
    
    ///支付结果图片
    lazy var payResultImageView:UIImageView = {
        let imageView = UIImageView.init()
        return imageView
    }()
    
    ///支付状态
    lazy var payStatus:UILabel = {
        let label = UILabel.init()
        label.PingFangSC(type: .medium, fontSize: 20)
        label.textColor = UIColor.init(hexStr: "#1D2E43")
        
        return label
    }()

    ///描述文字
    lazy var payDescription:UILabel = {
        let label = UILabel.init()
        label.PingFangSC(type: .medium, fontSize: 14)
        label.textColor = UIColor.init(hexStr: "#86919D")
        label.textAlignment = .center
        label.numberOfLines = 5
        return label
    }()
    
    ///
    lazy var viewOrder:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("View order", for: .normal)
        button.setTitle("View order", for: .selected)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(hexStr: "#2971BD")
        button.layer.cornerRadius = 9
        button.titleLabel?.PingFangSC(type: .medium, fontSize: 18)
        button.addTarget(self, action: #selector(toOrders(sender:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Payment results"
        creatUI()
    }
    
    func creatUI(){
        self.view.addSubview(payResultImageView)
        payResultImageView.translatesAutoresizingMaskIntoConstraints = false
        payResultImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        payResultImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        payResultImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        payResultImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 90).isActive = true
        
        switch PayResult?.status {
        case "paid":
            payResultImageView.image = UIImage.WPBundleImage(name: "ic_success.png")
        case "failed":
            payResultImageView.image = UIImage.WPBundleImage(name: "ic_failed.png")
        case "canceled":
            payResultImageView.image = UIImage.WPBundleImage(name: "ic_failed.png")
        case "pending":
            payResultImageView.image = UIImage.WPBundleImage(name: "ic_pending.png")
        default:
            payResultImageView.image = UIImage.WPBundleImage(name: "ic_failed.png")
        }
        
        self.view.addSubview(payStatus)
        payStatus.translatesAutoresizingMaskIntoConstraints = false
        payStatus.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        payStatus.topAnchor.constraint(equalTo: payResultImageView.bottomAnchor, constant: 18).isActive = true
        payStatus.text = PayResult?.status
        
        self.view.addSubview(payDescription)
        payDescription.translatesAutoresizingMaskIntoConstraints = false
        payDescription.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        payDescription.topAnchor.constraint(equalTo: payStatus.bottomAnchor, constant: 20).isActive = true
        payDescription.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        payDescription.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
        payDescription.text = PayResult?.message
        
        self.view.addSubview(viewOrder)
        viewOrder.translatesAutoresizingMaskIntoConstraints = false
        viewOrder.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        viewOrder.widthAnchor.constraint(equalToConstant: 230).isActive = true
        viewOrder.heightAnchor.constraint(equalToConstant: 44).isActive = true
        viewOrder.topAnchor.constraint(equalTo: payDescription.bottomAnchor, constant: 62).isActive = true
    }
    

    @objc func toOrders(sender:UIButton){
        self.navigationController?.popToRootViewController(animated: false)
    }

}
