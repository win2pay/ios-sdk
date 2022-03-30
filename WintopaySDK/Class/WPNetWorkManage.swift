//
//  WPNetWorkManage.swift
//  WintopaySDK
//
//  Created by 易购付 on 2021/6/4.
//

import UIKit
import Alamofire

///卡类型
@objc public enum WPCardBrand: Int {
    
    case visa
    
    case amex
    
    case mastercard
    
    case discover
    
    case JCB
    
    case dinersClub
    
    case unionPay
    
    case unknown
}


//支付结果样式
public enum WPPaymentResultStyle {
    ///显示页面
    case wp_view
    ///显示数据
    case wp_data
}

///支付基础信息
public struct WPBasicParameter: Encodable {
    ///设备类型
    ///填写ios或者是android，如果是app端因卡信息加密问题请务必填写，如果是3d交易，使用自定义的成功失败界面时传ios_no或android_no
    var equipment:String = "ios"
    ///商户号
    var merchant_id:String
    ///信用卡卡号
    var card_number:String
    ///信用卡安全码
    var cvv:String
    ///信用卡有效期(月份:MM)
    var exp_month:String
    ///信用卡有效期(年份:YYYY)
    var exp_year:String
    ///商户订单号
    var order_id:String
    ///订单金额
    var amount:String
    ///货币代码
    var currency:String
    ///支付语言(国家两位简码)
    var language:String
    ///商户号+md5Key+订单号+订单金额+订单币种+网站 url
    var hash:String
    ///（非必填）扩展字段
    var metadata:String?
    ///版本号
    var version:String
    /// 用户代理，请求头的 user_agent
    var user_agent:String
    
    
    
    
    public init(merchant_id id:String, card_number cn: String, cvv cv2: String, exp_month month: String, exp_year year: String, order_id o_id: String, amount am: String, currency cur: String, language lang: String, hash ha: String, metadata meta: String?, version ver: String, user_agent agent: String,equipment equip:String){
        merchant_id = id
        card_number = cn
        cvv = cv2
        exp_month = month
        exp_year = year
        order_id = o_id
        amount = am
        currency = cur
        language = lang
        hash = ha
        metadata = meta
        version = ver
        user_agent = agent
        if equip.isEmpty != true {
            equipment = equip
        }
        
    }
}

///客户账单地址
public struct WPBillingAddressParameter: Encodable {
    ///西方人名的第一个字
    var billing_first_name:String
    ///后面的名字
    var billing_last_name:String
    ///邮箱
    var billing_email:String
    ///电话
    var billing_phone:String
    ///邮编
    var billing_postal_code:String
    ///详细地址
    var billing_address:String
    ///城市
    var billing_city:String
    ///州简码或者州的完整名字
    ///如 California: CA,New York:NY，优先考虑使用简码。
    var billing_state:String
    ///国家对应的两位 ISO 标准国家简码
    var billing_country:String
    ///客户端的 ip 地址，注意不是服务器的 ip
    var ip:String
    
    public init(billing_first_name fname: String, billing_last_name lname: String, billing_email email: String, billing_phone phone: String, billing_postal_code code: String, billing_address address: String, billing_city city: String, billing_state state: String, billing_country country: String, ip _ip: String){
        billing_first_name = fname
        billing_last_name = lname
        billing_phone = phone
        billing_state = state
        billing_postal_code = code
        billing_address = address
        billing_city = city
        billing_country = country
        ip = _ip
        billing_email = email
    }
}

///客户收货地址信息
public struct WPShippingAddressParameter: Encodable {
    ///西方人名的第一个字
    var shipping_first_name:String
    ///后面的名字
    var shipping_last_name:String
    ///邮箱
    var shipping_email:String
    ///电话
    var shipping_phone:String
    ///邮编
    var shipping_postal_code:String
    ///详细地址
    var shipping_address:String
    ///城市
    var shipping_city:String
    ///州简码或者州的完整名字
    ///如 California: CA,New York:NY，优先考虑使用简码。
    var shipping_state:String
    ///国家对应的两位 ISO 标准国家简码
    var shipping_country:String
    
    public init(shipping_first_name fname: String, shipping_last_name lname: String, shipping_email email: String, shipping_phone phone: String, shipping_postal_code code: String, shipping_address adress: String, shipping_city city: String, shipping_state state: String, shipping_country country: String){
        shipping_first_name = fname
        shipping_last_name = lname
        shipping_email = email
        shipping_phone = phone
        shipping_postal_code = code
        shipping_address = adress
        shipping_city = city
        shipping_state = state
        shipping_country = country
    }
}

///商品信息
public struct WPProductsInformationParameter:Encodable {
    ///客户购买的商品信息
    ///字典数组形式
    ///-eg：[{"a":"b","c":"d"}]
    ///包括 sku,name,amount,quantity,currency,商品信息以 json 字符的形式提交，长度无限制
    var products:String
    
