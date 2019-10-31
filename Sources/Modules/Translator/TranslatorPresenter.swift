//
//  TranslatorPresenter.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

class TranslatorPresenter: TranslatorPresenterProtocol {
    
    weak var view: TranslatorViewProtocol?
    
    func present(state: Translator.State) {
        // Concatenate translations
        let translationText = state.translations?.reduce(String(), { (result: String, idiom) -> String in
            return String("\(result)\n\(idiom.text)")
        })
        let model = Translator.ViewModel(langFrom: state.idiom.lang.description(), langTo: state.langTo.description(), text: state.idiom.text, translation: translationText)
        DispatchQueue.main.async { [weak self] in
            self?.view?.render(model: model)
        }
    }
}
