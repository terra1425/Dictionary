//
//  DictionaryInteractorProtocol.swift
//  Translator
//
//  Created by Alexander Khvan on 30.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

protocol DictionaryInteractorProtocol: class {
    var presenter: DictionaryPresenterProtocol? { get set } // STRONG
    
    func update()
    func changeSourceLanguage(to langDescription: String)
    func changeDestinationLanguage(to langDescription: String)
    func reverseLanguages()
    func deleteAll()
}