    public init(productsArray pro:[WPProductsEncodable]){
        products = WPTool.toProductsJsonString(products: pro) ?? ""
    }
}

///产品信息model
public struct WPProductsEncodable:Encodable{
    
    var sku:String
    
    var name:String
    
    var amount:String
    
    var quantity:String
    
    var currency:String
    
    //init
    public init(sku _sku:String,name _name:String,amount _amount:String,quantity _quantity:String,currency _currency:String){
        sku = _sku
        name = _name
        amount = _amount
        quantity = _quantity
        currency = _currency
    }
    
}


public struct RequestModel: Encodable{
    
    public var basicInformation: WPBasicParameter
    
    public var billingInformation: WPBillingAddressParameter
    
    public var shippingInformation:WPShippingAddressParameter
    
    public var productsInforamtion:WPProductsInformationParameter
    
    public init(basic:WPBasicParameter,billing:WPBillingAddressParameter,shipping:WPShippingAddressParameter,products:WPProductsInformationParameter) {
        
        basicInformation = basic
        billingInformation = billing
        shippingInformation = shipping
        productsInforamtion = products
    }
    
    public  enum CodingKeys: String, CodingKey {
        
        case merchant_id,card_number,cvv,exp_month,exp_year,order_id,amount,currency,language,hash,version,session_id,user_agent,metadata,equipment
        case billing_first_name,billing_last_name,billing_email,billing_phone,billing_postal_code,billing_address,billing_city,billing_state,billing_country,ip
        case shipping_first_name,shipping_last_name,shipping_email,shipping_phone,shipping_postal_code,shipping_address,shipping_city,shipping_state,shipping_country
        case products
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(basicInformation.merchant_id, forKey: RequestModel.CodingKeys.merchant_id)
        try container.encode(basicInformation.card_number, forKey: RequestModel.CodingKeys.card_number)
        try container.encode(basicInformation.cvv, forKey: RequestModel.CodingKeys.cvv)
        try container.encode(basicInformation.exp_month, forKey: RequestModel.CodingKeys.exp_month)
        try container.encode(basicInformation.exp_year, forKey: RequestModel.CodingKeys.exp_year)
        try container.encode(basicInformation.order_id, forKey: RequestModel.CodingKeys.order_id)
        try container.encode(basicInformation.amount, forKey: RequestModel.CodingKeys.amount)
        try container.encode(basicInformation.currency, forKey: RequestModel.CodingKeys.currency)
        try container.encode(basicInformation.language, forKey: RequestModel.CodingKeys.language)
        try container.encode(basicInformation.hash, forKey: RequestModel.CodingKeys.hash)
        try container.encode(basicInformation.metadata, forKey: RequestModel.CodingKeys.metadata)
        try container.encode(basicInformation.version, forKey: RequestModel.CodingKeys.version)
        try container.encode(basicInformation.user_agent, forKey: RequestModel.CodingKeys.user_agent)
        try container.encode(basicInformation.equipment, forKey: RequestModel.CodingKeys.equipment)
        
        try container.encode(billingInformation.billing_first_name, forKey: RequestModel.CodingKeys.billing_first_name)
        try container.encode(billingInformation.billing_last_name, forKey: RequestModel.CodingKeys.billing_last_name)
        try container.encode(billingInformation.billing_email, forKey: RequestModel.CodingKeys.billing_email)
        try container.encode(billingInformation.billing_phone, forKey: RequestModel.CodingKeys.billing_phone)
        try container.encode(billingInformation.billing_postal_code, forKey: RequestModel.CodingKeys.billing_postal_code)
        try container.encode(billingInformation.billing_address, forKey: RequestModel.CodingKeys.billing_address)
        try container.encode(billingInformation.billing_city, forKey: RequestModel.CodingKeys.billing_city)
        try container.encode(billingInformation.billing_state, forKey: RequestModel.CodingKeys.billing_state)
        try container.encode(billingInformation.billing_country, forKey: RequestModel.CodingKeys.billing_country)
        try container.encode(billingInformation.ip, forKey: RequestModel.CodingKeys.ip)
        
        try container.encode(shippingInformation.shipping_first_name, forKey: RequestModel.CodingKeys.shipping_first_name)
        try container.encode(shippingInformation.shipping_last_name, forKey: RequestModel.CodingKeys.shipping_last_name)
        try container.encode(shippingInformation.shipping_email, forKey: RequestModel.CodingKeys.shipping_email)
        try container.encode(shippingInformation.shipping_phone, forKey: RequestModel.CodingKeys.shipping_phone)
        try container.encode(shippingInformation.shipping_postal_code, forKey: RequestModel.CodingKeys.shipping_postal_code)
        try container.encode(shippingInformation.shipping_address, forKey: RequestModel.CodingKeys.shipping_address)
        try container.encode(shippingInformation.shipping_city, forKey: RequestModel.CodingKeys.shipping_city)
        try container.encode(shippingInformation.shipping_state, forKey: RequestModel.CodingKeys.shipping_state)
        try container.encode(shippingInformation.shipping_country, forKey: RequestModel.CodingKeys.shipping_country)
        
