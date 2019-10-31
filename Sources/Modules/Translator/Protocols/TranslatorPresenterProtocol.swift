//
//  TranslatorPresenterProtocol.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

protocol TranslatorPresenterProtocol {
    var view: TranslatorViewProtocol? { get set } // WEAK
    
    func present(state: Translator.State)
}
