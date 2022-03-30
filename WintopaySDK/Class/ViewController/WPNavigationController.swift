//
//  WPNavigationController.swift
//  WintopaySDK
//
//  Created by 易购付 on 2022/2/23.
//

import UIKit

open class WPNavigationController: UINavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    

    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
      
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image:UIImage.WPBundleImage(name: "back.png"), style: .plain, target: self, action: #selector(self.backClickedAction))
            viewController.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
          }
         super.pushViewController(viewController, animated: animated)
      }
    
    @objc private func backClickedAction(){
        self.popViewController(animated: false)
     
    }

}
