//
//  DictionaryRouter.swift
//  Translator
//
//  Created by Alexander Khvan on 30.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation
import UIKit

class DictionaryRouter: DictionaryRouterProtocol {
    weak var rootRouter: RootRouterProtocol?

    func route(from: UIViewController, to route: BaseRoute) {}
}
