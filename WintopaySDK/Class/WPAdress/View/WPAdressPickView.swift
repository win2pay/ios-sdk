//
//  WPAdressPickView.swift
//  payAdress
//
//  Created by 易购付 on 2022/4/13.
//

import UIKit

public let WPAdressPickView_bottomAnchor_identifier = "WPAdressPickView_bottomAnchor_identifier"

public let WPAdressPickView_TopAnchor_identifier = "WPAdressPickView_TopAnchor_identifier"


struct WPSelectorCountryStruct {
    ///国家名称
    var countryName:String
    
    ///国家简码 ISO国家代码
    var countryISO:String
    
    ///省、州名称
    var zoneName:String? = nil
    
    ///省、州名称 简码
    var zoneISO:String? = nil
}

///选择器 delegate
protocol WPAdressPickViewDelegate:NSObjectProtocol {
    
    ///返回地址信息
    ///@WPSelectorCountryStruct：国家-州信息结构体
    func selectAddress(contryInfo:WPSelectorCountryStruct,indexPath:IndexPath)
}

class WPAdressPickView: UIView {
    
    weak var delegate:WPAdressPickViewDelegate?
    
    public static let sharedInstance = WPAdressPickView.init()
    
    ///init
    convenience init() {
        self.init(frame: .zero)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        //加载json
        do {
            let bundlePath = Bundle.main.path(forResource:"Wintopay", ofType:"bundle")
            if bundlePath != nil {
                let jsonParh = bundlePath! + "/" + "Country.json"
    //            let path = Bundle.main.path(forResource: "Country", ofType: "json")
                let url = URL.init(fileURLWithPath: jsonParh)
                let date = try Data.init(contentsOf: url)
                let array = try JSONSerialization.jsonObject(with: date, options: .fragmentsAllowed) as? [[String:Any]]
                if array != nil {
                  countrys = array!
                }
            }

            
        } catch let err {
            print(err)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    let keyWindow = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first(where: { $0.isKeyWindow })
    
    ///选择器
    lazy var pickView:UIPickerView = UIPickerView.init()
    
    ///
    var indexPath:IndexPath = IndexPath()
    
    ///国家
    var countrys:[[String:Any]] = [[String:Any]]()
    
    ///取消
    lazy var cancal:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("Cancal", for: .normal)
        button.setTitleColor( .black, for: .normal)
        button.titleLabel?.PingFangSC(type: .medium, fontSize: 16)
        button.addTarget(self, action: #selector(hidePickView), for: .touchUpInside)
        return button
    }()
    
    ///确定
    lazy var confirm:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor( .black, for: .normal)
        button.titleLabel?.PingFangSC(type: .medium, fontSize: 16)
        button.addTarget(self, action: #selector(confirmCountry), for: .touchUpInside)
        return button
    }()
    
    
    ///添加约束
    open func addWPConstranint(){
        guard keyWindow != nil else {
            return print("keywindow is null")
        }
        
        let mask = UIView.init()
        mask.tag = 400
        mask.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        mask.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action:#selector(self.hideMask)))
        mask.frame = keyWindow!.frame
        mask.isHidden = true
        keyWindow?.addSubview(mask)
        
        keyWindow?.addSubview(self)
        
        
        guard let supView = self.superview else {
            print("supperView is nil")
            return
        }

//        supView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftAnchor.constraint(equalTo:supView.leftAnchor, constant: 0).isActive = true
        self.rightAnchor.constraint(equalTo: supView.rightAnchor, constant: 0).isActive = true
        self.heightAnchor.constraint(equalToConstant: 300).isActive = true
        let botttom = self.topAnchor.constraint(equalTo: supView.bottomAnchor, constant: 0)
        botttom.identifier = WPAdressPickView_TopAnchor_identifier
        botttom.isActive = true
        supView.setNeedsLayout()
        
        //pickview
        self.addSubview(pickView)
        pickView.translatesAutoresizingMaskIntoConstraints = false
        pickView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        pickView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        pickView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        pickView.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        pickView.backgroundColor = .white
        pickView.delegate = self
        pickView.dataSource = self
        
        //cancal
        self.addSubview(cancal)
        cancal.translatesAutoresizingMaskIntoConstraints = false
        cancal.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        cancal.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancal.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        //
        self.addSubview(confirm)
        confirm.translatesAutoresizingMaskIntoConstraints = false
        confirm.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        confirm.heightAnchor.constraint(equalToConstant: 40).isActive = true
        confirm.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

     }
    
    ///confirm
    @objc func confirmCountry(){
        //当前选中的获取数据
        let countryInt = pickView.selectedRow(inComponent: 0)
        let zoneInt = pickView.selectedRow(inComponent: 1)
        if countrys.count > countryInt {
          let sel_countryDic = countrys[countryInt]
          let c_name = sel_countryDic["name"] as? String
          let c_iso = sel_countryDic["iso"] as? String
          let zone = sel_countryDic["zone"] as? [[String:Any]]
            if zone != nil && zone?.count ?? 0 > zoneInt {
              let zoneDic =  zone![zoneInt] as? [String:String]
                if zoneDic != nil {
                    let z_name = zoneDic!["name"]
                    let z_iso = zoneDic!["code"]
                    delegate?.selectAddress(contryInfo: WPSelectorCountryStruct.init(countryName: c_name ?? "", countryISO: c_iso ?? "", zoneName: z_name , zoneISO: z_iso ), indexPath: indexPath)
                }else{
                    delegate?.selectAddress(contryInfo: WPSelectorCountryStruct.init(countryName: c_name ?? "", countryISO: c_iso ?? "", zoneName: nil, zoneISO: nil), indexPath: indexPath)
                }
            }else{
                delegate?.selectAddress(contryInfo: WPSelectorCountryStruct.init(countryName: c_name ?? "", countryISO: c_iso ?? "", zoneName: nil, zoneISO: nil), indexPath: indexPath)
            }

        }
        
        hideMask()
        hide(animation: true)
    }
    
    ///cancal
    @objc func hidePickView(){
        hideMask()
        hide(animation: true)
        
    }
    
    @objc func hideMask() {
        self.superview?.viewWithTag(400)?.isHidden = true
        self.hide(animation: true)
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
        self.superview?.viewWithTag(400)?.isHidden = false
        
        for constraint in supView.constraints {
            if constraint.identifier == WPAdressPickView_TopAnchor_identifier {
                supView.removeConstraint(constraint)
            }
        }
        let bottomConstrain = self.bottomAnchor.constraint(equalTo:supView.bottomAnchor, constant: 0)
        bottomConstrain.identifier = WPAdressPickView_bottomAnchor_identifier
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
            if constraint.identifier == WPAdressPickView_bottomAnchor_identifier {
                supView.removeConstraint(constraint)
            }
        }
        let topConstrain = self.topAnchor.constraint(equalTo:supView.bottomAnchor, constant: 0)
        topConstrain.identifier = WPAdressPickView_TopAnchor_identifier
        topConstrain.isActive =  true

        if animation == true {
            UIView.animate(withDuration: 0.3) {
                self.superview?.layoutIfNeeded()
            }
        }
        self.endEditing(false)
    }
    
    
    
}


extension WPAdressPickView:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 {
            let row = pickerView.selectedRow(inComponent: 0)
            let arry = countrys[row]["zone"] as? [[String:Any]]
            if arry != nil {
              return arry!.count
            }
            return 0
        }
        
        return countrys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 40
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return countrys[row]["name"] as? String
        }
        let first_row = pickerView.selectedRow(inComponent: 0)
        let arry = countrys[first_row]["zone"] as? [[String:Any]]
        if arry != nil {
          return arry![row]["name"] as? String
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //刷新第二列
        if component == 0 {
          pickerView.reloadComponent(1)
          pickerView.selectRow(0, inComponent: 1, animated: true)
        }
     
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "PingFangSC-Medium", size: 16.0)
            pickerLabel?.textAlignment = .center
        }

        if component == 0 {
            pickerLabel?.text = countrys[row]["name"] as? String
            
        }else{
            let first_row = pickerView.selectedRow(inComponent: 0)
            let arry = countrys[first_row]["zone"] as? [[String:Any]]
            if arry != nil {
                //防止同时滑动导致数组越界
                if arry!.count > row {
                    pickerLabel?.text = arry![row]["name"] as? String
                }
            }
        }
        return pickerLabel!
    }
    
    
    
    
    
    
    
    
}
