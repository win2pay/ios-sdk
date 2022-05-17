//
//  WPReceiptViewController.swift
//  WintopaySDK
//
//  Created by 易购付 on 2022/4/25.
//

import UIKit

class WPReceiptViewController: UIViewController,UIPopoverPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addUI()
    }
    
    
    func addUI(){
        let manage = WPNetWorkManage.manage
        guard let model = manage.receiptModel else {
            WPTool.showOnlyTextNoMask(message: "Receipts page has no data")
            return
        }
        
        
        
        let OrderTitle = UILabel.init()
        self.view.addSubview(OrderTitle)
        OrderTitle.textColor = UIColor.init(hexStr: "#1D2E43")
        OrderTitle.PingFangSC(type: .medium, fontSize: 14)
        OrderTitle.translatesAutoresizingMaskIntoConstraints = false
        OrderTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        OrderTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        OrderTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        OrderTitle.heightAnchor.constraint(equalToConstant: 14).isActive = true
        OrderTitle.text = "Your order"
    
   
        
        let line1 = UIView.init()
        self.view.addSubview(line1)
        line1.backgroundColor = UIColor.init(hexStr: "#D1D7DE")
        line1.translatesAutoresizingMaskIntoConstraints = false
        line1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line1.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        line1.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        line1.topAnchor.constraint(equalTo: OrderTitle.bottomAnchor, constant: 16).isActive = true
  
        
        let dateLabel = UILabel.init()
        self.view.addSubview(dateLabel)
        dateLabel.textColor = UIColor.init(hexStr: "#86919D")
        dateLabel.PingFangSC(type: .medium, fontSize: 11)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: line1.bottomAnchor, constant: 16).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        dateLabel.text = model.date
        dateLabel.heightAnchor.constraint(equalToConstant: 11).isActive = true
    
        
        var lastView:UILabel = UILabel()
        //Subtotal
        var subtotalFloat:Float = 0.0
        
        for index in 0..<model.products.count {
            
            let productLabel = UILabel.init()
            self.view.addSubview(productLabel)
            productLabel.textColor = UIColor.init(hexStr: "#1D2E43")
            productLabel.PingFangSC(type: .medium, fontSize: 11)
            productLabel.translatesAutoresizingMaskIntoConstraints = false
            if index == 0 {
                productLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
            }else{
                productLabel.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 10).isActive = true
            }
            
            productLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
            productLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
            productLabel.text = "\(model.products[index].quantity) item"
            productLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
            
    
            let priceLabel = UILabel.init()
            self.view.addSubview(priceLabel)
            priceLabel.textColor = UIColor.init(hexStr: "#1D2E43")
            priceLabel.PingFangSC(type: .medium, fontSize: 11)
            priceLabel.translatesAutoresizingMaskIntoConstraints = false
            if index == 0 {
                priceLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
            }else{
                priceLabel.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 10).isActive = true
            }
            priceLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
            priceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
            priceLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
            priceLabel.text = String(model.products[index].amount) + " " + model.currency
            priceLabel.textAlignment = .right
            subtotalFloat = subtotalFloat + (Float(model.products[index].amount) ?? 0) * (Float(model.products[index].quantity) ?? 0)
            lastView = productLabel
            
        }
        
         
        
        let line2 = UIView.init()
        self.view.addSubview(line2)
        line2.backgroundColor = UIColor.init(hexStr: "#D1D7DE")
        line2.translatesAutoresizingMaskIntoConstraints = false
        line2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        line2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        line2.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 16).isActive = true
        
        let Subtotal = UILabel.init()
        self.view.addSubview(Subtotal)
        Subtotal.textColor = UIColor.init(hexStr: "#86919D")
        Subtotal.PingFangSC(type: .medium, fontSize: 11)
        Subtotal.translatesAutoresizingMaskIntoConstraints = false
        Subtotal.topAnchor.constraint(equalTo: line2.bottomAnchor, constant: 16).isActive = true
        Subtotal.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        Subtotal.widthAnchor.constraint(equalToConstant: 80).isActive = true
        Subtotal.heightAnchor.constraint(equalToConstant: 12).isActive = true
        Subtotal.text = "Subtotal"
        
        
        let SubtotalPriceLabel = UILabel.init()
        self.view.addSubview(SubtotalPriceLabel)
        SubtotalPriceLabel.textColor = UIColor.init(hexStr: "#86919D")
        SubtotalPriceLabel.PingFangSC(type: .medium, fontSize: 11)
        SubtotalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        SubtotalPriceLabel.topAnchor.constraint(equalTo: line2.bottomAnchor, constant: 16).isActive = true
        SubtotalPriceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        SubtotalPriceLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        SubtotalPriceLabel.text = String(subtotalFloat) + " " + model.currency
        SubtotalPriceLabel.textAlignment = .right
        
        let Freight = UILabel.init()
        self.view.addSubview(Freight)
        Freight.textColor = UIColor.init(hexStr: "#86919D")
        Freight.PingFangSC(type: .medium, fontSize: 11)
        Freight.translatesAutoresizingMaskIntoConstraints = false
        Freight.topAnchor.constraint(equalTo: Subtotal.bottomAnchor, constant: 10).isActive = true
        Freight.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        Freight.widthAnchor.constraint(equalToConstant: 80).isActive = true
        Freight.heightAnchor.constraint(equalToConstant: 12).isActive = true
        Freight.text = "Freight"
        
        
        let FreightPriceLabel = UILabel.init()
        self.view.addSubview(FreightPriceLabel)
        FreightPriceLabel.textColor = UIColor.init(hexStr: "#86919D")
        FreightPriceLabel.PingFangSC(type: .medium, fontSize: 11)
        FreightPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        FreightPriceLabel.topAnchor.constraint(equalTo: Subtotal.bottomAnchor, constant: 10).isActive = true
        FreightPriceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        FreightPriceLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        FreightPriceLabel.text = String(model.freight) + " " + model.currency
        FreightPriceLabel.textAlignment = .right
        
        let line3 = UIView.init()
        self.view.addSubview(line3)
        line3.backgroundColor = UIColor.init(hexStr: "#D1D7DE")
        line3.translatesAutoresizingMaskIntoConstraints = false
        line3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line3.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        line3.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        line3.topAnchor.constraint(equalTo: Freight.bottomAnchor, constant: 16).isActive = true
        
        let Total = UILabel.init()
        self.view.addSubview(Total)
        Total.textColor = UIColor.init(hexStr: "#1D2E43")
        Total.PingFangSC(type: .medium, fontSize: 14)
        Total.translatesAutoresizingMaskIntoConstraints = false
        Total.topAnchor.constraint(equalTo: line3.bottomAnchor, constant: 16).isActive = true
        Total.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        Total.widthAnchor.constraint(equalToConstant: 40).isActive = true
        Total.heightAnchor.constraint(equalToConstant: 14).isActive = true
        Total.text = "Total"
        
        let TotalAmount = UILabel.init()
        self.view.addSubview(TotalAmount)
        TotalAmount.textColor = UIColor.init(hexStr: "#1D2E43")
        TotalAmount.PingFangSC(type: .medium, fontSize: 14)
        TotalAmount.translatesAutoresizingMaskIntoConstraints = false
        TotalAmount.topAnchor.constraint(equalTo: line3.bottomAnchor, constant: 16).isActive = true
        TotalAmount.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        TotalAmount.widthAnchor.constraint(equalToConstant: 120).isActive = true
        TotalAmount.textAlignment = .right
        //TotalAmount.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 24).isActive = true
        TotalAmount.text = String(model.freight + subtotalFloat) + " " + model.currency
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
