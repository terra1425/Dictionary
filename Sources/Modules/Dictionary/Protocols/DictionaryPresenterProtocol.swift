//
//  DictionaryPresenterProtocol.swift
//  Translator
//
//  Created by Alexander Khvan on 30.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

protocol DictionaryPresenterProtocol: class {
    var view: DictionaryViewProtocol? { get set } // WEAK

    func present(state: Dict.State)
}
