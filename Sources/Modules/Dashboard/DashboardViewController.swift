//
//  DashboardViewController.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import UIKit

class DashboardViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = UIColor(red: 241/255, green: 242/255, blue: 244/255, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor.black
    }
}

extension DashboardViewController: RootRouterProtocol {
    func route(_ route: RootRoute) {
        switch route {
            case .translator(let text):
                selectedIndex = 0
                if let controllers = viewControllers {
                    for c in controllers {
                        if let nc = c as? UINavigationController, let  vc = nc.topViewController as? TranslatorExternalProtocol {
                            vc.setExternal(text: text)
                            return
                        }
                    }
                }
                
            case .dictionary:
                selectedIndex = 1
        }
    }
}
