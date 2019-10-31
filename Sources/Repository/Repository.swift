//
//  Repository.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Repository: RepositoryProtocol {
    
    private let translator: TranslatorProtocol = YandexTranslator()
    
    func getAllIdiomsFor(language: Idiom.Language) -> [Idiom] {
        return fetchAllIdiomsFor(lang: language)
    }
    
    func searchTranslationFor(idiom: Idiom, to lang: Idiom.Language, handler: @escaping ([Idiom]) -> Void) {
        let cached = fetchTranslationsFor(idiom: idiom)
        if cached.isEmpty {
            translator.searchTranslationFor(idiom: idiom, to: lang) { [weak self] translations in
                if !translations.isEmpty {
                    DispatchQueue.main.async {
                        if let first = translations.first, first.text.lowercased() != idiom.text.lowercased() {
                            self?.addIdiom(idiom, with: translations)
                            handler(translations)
                        }
                    }
                }
            }
        }
        else {
            handler(cached)
        }
    }
    
    func removeAllIdiomsFor(language: Idiom.Language) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: idiomsEntityName)
            fetchRequest.predicate = NSPredicate(format: "language == %@", language.description())
            
            do {
                let objects = try (managedContext.fetch(fetchRequest) as! [CoreIdiom])
                for object in objects {
                    managedContext.delete(object)
                }
                
                appDelegate.saveContext()
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
}

extension Repository {
    
    private var idiomsEntityName: String {
        return "Idioms"
    }
    
    func fetchAllIdiomsFor(lang: Idiom.Language) -> [Idiom] {
        var result = [Idiom]()

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: idiomsEntityName)
            fetchRequest.predicate = NSPredicate(format: "language == %@", lang.description())
            
            do {
                result =  try (managedContext.fetch(fetchRequest) as! [CoreIdiom]).compactMap { Idiom.from($0) }
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
        return result
    }

    func fetchTranslationsFor(idiom: Idiom) -> [Idiom] {
        var result = [Idiom]()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: idiomsEntityName)
            fetchRequest.predicate = NSPredicate(format: "text == %@ AND language == %@", idiom.text, idiom.lang.description())
            
            do {
                let data = try (managedContext.fetch(fetchRequest) as! [CoreIdiom])
                if let record = data.first {
                    if let coreTranslations = record.translation as? Set<CoreTranslation> {
                        result = coreTranslations.compactMap { Idiom.from($0) }
                    }
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
        return result
    }
    
    func addIdiom(_ idiom: Idiom, with translations: [Idiom]) {
        if fetchTranslationsFor(idiom: idiom).isEmpty {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let coreIdiom = CoreIdiom(context: managedContext)
            coreIdiom.text = idiom.text
            coreIdiom.language = idiom.lang.description()
            let coreTranslations = NSMutableSet()
            translations.forEach {
                let coreTranslation = CoreTranslation(context: managedContext)
                coreTranslation.text = $0.text
                coreTranslation.language = $0.lang.description()
                coreTranslations.add(coreTranslation)
            }
            coreIdiom.translation = coreTranslations
            
            appDelegate.saveContext()
        }
    }
}
