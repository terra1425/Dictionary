//
//  Navigation.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation
import UIKit

protocol BaseRoute {}

enum RootRoute : BaseRoute {
    case translator(text: String?), dictionary
}

protocol RootRouterProtocol: class {
    func route(_ route: RootRoute)
}

protocol ModuleRouterProtocol: class {
    var rootRouter: RootRouterProtocol? { get set }
    func route(from: UIViewController, to route: BaseRoute)
}


