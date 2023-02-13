//
//  WPEditablePayViewController.swift
//  WintopaySDK
//
//  Created by 易购付 on 2022/4/8.
//

import UIKit
import IQKeyboardManagerSwift

open class WPEditablePayViewController: UIViewController, UITextFieldDelegate {
    
    ///地址选择器
    var addressPickView = WPAdressPickView.sharedInstance
    
    ///账单地址信息名
    let billAdressNames:[WPAdressPayTextFieldName] = [.Email,.Phone,.first_name,.last_name,.Address,.City,.State,.Country,.PostCode]
    
    var billAdressText:[String] = ["","","","","","","","",""]
    
    var shippingAdressText:[String] = ["","","","","","","","",""]
    
    ///收货地址信息名
    let shippingAdressNames :[WPAdressPayTextFieldName] = [.Email,.Phone,.first_name,.last_name,.Address,.City,.State,.Country,.PostCode]
    
    ///默认是2
    var tabbarViewSection:Int = 2
    
    ///上个textfield
    var lastTextField:UITextField = UITextField.init()
    
    ///代理
    public weak var delegate:WPPayViewDelegate?
    
    ///top
    lazy var topView:UITableView = {
        let tab = UITableView.init(frame: .zero, style: .grouped)
        tab.separatorStyle = .none
        tab.backgroundColor = .white
        return tab
    }()
    
    ///设备类型
    ///填写ios或者是android，如果是app端因卡信息加密问题请务必填写，如果是3d交易，使用自定义的成功失败界面时传ios_no或android_no
    public var equipment:equipmentType = equipmentType.default{
        didSet{
            basicParameter.equipment = equipment.rawValue
        }
    }
    
    var cardNuberCell = WPCreditCardTableViewCell()
    
    ///BillingAddress
    public var bill:WPBillingAddressParameter = WPBillingAddressParameter.init(billing_first_name: "", billing_last_name: "", billing_email: "", billing_phone: "", billing_postal_code: "", billing_address: "", billing_city: "", billing_state: "", billing_country: "", ip: "")
    
    ///shippingAddrss
    public var shipping:WPShippingAddressParameter = WPShippingAddressParameter.init(shipping_first_name: "", shipping_last_name: "", shipping_email: "", shipping_phone: "", shipping_postal_code: "", shipping_address: "", shipping_city: "", shipping_state: "", shipping_country: "")
    
    ///货币符号
    public var dollarSignSring = "Pay "
    
    var basicParameter:WPBasicParameter = WPBasicParameter.init(merchant_id: "", card_number: "", cvv: "", exp_month: "", exp_year: "", order_id: "", amount: "", currency: "", language: "", hash: "", metadata: "", version: "", user_agent: "", equipment: "")
    
