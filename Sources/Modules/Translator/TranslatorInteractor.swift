//
//  TranslatorInteractor.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

class TranslatorInteractor: TranslatorInteractorProtocol {
    var presenter: TranslatorPresenterProtocol?

    private var state = Translator.defaultState

    private let reducer = Translator.Reducer()
    
    private let repo: RepositoryProtocol = Repository()
    
    func translate(text: String) {
        state = reducer.reduce(state: state, by: Translator.Wish.changeText(text)) ?? state
        presenter?.present(state: state)
        repo.searchTranslationFor(idiom: state.idiom, to: state.langTo) { [weak self] translations in
            guard let `self` = self else { return }
            translations.forEach {
                self.state = self.reducer.reduce(state: self.state, by: .addTranslation($0)) ?? self.state
            }
            self.presenter?.present(state: self.state)
        }
    }
    
    func changeSourceLanguage(to langDescription: String) {
        if let lang = Idiom.Language.from(string: langDescription) {
            state = reducer.reduce(state: state, by: Translator.Wish.changeSourceLanguageTo(lang)) ?? state
            presenter?.present(state: state)
        }
    }
    
    func changeDestinationLanguage(to langDescription: String) {
        if let lang = Idiom.Language.from(string: langDescription) {
            state = reducer.reduce(state: state, by: Translator.Wish.changeDestinationLanguageTo(lang)) ?? state
            presenter?.present(state: state)
            translate(text: state.idiom.text)
        }
    }
    
    func reverseLanguages() {
        state = reducer.reduce(state: state, by: Translator.Wish.reverseLanguages) ?? state
        presenter?.present(state: state)
        translate(text: state.idiom.text)
    }

    func update() {
        presenter?.present(state: state)
    }
}
