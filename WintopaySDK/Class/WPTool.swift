//
//  WPTool.swift
//  WintopaySDK
//
//  Created by 易购付 on 2021/6/1.
//

import Foundation
import UIKit
import CryptoSwift
import CommonCrypto
import WebKit
import Alamofire

enum pingFangSCqWeight:String{
    case thin = "PingFangSC-Thin"
    case regular = "PingFangSC-Regular"
    case light = "PingFangSC-Light"
    case medium = "PingFangSC-Medium"
    case Semibold = "PingFangSC-Semibold"
    case ultralight = "PingFangSC-Ultralight"
}



extension UIColor {
    // Hex String -> UIColor
    convenience init(hexStr: String) {
        // 存储转换后的数值
        var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
        var hex = hexStr
        // 如果传入的十六进制颜色有前缀，去掉前缀
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
         hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        } else if hex.hasPrefix("#") {
         hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        // 如果传入的字符数量不足6位按照后边都为0处理，当然你也可以进行其它操作
        if hex.count < 6 {
         for _ in 0..<6-hex.count {
          hex += "0"
         }
        }
        // 分别进行转换
        // 红
        Scanner(string: String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])).scanHexInt64(&red)
        // 绿
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])).scanHexInt64(&green)
        // 蓝
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 4)...])).scanHexInt64(&blue)
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
       }
    
    
}

extension UILabel{
    
    /**
     设置PF字体
     */
    func PingFangSC(type:pingFangSCqWeight,fontSize:CGFloat){
        self.font = UIFont.init(name:type.rawValue, size:fontSize)
    }
    
    
}

extension UIImage{
    
    /// 加载bundle图片
    ///  -name:图片名字（带图片格式）
    ///  -eg:xxx.png
    class func WPBundleImage(name:String) -> UIImage?{
        let bundlePath = Bundle.main.path(forResource:"Wintopay", ofType:"bundle")
        guard let path = bundlePath else { return nil }
        let ImagePath = path + "/" + name
        return UIImage.init(contentsOfFile: ImagePath)
    }
    
    
    
    ///根据卡种类型显示对应的卡种图片
    /// -brand：卡类型
    /// -eg: visa
    class func getCardBrankImage(brand:WPCardBrand) -> UIImage?{
        let imageName:String
        switch brand {
        case .visa:
            imageName = "wtp_ic_visa.png"
        case .unknown:
            imageName = ""
        case .JCB:
            imageName = "wtp_ic_jcb.png"
        case .amex:
            imageName = "wtp_ic_ae.png"
        case .dinersClub:
            imageName = "wtp_ic_din.png"
        case .discover:
            imageName = "wtp_ic_dc.png"
        case .mastercard:
            imageName = "wtp_ic_master.png"
        case .unionPay:
            imageName = ""
        }
        let bundlePath = Bundle.main.path(forResource:"Wintopay", ofType:"bundle")
        guard let path = bundlePath else { return nil}
        let ImagePath = path + "/" + imageName
        return UIImage.init(contentsOfFile: ImagePath)
    }
    
    
}

extension String {
    
    /// String使用下标截取字符串
    /// string[index,length] 例如："abcdefg"[3,2] // de
    subscript (index:Int , length:Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length)
            return String(self[startIndex..<endIndex])
        }
    }

    ///sha1 加密
    func sha1() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    ///sha256 加密
    var sha256: String {
        let utf8 = cString(using: .utf8)
        
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest)
        
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
        
    }
    ///判断是否为数字
    var purnInt:Bool{
        let scan: Scanner = Scanner(string:self)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
        
    }
            
    ///卡信息加密
    func encryptCardInformation() -> String?{
        var Md5key = WPNetWorkManage.manage.Md5key
        if  Md5key.isEmpty == true {
            print("MD5 is null")
            return nil
        }
        // 如果md5key不足16位按照后边都为0处理
        if Md5key.count < 16 {
         for _ in 0..<16-Md5key.count {
            Md5key += "0"
         }
        }
        //去掉空格
        let newString = self.replacingOccurrences(of: " ", with: "")
        return WPTool.AESEncrypt(newString, key: Md5key)
    }
    
    ///获取年
    func getYear() -> String? {
        if self.count < 7 {
            print("")
            return nil
        }
        let year = self.suffix(4)
        print(year)
        return String(year)
    }
    
    ///获取月
    func getMonth() -> String? {
        if self.count < 7 {
            print("")
            return nil
        }
        let Month = self.prefix(2)
        return String(Month)
    }
    
    
}

extension UITextField{
    
    ///获取光标的位置
    func selectedRange() -> NSRange? {
        let beginning = self.beginningOfDocument
        let selectedRange = self.selectedTextRange
        guard let selectStart = selectedRange?.start else {
            return nil
        }
        guard let selectEnd = selectedRange?.end else {
            return nil
        }
        let location = self.offset(from: beginning, to: selectStart)
        let lenght = self.offset(from: selectStart, to: selectEnd)
        return NSMakeRange(location, lenght)
    }
    
   
}

public class WPTool: NSObject {

    
    
    ///AES加密
   public class func AESEncrypt(_ str:String,key:String) -> String {
    var encryptedStr = ""
          do {
              let encrypted = try AES.init(key: key.bytes, blockMode:CBC.init(iv:"d3a8e602be44ce21".bytes), padding: .pkcs5)
             let encoded = try encrypted.encrypt(str.bytes)
             // encryptedStr = encoded.toHexString()
              encryptedStr = encoded.toBase64()
          } catch {
              print(error.localizedDescription)
          }
          return encryptedStr
    }
    

