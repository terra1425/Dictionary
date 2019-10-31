//
//  Configurator.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation
import UIKit

protocol BaseConfigurator: class {
    func build() -> UIViewController
}

class Dashboard {
    class Configurator: BaseConfigurator {
        func build() -> UIViewController {
            let nc = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "DashboardController") as! DashboardViewController
            return nc
        }
    }
}