    ///付款按钮
    public lazy var payButton:gifButton = {
        let button = gifButton.init(type: .custom)
        button.setTitle("", for: .selected)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(hexStr: "#2971BD")
        button.titleLabel?.PingFangSC(type: .medium, fontSize: 18)
        button.addTarget(self, action: #selector(toPay(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 4
        button.setImage(UIImage.WPBundleImage(name:"WPProgressHUD_LIne.png"), for: .selected)
        button.addAnimation()
        button.imageEdgeInsets = UIEdgeInsets.init(top: 4, left: 0, bottom: 4, right: 0)
        return button
    }()
    
    ///购物地址checkbox
    ///15.0版本需重新写
    public lazy var checkBox:WPCheckBox = {
        let checkbox = WPCheckBox.init(type: .custom)
        
        if #available(iOS 15.0, *) {
            var fill = WPCheckBox.Configuration.plain()
            var labelContainer = AttributeContainer()
            labelContainer.font = UIFont.init(name: pingFangSCqWeight.medium.rawValue, size: 18)
            labelContainer.foregroundColor = UIColor.black
            fill.attributedTitle = AttributedString.init("Billing Address", attributes: labelContainer)
            fill.image = UIImage.WPBundleImage(name: "checkbox_unselect.png")
            fill.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
            fill.imagePadding = 10
            checkbox.configuration = fill
            checkbox.isSelected = true
            //监听状态
            checkbox.configurationUpdateHandler = { (buton:UIButton) -> Void in
                switch buton.state{
                case .normal:
                    buton.configuration?.image = UIImage.WPBundleImage(name: "checkbox_unselect.png")
                    buton.configuration?.attributedTitle = AttributedString.init("Billing Address", attributes: labelContainer)
                case .selected:
                    buton.configuration?.image = UIImage.WPBundleImage(name: "checkbox_select.png")
                    buton.configuration?.attributedTitle = AttributedString.init("Billing Address", attributes: labelContainer)
                    buton.backgroundColor = .white
                    buton.configuration?.baseBackgroundColor = .white
                default:
                    break ;
                }
                buton.updateConfiguration()
            }
        }else{
            checkbox.setTitle("Billing Address", for: .normal)
            checkbox.setTitle("Billing Address", for: .selected)
            checkbox.setImage(UIImage.WPBundleImage(name: "checkbox_unselect.png"), for: .normal)
            checkbox.setImage(UIImage.WPBundleImage(name: "checkbox_select.png"), for: .selected)
            checkbox.titleLabel?.font = UIFont.init(name: pingFangSCqWeight.medium.rawValue, size: 18)
            checkbox.setTitleColor(.black, for: .normal)
            checkbox.setTitleColor(.black, for: .selected)
        }
        checkbox.addTarget(self, action: #selector(clickShipingAdressButton(sender:)), for: .touchDown)
        return checkbox
    }()
    
    ///tips
    var tipsLabel = UILabel.init()
    
    ///@parameter
    ///order_id:商户订单号
    ///amount:订单金额，单位 “元”
    ///currency:货币代码
    ///language:支付语言
    ///version:版本号，当前版本号为“20201001”
    ///user_agent:用户代理，请求头的 user_agent
    public init(order_id:String,amount am:String,currency:String,language:String,version:String,user_agent:String) {
        super.init(nibName: nil, bundle: nil)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //更新约束
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        
        payButton.setTitle(dollarSignSring + am + " " + currency, for: .normal)
        basicParameter.order_id = order_id
        basicParameter.amount = am
        basicParameter.currency = currency
        basicParameter.language = language
        basicParameter.version = version
        basicParameter.user_agent = user_agent
        
    }
    
    
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Payment page"
        let manage = WPNetWorkManage.manage
        if manage.receiptModel != nil && manage.productsInformation != nil {
          manage.AddressModel = WPOrderAddress.init(bill: bill, shipping: shipping, products: manage.productsInformation!, order_created_time: manage.receiptModel!.date, freight: String(manage.receiptModel!.freight))
        }
        addConstranint()
        addressPickView.addWPConstranint()
        addressPickView.delegate = self
        
        AddReceipt()
        addBillTextfield()
        addShippingTextfield()
    }
    
    ///右侧小票
    public func AddReceipt(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.WPBundleImage(name:"WPEllipsis.png"), style: .done, target: self, action: #selector(clickRightBarButton(sender:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    
    @objc func clickRightBarButton(sender:UIBarButtonItem){
        let receipt = WPReceiptViewController()
        receipt.modalPresentationStyle = .popover
        receipt.popoverPresentationController?.delegate = self
        receipt.popoverPresentationController?.barButtonItem = sender
        receipt.popoverPresentationController?.permittedArrowDirections = .up
        //
        let index = WPNetWorkManage.manage.receiptModel?.products.count
        if index != nil {
            receipt.preferredContentSize = CGSize.init(width: 210, height: (216 + (22 * index!)))
        }else{
            receipt.preferredContentSize = CGSize.init(width: 210, height:  216 )
        }
        
        self.present(receipt, animated: false, completion: nil)
    }
    

    ///添加约束
    public func addConstranint(){
      
        self.view.addSubview(payButton)
        payButton.translatesAutoresizingMaskIntoConstraints = false
        payButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 18).isActive = true
        payButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -18).isActive = true
        payButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
      
//        payButton.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 23).isActive = true
     
