//
//  DictionaryViewProtocol.swift
//  Translator
//
//  Created by Alexander Khvan on 30.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

protocol DictionaryViewProtocol: class {
    var interactor: DictionaryInteractorProtocol? { get set }  // STRONG
    var router: DictionaryRouterProtocol? { get set } // STRONG

    func render(model: Dict.ViewModel) 
}

