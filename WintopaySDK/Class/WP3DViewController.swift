//
//  WP3DViewController.swift
//  WintopaySDK
//
//  Created by 易购付 on 2022/3/2.
//

import UIKit
import WebKit

class WP3DViewController: UIViewController {
    
    ///
    var urlString:String = ""
    
    
    lazy var webView:WKWebView = {
        let configuration = WKWebViewConfiguration.init()
        let web = WKWebView.init(frame: view.frame, configuration: configuration)
        return web
    }()
    
    ///进度条
    var progressView:UIProgressView = UIProgressView.init(progressViewStyle: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        self.view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        progressView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        progressView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        progressView.progressTintColor = UIColor.init(hexStr:"#2971BD")
        progressView.trackTintColor = .white
        progressView.progress = 0.0
        
        let url = URL.init(string: urlString)
        if url != nil {
            webView.load(URLRequest.init(url:url!))
        }
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [.new,.old], context: nil)
       
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress){
            guard let changes = change else {
                return
            }
            
            //  请注意这里读取options中数值的方法
            let newValue = changes[NSKeyValueChangeKey.newKey] as? Double ?? 0
            let oldValue = changes[NSKeyValueChangeKey.oldKey] as? Double ?? 0
           print("new",newValue,oldValue)
            
            // 因为我们已经设置了进度条为0.1，所以只有在进度大于0.1后再进行变化
            if newValue > oldValue && newValue > 0.1 {
                progressView.progress = Float(newValue)
            }
            
            // 当进度为100%时，隐藏progressLayer并将其初始值改为0
            if newValue == 1.0 {
                let time1 = DispatchTime.now() + 0.4
                let time2 = time1 + 0.1
                DispatchQueue.main.asyncAfter(deadline: time1) {
                    weak var weakself = self
                    weakself?.progressView.isHidden = true
                }
                DispatchQueue.main.asyncAfter(deadline: time2) {
                    weak var weakself = self
                    weakself?.progressView.isHidden = true
                }
            }


        }
    }
    

    

}

extension WP3DViewController:WKUIDelegate,WKNavigationDelegate{
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("加载完成")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("加载失败")
    }
    
    
}
