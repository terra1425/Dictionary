//
//  TranslatorConfigurator.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

class Translator {
    static let defaultState = State(idiom: Idiom(text: "", lang: Idiom.Language.en), langTo: Idiom.Language.ru, translations: nil)
    
    enum Wish: BaseWish {
        case changeSourceLanguageTo(Idiom.Language)
        case changeDestinationLanguageTo(Idiom.Language)
        case reverseLanguages
        case changeText(String)
        case addTranslation(Idiom)
    }
    
    struct ViewModel: MutableCopyProtocol {
        var langFrom: String
        var langTo: String
        var text: String
        var translation: String?
    }
    
    struct State: BaseState {
        var idiom: Idiom
        var langTo: Idiom.Language
        var translations: [Idiom]?
    }
    
    class Reducer: BaseReducer<State, Wish> {
        override func reduce(state: State, by action: Wish) -> State? {
            var newState: State?
            switch action {
                case Wish.changeDestinationLanguageTo(let lang):
                    newState = state.copy {
                        $0.langTo = lang
                        $0.translations = nil
                    }
                    
                case Wish.changeSourceLanguageTo(let lang):
                    newState = state.copy {
                        if $0.idiom.lang != lang {
                            $0.idiom = $0.idiom.copy {
                                $0.lang = lang
                                $0.text = ""
                            }
                            $0.translations = nil
                        }
                    }
                    
                case Wish.reverseLanguages:
                    newState = state.copy {
                        let cached = $0.langTo
                        $0.langTo = $0.idiom.lang
                        $0.idiom.lang = cached
                        $0.idiom.text = $0.translations?.first?.text ?? ""
                        $0.translations = nil
                    }
                    
                case .changeText(let text):
                    newState = state.copy {
                        if $0.idiom.text != text {
                            $0.idiom = $0.idiom.copy {
                                $0.text = text
                            }
                        }
                        $0.translations = nil
                    }
                    
                case .addTranslation(let idiom):
                    newState = state.copy {
                        if let translations = $0.translations {
                            var arr = translations
                            arr.append(idiom)
                            $0.translations = arr
                        }
                        else {
                            $0.translations = [idiom]
                        }
                    }
            }
            
            return newState
        }
    }
    
    class Configurator {
        class func inject(viewController: TranslatorViewProtocol) {
            let presenter = TranslatorPresenter()
            let interactor = TranslatorInteractor()
            viewController.interactor = interactor
            interactor.presenter = presenter
            presenter.view = viewController
        }
    }
}