    ///AES解密
    public class func aes_decrypt(_ str:String , aes_key:String) -> String{
           //decode base64
           let data = Data(base64Encoded: str, options: .ignoreUnknownCharacters)!
           
           var decrypted: [UInt8] = []
           do {
               // decode AES
               decrypted = try AES(key: Array(aes_key.utf8), blockMode: CBC.init(iv: "0392039203920300".bytes), padding: .pkcs7).decrypt(data.bytes);
              
           } catch {
               print(error.localizedDescription,"解密失败")
           }
           //解密结果从data转成string 转换失败  返回""
           return String(bytes: Data(decrypted).bytes, encoding: .utf8) ?? ""
       }
    
    ///获取当前视图所在导航控制器
    class func getControllerfromview(view:UIView)->UIViewController?{
        var nextResponder: UIResponder? = view
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
        
    }
    
    
    ///获取手机当前显示的ViewController
    class func currentViewController() -> UIViewController?{
        var vc = UIApplication.shared.windows.first{ $0.isKeyWindow}?.rootViewController

        if (vc != nil) {
             if vc?.isKind(of: UITabBarController.self) == true {
                let newVc = vc as! UITabBarController
                vc = newVc.selectedViewController
            }
            if vc?.isKind(of: UINavigationController.self) == true {
                let newNv = vc as! UINavigationController
                vc = newNv.visibleViewController
            }
                
            if vc?.presentedViewController != nil {
                vc = vc?.presentedViewController
            }
        }
        
        return vc
    }
    
    
    ///显示卡号对应的图片
    class func showEditingCardBrandImage(textFieldText:String) -> UIImage? {
        //去掉空格
       let newString = textFieldText.replacingOccurrences(of: " ", with: "")
        
        var first:String
        if newString.count < 2 {
          first = textFieldText + "0"
        }else{
          first = textFieldText[0,2]
        }
        
        print("。。。===",first)
        guard let firstInt = Int(first) else {
            return nil
        }
        var imageName:String
        switch firstInt {
        case 40..<49:
            imageName = "wtp_ic_visa.png"
        case 50..<59,67:
            imageName = "wtp_ic_master.png"
        case 35:
            imageName = "wtp_ic_jcb.png"
        case 34,37:
            imageName = "wtp_ic_ae.png"
        case 30,36,38,39:
            imageName = "wtp_ic_din.png"
        case 60,64,65:
            imageName = "wtp_ic_dc.png"
        default:
            imageName = ""
        }
        
       return UIImage.WPBundleImage(name: imageName)
  }
    
   ///产品信息转JSONString
    public class func toProductsJsonString<T:Encodable>(products:[T]) -> String? {
        guard let json = try? JSONEncoder.init().encode(products) else {
            return nil
        }
        return String.init(data: json, encoding: .utf8)
    }
    
    ///encodable转JSONString
     public class func encodableToJsonString<T:Encodable>(encodable:T) -> String? {
         guard let json = try? JSONEncoder.init().encode(encodable) else {
             return nil
         }
         return String.init(data: json, encoding: .utf8)
     }
    
    ///encodable转字典
    public class func encodableToDictionary<T:Encodable>(encodable:T) -> [String:Any]? {
         guard let json = try? JSONEncoder.init().encode(encodable) else {
             return nil
         }
        guard let dic = try? JSONSerialization.jsonObject(with: json, options: .fragmentsAllowed) as? [String:Any] else { return nil }
         
         return dic
     }
    
    
    
    ///显示文字loading 没有阴影
    public class func showOnlyTextNoMask(message:String){
        
        let messageView = UIView.init()
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        window.addSubview(messageView)
        messageView.backgroundColor = UIColor.init(red: 0, green:0, blue: 0, alpha: 0.7)
        messageView.layer.cornerRadius = 8
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        messageView.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
        
        let messageLabel = UILabel.init()
        messageView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 14).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -14).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 22).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant:-22).isActive = true
        messageLabel.numberOfLines = 2
        messageLabel.alpha = 1
        messageLabel.textColor = UIColor.init(hexStr: "#FFFFFF")
      
        messageLabel.PingFangSC(type: .medium, fontSize: 14)
        messageLabel.clipsToBounds = true
        messageLabel.text = message
        messageLabel.textAlignment = .center
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.9) {
            messageView.removeFromSuperview()
        }
        
        
    }
    

    
    ///获取user—agent
    public class func getUserAgent() -> String? {
      let userAgent = WKWebView().value(forKey: "userAgent")
      return userAgent as? String ?? ""
    }
    
    
}




public class EnumerateNetworkInterfaces {
    public struct NetworkInterfaceInfo {
        public let name: String
        public let ip: String
        public let netmask: String
    }
    public static func enumerate() -> [NetworkInterfaceInfo] {
        var interfaces = [NetworkInterfaceInfo]()

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {

            // For each interface ...
            var ptr = ifaddr
            while( ptr != nil) {

                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee

                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {

                        var mask = ptr!.pointee.ifa_netmask.pointee

                        // Convert interface address to a human readable string:
                        let zero  = CChar(0)
                        var hostname = [CChar](repeating: zero, count: Int(NI_MAXHOST))
                        var netmask =  [CChar](repeating: zero, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                        nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            let address = String(cString: hostname)
                            let name = ptr!.pointee.ifa_name!
                            let ifname = String(cString: name)


                            if (getnameinfo(&mask, socklen_t(mask.sa_len), &netmask, socklen_t(netmask.count),
                                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                let netmaskIP = String(cString: netmask)

                                let info = NetworkInterfaceInfo(name: ifname,
                                                                ip: address,
                                                                netmask: netmaskIP)
                                interfaces.append(info)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return interfaces
    }
}
