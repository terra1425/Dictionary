//
//  Bootstrapper.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Bootstrapper {
    var rootRouter: RootRouterProtocol?
    
    private var rootModule: BaseConfigurator?

    func setupStartViewController() {
        rootModule = Dashboard.Configurator()
        if let window = UIApplication.shared.delegate?.window {
            if let vc = rootModule?.build() {
                rootRouter = vc as? RootRouterProtocol
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
            }
        }
    }
    
    func setupCoreData() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
    }
}
