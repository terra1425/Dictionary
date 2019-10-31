//
//  RepositoryProtocol.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

protocol TranslatorProtocol {
    func searchTranslationFor(idiom: Idiom, to lang: Idiom.Language, handler: @escaping ([Idiom])->Void)
}

protocol RepositoryCacheProtocol {
    func getAllIdiomsFor(language: Idiom.Language, to targetLanguage: Idiom.Language) -> [Idiom]
    func removeAllIdiomsFor(language: Idiom.Language)
}

typealias RepositoryProtocol = RepositoryCacheProtocol & TranslatorProtocol
