//
//  DictionaryPresenter.swift
//  Translator
//
//  Created by Alexander Khvan on 30.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

class DictionaryPresenter: DictionaryPresenterProtocol {
    
    weak var view: DictionaryViewProtocol?

    func present(state: Dict.State) {
        let model = convert(state: state)
        DispatchQueue.main.async { [weak self] in
            self?.view?.render(model: model)
        }
    }
    
    private func convert(state: Dict.State) -> Dict.ViewModel {
        let items = state.records.map { ($0.key.text, $0.value.first?.text ?? "") }
        return Dict.ViewModel(langFrom: state.langFrom.description(), langTo: state.langTo.description(), items: items)
    }
}
