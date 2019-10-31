//
//  DictionaryInteractor.swift
//  Translator
//
//  Created by Alexander Khvan on 30.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

class DictionaryInteractor: DictionaryInteractorProtocol {
    var presenter: DictionaryPresenterProtocol?
    
    var repo: RepositoryProtocol?

    private let reducer = Dict.Reducer()
    
    private var state = Dict.defaultState
    
    private var collector: Collector?

    func deleteAll() {
        guard let repository = repo  else { return }
        repository.removeAllIdiomsFor(language: state.langFrom)
        state = reducer.reduce(state: state, by: .removeAll) ?? state
        presenter?.present(state: state)
    }
    
    func update() {
        guard let repository = repo  else { return }
        state = reducer.reduce(state: state, by: .removeAll) ?? state
        populateEmptyItems(from: repository)
        getTranslationsFrom(repository: repository) { [weak self ] newState in
            self?.presenter?.present(state: newState)
        }
    }
    
    func changeSourceLanguage(to langDescription: String) {
        if let lang = Idiom.Language.from(string: langDescription) {
            state = reducer.reduce(state: state, by: Dict.Wish.changeSourceLanguageTo(lang)) ?? state
            update()
        }
    }
    
    func changeDestinationLanguage(to langDescription: String) {
        if let lang = Idiom.Language.from(string: langDescription) {
            state = reducer.reduce(state: state, by: Dict.Wish.changeDestinationLanguageTo(lang)) ?? state
            update()
        }
    }
    
    func reverseLanguages() {
        state = reducer.reduce(state: state, by: Dict.Wish.reverseLanguages) ?? state
        update()
    }
    
    private func getTranslationsFrom(repository: RepositoryProtocol, stateHandler: @escaping (Dict.State)->Void) {
        collector = Collector(with: state.records.map {$0.key}, to: state.langTo, repository: repository)
        collector?.completionHandler = { [weak self] data in
            guard let `self` = self else { return }
            if let newState = self.reducer.reduce(state: self.state, by: .populate(data)) {
                stateHandler(newState)
            }
        }
    }
    
    private func populateEmptyItems(from repository: RepositoryProtocol) {
        var items = [Idiom: [Idiom]]()
        repository.getAllIdiomsFor(language: state.langFrom).forEach {
            items[$0] = [Idiom(text: "", lang: state.langTo)]
        }
        state = reducer.reduce(state: state, by: .populate(items)) ?? state
    }
    
    
    class Collector {
        var completionHandler: (([Idiom: [Idiom]]) -> Void)?
        
        private var data = [Idiom]()
        
        private var result = [Idiom: [Idiom]]()
        
        private let writeQueue = DispatchQueue(label: "com.terra1425.collector", attributes: .concurrent)
        
        let dispGroup = DispatchGroup()
        
        init(with data: [Idiom], to lang: Idiom.Language, repository: RepositoryProtocol) {
            self.data = data
            load(from: repository, to: lang)
        }
        
        private func load(from repository: RepositoryProtocol, to lang: Idiom.Language) {
            data.forEach { idiom in
                dispGroup.enter()
                DispatchQueue.main.async(group: dispGroup) { [weak self] in
                    guard let `self` = self else { return }
                    repository.searchTranslationFor(idiom: idiom, to: lang) { translations in
                        self.writeQueue.async(flags: .barrier) {
                            self.result[idiom] = translations
                            self.dispGroup.leave()
                        }
                    }
                }
            }
            
            dispGroup.notify(queue: DispatchQueue.main) { [weak self] in
                guard let `self` = self else { return }
                self.completionHandler?(self.result)
            }
        }
    }
}
