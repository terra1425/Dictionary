//
//  TranslatorViewProtocol.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation


protocol TranslatorViewProtocol: class {
    var interactor: TranslatorInteractorProtocol? { get set }  // STRONG
    var router: TranslatorRouterProtocol? { get set } // STRONG
    func render(model: Translator.ViewModel)
}

protocol TranslatorExternalProtocol: class {
    func setExternal(text: String?)
}
