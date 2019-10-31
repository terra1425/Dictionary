//
//  DictionaryConfigurator.swift
//  Translator
//
//  Created by Alexander Khvan on 30.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation
import UIKit

class Dict {
    static let defaultState = State(langFrom: .en, langTo: .ru, records: [:])
    
    enum Route : BaseRoute {
        case translator(Idiom?)
    }

    enum Wish: BaseWish {
        case changeSourceLanguageTo(Idiom.Language)
        case changeDestinationLanguageTo(Idiom.Language)
        case reverseLanguages
        case removeAll
        case populate([Idiom: [Idiom]])
    }
    
    struct ViewModel: MutableCopyProtocol {
        typealias Item = (text: String, translation: String)
        var langFrom: String
        var langTo: String
        var items: [Item]
    }
    
    struct State: BaseState {
        var langFrom: Idiom.Language
        var langTo: Idiom.Language
        var records: [Idiom: [Idiom]]
    }
    
    class Reducer: BaseReducer<State, Wish> {
        override func reduce(state: State, by action: Wish) -> State? {
            var newState: State?
            switch action {
                case Wish.changeDestinationLanguageTo(let lang):
                    newState = state.copy {
                        $0.langTo = lang
                        $0.records = [:]
                }
                
                case Wish.changeSourceLanguageTo(let lang):
                    newState = state.copy {
                        if $0.langFrom != lang {
                            $0.langFrom = lang
                            $0.records = [:]
                        }
                }
                
                case Wish.reverseLanguages:
                    newState = state.copy {
                        let cached = $0.langTo
                        $0.langTo = $0.langFrom
                        $0.langFrom = cached
                        $0.records = [:]
                }
                
                case .removeAll:
                    newState = state.copy {
                        $0.records = [:]
                    }
                
                case .populate(let records):
                    newState = state.copy {
                        $0.records = records
                    }
            }
            
            return newState
        }
    }
    
    class Configurator {
        class func inject(viewController: DictionaryViewProtocol) {
            let presenter = DictionaryPresenter()
            let interactor = DictionaryInteractor()
            let router = DictionaryRouter()
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                router.rootRouter = appDelegate.rootRouter
            }
            viewController.interactor = interactor
            viewController.router = router
            interactor.presenter = presenter
            presenter.view = viewController
            interactor.repo = Repository()
        }
    }
}
