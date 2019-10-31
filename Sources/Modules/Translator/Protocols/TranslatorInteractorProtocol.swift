//
//  TranslatorInteractorProtocol.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

protocol TranslatorInteractorProtocol: class  {
    var presenter: TranslatorPresenterProtocol? { get set } // STRONG
    
    func changeSourceLanguage(to langDescription: String)
    func changeDestinationLanguage(to langDescription: String)
    func reverseLanguages()
    func translate(text: String)
    func update()
}