        try container.encode(productsInforamtion.products, forKey: RequestModel.CodingKeys.products)
    }
}

public struct requestResult: Decodable {
    ///订单金额，单位为 “分”
    public  var amount_value: Float
    ///创建时间
    public var created: Int
    ///货币代码
    public var currency: String?
    ///失败状态码
    public var fail_code:String?
    ///失败原因
    public var fail_message:String?
    ///订单流水号
    public var id:String?
    ///支付结果详细信息
    public var message:String
    ///扩展字段，值类型为 json，响应返回和回调 callback
    public var metadata:String?
    ///商户订单号
    public var order_id:String?
    ///生产模式，值为 ”true” 或 ”false”
    public var production_mode:Bool
    ///3D支付URL
    public var redirect_url:String?
    ///请求 id，值唯一
    public var request_id:String
    ///流水号+支付状态+订单金额(单位 分)+md5Key+商户号+请求 id，按照顺序 拼接，计算 SHA-256 摘要值，并转为 16 进制字符串(小写)
    public var sign_verify:String?
    ///扩展字段，值暂时默认为”card”
    public var source_type:String
    ///订单支付结果状态码，”paid” 为成功, ” pending” 为待处理, ” failed”为失败, ” canceled”为取消
    public var status:String
    ///版本号，当前版本号为“20201001”
    public var version:String
    
}

public class WPNetWorkManage: NSObject {
    
    public static let manage = WPNetWorkManage()
    
    ///银行卡类型
    var cardBrand:WPCardBrand = .unknown
    
    ///referer
    public var referer:String = ""
    
    ///商户号（必填）
    public var MerNo:String = ""
    
    ///md5key（必填）
    public var Md5key:String = ""{
        didSet{
            
        }
    }
    
    ///网关地址(必填)
    //public var gateway:String = "http://192.168.3.202:8012/api/v2/gateway/payment"
    public var gateway:String = ""
    
    ///支付接口参数
    public var parameters:RequestModel?
    
    ///支付账单地址参数
    public var billAdress:WPBillingAddressParameter?
    
    ///支付收获地址参数
    public var shippingAddress:WPShippingAddressParameter?
    
    ///支付产品信息参数
    public var productsInformation:WPProductsInformationParameter?
    
    ///支付返回结果风格
    ///@wp_view 返回支付页面
    ///@wp_data 返回支付数据
    public var paymentResultStyle:WPPaymentResultStyle = .wp_view
    
    
    ///获取哈希值
    func payHash(){
        //商户号+md5Key+订单号+订单金额+订单币种+网站 url
        if self.MerNo.isEmpty == true || self.Md5key.isEmpty == true{
            print("hase error! reason:merNo or Md5key is null")
            return
        }
        if parameters == nil {
            print("hase error! reason:parameters is nil")
            return
        }
        let hashString = self.MerNo + self.Md5key + parameters!.basicInformation.order_id + parameters!.basicInformation.amount + parameters!.basicInformation.currency + self.referer
        //        let hashString = "nmnjsnda".sha256
        let resultHash = hashString.bytes.sha256().toHexString()
        print("hash==",hashString,resultHash)
        self.parameters?.basicInformation.hash = resultHash
    }
    
    
    ///支付请求
    ///返回 requestResult：Decodable
    public func request(parameter:RequestModel,success:@escaping (requestResult) -> (),failure:@escaping (AFError?) -> ()){
        
        if MerNo != parameter.basicInformation.merchant_id {
            print("MerchantNo is not match")
        }
        let headers = HTTPHeaders.init(["Referer":referer,"MerNo":MerNo])
        let code = JSONEncoder.init()
        guard let data = try? code.encode(parameter) else {
            print("parameter encode fail")
            return
        }
        let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
        if dict != nil {
            DispatchQueue.global().async { [self] in
                AF.request(self.gateway, method: .post, parameters: dict!, encoding: URLEncoding.default, headers: headers, interceptor: nil).response { (response) in
                    if response.data != nil{
                        guard let data = response.data else {
                            return
                        }
                        do {
                            let json = try JSONDecoder.init().decode(requestResult.self, from: data)
                            print(json,"json")
                            success(json)
                        } catch {
                            print(error)
                        }
                    }else{
                        
                        print("response == nil")
                    }
                    if response.error != nil{
                        failure(response.error)
                    }
                    
                }
            }
        }
        
    }
    
    
    
    
}
