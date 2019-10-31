//
//  Idioma.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

struct Idiom: MutableCopyProtocol, Hashable {
    enum Language: String, CaseIterable {
        case ru, en, de
        func description() -> String {
            return rawValue.capitalized
        }
        func fullDescription() -> String {
            switch self {
                case .de: return "German"
                case .en: return "English"
                case .ru: return "Russian"
            }
        }
        func direction(to: Language) -> String {
            return ("\(self.rawValue)-\(to.rawValue)")
        }
        static func from(string: String) -> Language? {
            switch (string.lowercased()) {
                case "german", "de": return .de
                case "english", "en": return .en
                case "russian", "ru": return .ru
                default: return nil
            }
        }
    }
    
    var text: String
    var lang: Language
    
    // MARK: Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(lang.description())
    }
    
    // MARK: Convertation
    
    static func from(_ core: CoreIdiom) -> Idiom? {
        if let text = core.text, let langDescription = core.language, let lang = Language.from(string: langDescription) {
            return Idiom(text: text, lang: lang)
        }
        return nil
    }
    
    static func from(_ core: CoreTranslation) -> Idiom? {
        if let text = core.text, let langDescription = core.language, let lang = Language.from(string: langDescription) {
            return Idiom(text: text, lang: lang)
        }
        return nil
    }
}
