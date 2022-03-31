# ios-sdk WintopaySDK
## CocoaPods 安装
```
pod 'WintopaySDK'
```
## 如何使用
1.导入头文件
```
import WintopaySDK
```
2.创建WPNetWorkManage
```
let manage = WPNetWorkManage.manage
    manage.Md5key = "Md5key"
    manage.MerNo = "商户号"
    manage.gateway = "测试网关"
    manage.referer = "referer"
```
2.1 填写地址信息
```
    let billAdress = WPBillingAddressParameter.init(billing_first_name: "Zach-test", billing_last_name: "Wigginton", billing_email: "742823994@qq.com", billing_phone: "+1 04695308545", billing_postal_code: "67207", billing_address: "wichita", billing_city: "wichita", billing_state: "KS", billing_country: "US", ip: WPTool.getPublicIPAddress())
        let shipadress = WPShippingAddressParameter.init(shipping_first_name: "Za2ch-test", shipping_last_name: "Wigginton", shipping_email: "742853394@qq.com", shipping_phone: "+1 046925308545", shipping_postal_code: "67207", shipping_address: "2018SCr2anbrookSt", shipping_city: "wichi2ta", shipping_state: "KS", shipping_country: "US")
        manage.billAdress = billAdress
        manage.shippingAddress = shipadress
        manage.productsInformation = WPProductsInformationParameter.init(productsArray:[WPProductsEncodable.init(sku: "abdc", name: "what is this", amount: "", quantity: "1", currency: "USD")])
```

3.创建 WPPayView
```
 lazy var payView:WPPayView = {
        let pay = WPPayView.init(order_id: "test288822122", amount: "188", currency: "USD", language: "en", version: "20201001", user_agent: "")
        return pay
    }()
```
3.1 添加和代理
```
 payView.addWPConstranint()
 payView.delegate = self
```
```
extension ViewController:WPPayViewDelegate{
    
    ///支付结果代理回调
    func paymentResult(model: requestResult) {
        maskView.isHidden = true
        print("支付结果",model)
    }
    
}
```
4.弹出支付页面
```
//弹出
payView.show(animation: true)
//隐藏
payView.hide(animation: true)
```