        self.view.addSubview(tipsLabel)
        tipsLabel.text = "Click the payment confirmation button and I accept the terms. Contract service use and related termsSubscription and data protection policies."
        tipsLabel.numberOfLines = 8
        tipsLabel.PingFangSC(type: .regular, fontSize: 12)
        tipsLabel.textColor = UIColor.init(hexStr: "#1D2E43")
        tipsLabel.translatesAutoresizingMaskIntoConstraints = false
        tipsLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        tipsLabel.topAnchor.constraint(equalTo: payButton.bottomAnchor, constant: 14).isActive = true
        tipsLabel.leftAnchor.constraint(equalTo:self.view.leftAnchor, constant: 18).isActive = true
        tipsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -18).isActive = true
        tipsLabel.textAlignment = .left
     
     
        
        self.view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        topView.bottomAnchor.constraint(equalTo: self.payButton.topAnchor, constant: -12).isActive = true

        let path = Bundle.main.path(forResource: "Wintopay", ofType: "bundle")
        let bundle = Bundle.init(path: path!)
        topView.register(UINib.init(nibName: WPCreditCardTableViewCellID, bundle: bundle), forCellReuseIdentifier: WPCreditCardTableViewCellID)
        topView.register(UINib.init(nibName: WPBillAddresslTableViewCellID, bundle: bundle), forCellReuseIdentifier: WPBillAddresslTableViewCellID)
        topView.delegate = self
        topView.dataSource = self
    }
    
    ///传过来的Bill数据显示在tf上
    public func addBillTextfield(){
        //bill
        billAdressText[0] = bill.billing_email
        billAdressText[1] = bill.billing_phone
        billAdressText[2] = bill.billing_first_name
        billAdressText[3] = bill.billing_last_name
        billAdressText[4] = bill.billing_address
        billAdressText[5] = bill.billing_city
        billAdressText[6] = bill.billing_state
        billAdressText[7] = bill.billing_country
        billAdressText[8] = bill.billing_postal_code

    }
    
    ///传过来的shiping数据显示在tf上
    public func addShippingTextfield(){
        //bill
        shippingAdressText[0] = shipping.shipping_email
        shippingAdressText[1] = shipping.shipping_phone
        shippingAdressText[2] = shipping.shipping_first_name
        shippingAdressText[3] = shipping.shipping_last_name
        shippingAdressText[4] = shipping.shipping_address
        shippingAdressText[5] = shipping.shipping_city
        shippingAdressText[6] = shipping.shipping_state
        shippingAdressText[7] = shipping.shipping_country
        shippingAdressText[8] = shipping.shipping_postal_code

    }

    ///点击button 支付请求
    @objc open func toPay(sender:gifButton){
        lastTextField.resignFirstResponder()
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
        
        if verifyAdress() == false {
            sender.isSelected = false
            sender.isUserInteractionEnabled = true
            return
        }
  
        //参数
        basicParameter.card_number = cardNuberCell.WPCardNumberTextField.text?.encryptCardInformation() ?? ""
        basicParameter.cvv = cardNuberCell.WPCVVTextField.text?.encryptCardInformation() ?? ""
        basicParameter.exp_year = cardNuberCell.WPDateTextField.text?.getYear()?.encryptCardInformation() ?? ""
        basicParameter.exp_month = cardNuberCell.WPDateTextField.text?.getMonth()?.encryptCardInformation() ?? ""
        let manage = WPNetWorkManage.manage
        basicParameter.merchant_id = manage.MerNo
        
        //如果州信息为空 默认填城市信息
        if shipping.shipping_state.isEmpty == true {
            shipping.shipping_state = shipping.shipping_city
        }
        if bill.billing_state.isEmpty == true {
            bill.billing_state = bill.billing_city
        }
      
        manage.parameters = RequestModel.init(basic: basicParameter, billing: bill, shipping: shipping, products: manage.productsInformation!, data: manage.AddressModel?.transaction_data)
        manage.payHash()
    
        //请求
        if manage.parameters != nil {
            manage.request(parameter: manage.parameters!) { result in
                sender.isSelected = false
                sender.isUserInteractionEnabled = true
                sender.removeAnimation()
                self.delegate?.paymentResult(model: result)
                //3d?
                if result.redirect_url != nil {
                    let vc = WP3DViewController.init()
                    vc.urlString = result.redirect_url!
//                    vc.PayResult = result
                    let nv = self.navigationController
                    if nv != nil {
                        nv!.pushViewController(vc, animated: false)
                    }else{

                    }
                }else{
                    if manage.paymentResultStyle == .wp_view {
                        let vc = WPPayResultViewController.init()
                        vc.PayResult = result
                        let nv = self.navigationController
                        if nv != nil {
                            nv?.pushViewController(vc, animated: false)
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
    
    ///拓展自定义验证地址信息
    open func verifyAdress() -> Bool {
        for index in 0..<shippingAdressText.count {
            if shippingAdressText[index].isEmpty == true && index != 6{
                WPTool.showOnlyTextNoMask(message: "Incomplete shipping information")
                return false
            }
            
        }

        for index in 0..<billAdressText.count {
            if billAdressText[index].isEmpty == true && index != 6{
                WPTool.showOnlyTextNoMask(message: "Incomplete billing information")
                return false
            }
            
        }
        return true
    }
    
    ///验证卡信息
    open func verifyCreditCard() -> Bool{
        
    
        guard var cardNo = cardNuberCell.WPCardNumberTextField.text,let cvv = cardNuberCell.WPCVVTextField.text,let date = cardNuberCell.WPDateTextField.text else {
            ///输入框为空
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
        
        if  cardNo.purnInt != true{
            WPTool.showOnlyTextNoMask(message: "Invalid card number format")
            return false
        }
        
        guard let year = date.getYear(),let month = date.getMonth() else {
            //格式错误
            WPTool.showOnlyTextNoMask(message: "Invalid date format")
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
    
    ///根据下标来添加地址数据
    ///@parameter name:WPAdressPayTextFieldName 输入框类型
    func addBillAdressParameter(name:WPAdressPayTextFieldName,text:String){
        switch name {
        case .first_name:
            bill.billing_first_name = text
        case .last_name:
            bill.billing_last_name = text
        case .City:
            bill.billing_city = text
        case .Address:
            bill.billing_address = text
        case .PostCode:
            bill.billing_postal_code = text
        case .Phone:
            bill.billing_phone = text
        case .Email:
            bill.billing_email = text
        default:
            break ;
        }
    }
    
    ///根据下标来添加地址数据
    ///@parameter name:WPAdressPayTextFieldName 输入框类型
    func addShippingAdressParameter(name:WPAdressPayTextFieldName,text:String){
        switch name {
        case .first_name:
            shipping.shipping_first_name = text
        case .last_name:
            shipping.shipping_last_name = text
        case .City:
            shipping.shipping_city = text
        case .Address:
            shipping.shipping_address = text
        case .PostCode:
            shipping.shipping_postal_code = text
        case .Phone:
            shipping.shipping_phone = text
        case .Email:
            shipping.shipping_email = text
        default:
            break ;
        }
    }
    

    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //设置光标始终再最后一位
        if keyPath == "selectedTextRange" {
            
            guard let cardNuberCell = topView.cellForRow(at: [0,0]) as? WPCreditCardTableViewCell else {
                return
            }
            let newPosition = cardNuberCell.WPCardNumberTextField.endOfDocument
            //延迟加载 无法更新光标位置
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                cardNuberCell.WPCardNumberTextField.selectedTextRange = cardNuberCell.WPCardNumberTextField.textRange(from: newPosition, to: newPosition)
            }
            
        }
    
    }
    
    deinit {
        let cell = topView.cellForRow(at: [0,0]) as? WPCreditCardTableViewCell
        if cell != nil{
            cell!.WPCardNumberTextField.removeObserver(self, forKeyPath: "selectedTextRange")
        }
    }

}

extension WPEditablePayViewController:UITableViewDelegate,UITableViewDataSource,WPAdressPickViewDelegate,UIPopoverPresentationControllerDelegate{
 
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func selectAddress(contryInfo: WPSelectorCountryStruct, indexPath: IndexPath) {
 
        let countryCell = topView.cellForRow(at: IndexPath.init(row: 7, section: indexPath.section)) as! WPBillAddresslTableViewCell
        countryCell.WPAdressTextField.text = contryInfo.countryName
        let stateCell = topView.cellForRow(at: IndexPath.init(row: 6, section: indexPath.section)) as! WPBillAddresslTableViewCell
        stateCell.WPAdressTextField.text = contryInfo.zoneName ?? ""
        if indexPath.section == 2 {
            billAdressText[7] = contryInfo.countryName
            billAdressText[6] = contryInfo.zoneName ?? ""
            bill.billing_country = contryInfo.countryISO
            bill.billing_state = contryInfo.zoneISO ?? ""
            
        }else{
            shippingAdressText[7] = contryInfo.countryName
            shippingAdressText[6] = contryInfo.zoneName ?? ""
            shipping.shipping_country = contryInfo.countryISO
            shipping.shipping_state = contryInfo.zoneISO ?? ""
        }
        //update cell
        topView.reloadRows(at:[IndexPath.init(row: 6, section: indexPath.section),IndexPath.init(row: 7, section: indexPath.section)], with: .none)

    }
    

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return billAdressNames.count
        }
        if section == 2 {
            return shippingAdressNames.count
        }
        return 1
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return tabbarViewSection
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section > 0 {
           
            let cell = tableView.dequeueReusableCell(withIdentifier: WPBillAddresslTableViewCellID, for: indexPath) as! WPBillAddresslTableViewCell
            cell.WPAdressName.text = billAdressNames[indexPath.row].rawValue
            cell.WPAdressTextField.name = billAdressNames[indexPath.row]
            //keyboard type
            if cell.WPAdressName.text == WPAdressPayTextFieldName.PostCode.rawValue || cell.WPAdressName.text == WPAdressPayTextFieldName.Phone.rawValue {
                cell.WPAdressTextField.keyboardType = .numberPad
            }else{
                cell.WPAdressTextField.keyboardType = .default
            }
            
            cell.WPAdressTextField.delegate = self
            if indexPath.row == 6 || indexPath.row == 7 {
                cell.WPAdressTextField.type = .addressPick
            }else{
                cell.WPAdressTextField.type = .normal
            }
            //bill
            if indexPath.section == 2 {
                cell.WPAdressTextField.text = billAdressText[indexPath.row]
               
                cell.WPAdressTextField.tag = 300 + indexPath.row
            }else{
            //shipping
                cell.WPAdressTextField.text = shippingAdressText[indexPath.row]
                cell.WPAdressTextField.tag = 200 + indexPath.row
            }
            cell.WPAdressTextField.indexPath = indexPath
            return cell
        }
       
        cardNuberCell = tableView.dequeueReusableCell(withIdentifier: WPCreditCardTableViewCellID, for: indexPath) as! WPCreditCardTableViewCell
        cardNuberCell.WPCVVTextField.delegate = self
        cardNuberCell.WPDateTextField.delegate = self
        cardNuberCell.WPCardNumberTextField.delegate = self
        //添加观察者
        cardNuberCell.WPCardNumberTextField.addObserver(self, forKeyPath: "selectedTextRange", options: [.new,.old], context: nil)
        return cardNuberCell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0{
            
            return 32
        }
        
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section > 0 {
            return 32
        }
        
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let basic = UIView.init()
          
            let label = UILabel.init()
            basic.addSubview(label)
            label.text = "Billing Address"
            label.PingFangSC(type: .medium, fontSize: 14)
            label.textColor = UIColor.init(hexStr: "#86919D")
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leftAnchor.constraint(equalTo: basic.leftAnchor, constant: 18).isActive = true
            label.topAnchor.constraint(equalTo: basic.topAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: basic.bottomAnchor).isActive = true
            
            return basic
            
        }
        
        if section == 1 {
            let basic = UIView.init()
          
            let label = UILabel.init()
            basic.addSubview(label)
            label.text = "Shipping Address"
            label.PingFangSC(type: .medium, fontSize: 14)
            label.textColor = UIColor.init(hexStr: "#86919D")
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leftAnchor.constraint(equalTo: basic.leftAnchor, constant: 18).isActive = true
            label.topAnchor.constraint(equalTo: basic.topAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: basic.bottomAnchor).isActive = true
            
            return basic
            
        }
        
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let basic = UIView.init()
            basic.addSubview(checkBox)
            checkBox.translatesAutoresizingMaskIntoConstraints = false
            checkBox.leftAnchor.constraint(equalTo: basic.leftAnchor, constant: 18).isActive = true
            checkBox.topAnchor.constraint(equalTo: basic.topAnchor).isActive = true
            checkBox.bottomAnchor.constraint(equalTo: basic.bottomAnchor).isActive = true
            return basic
        }
        
        return UIView()
    }
    
 
    
    @objc func clickShipingAdressButton(sender:WPCheckBox){
        sender.isSelected = !sender.isSelected
        //是否显示bill adress
        if sender.isSelected == false {
            tabbarViewSection = 2 + 1
        }else{
            tabbarViewSection = 2
        }
        topView.reloadData()
    }
    

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let WPTF = textField as? WPPayTextField
        ///弹出国家选择器
        if WPTF != nil && WPTF?.type == .addressPick {
            lastTextField.resignFirstResponder()
            addressPickView.indexPath = WPTF!.indexPath
            addressPickView.show(animation: true)
            return false
        }
        lastTextField = textField
        return true
    }
      
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let wptf = textField as? WPPayTextField else {
            return
        }
        if wptf.indexPath.section == 2 {
            billAdressText[wptf.tag - 300] = wptf.text ?? ""
            addBillAdressParameter(name: wptf.name, text: wptf.text ?? "")
        }else if wptf.indexPath.section == 1{
            shippingAdressText[wptf.tag - 200] = wptf.text ?? ""
            addShippingAdressParameter(name: wptf.name, text: wptf.text ?? "")
        }
    }
    
    
    //验证
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let wptf = textField as? WPPayTextField
        if wptf != nil{
            switch wptf!.name {
                //卡号
            case .CardNumber:
                ///不超过15位
                if range.location > 19 {
                    return false
                }
                if range.location % 5 == 0 && range.length == 0{
                    textField.text?.append(" ")
                }
                if range.location % 5 == 1 && range.length == 1 {
                    textField.text?.removeLast()
                }
            case .CardDate:
                    if range.location > 6 {
                        return false
                    }
                    
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
            case .CardCVC:
                    if range.location > 3 {
                        return false
                    }
                
            default:
                break ;
            }
            
            
        }
           
            return true
        }
    

    
}



