//
//  BaseUIViewController.swift
//  Translator
//
//  Created by Alexander Khvan on 30.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation
import UIKit

class BaseUIViewController: UIViewController {
    let kLanguageSyncNotification = "SourceLanguageSyncNotification"
    
    var sourceLangChangeDelegate: ContextMenuDelegate = ContextMenuDelegate()
    
    var destinationLangChangeDelegate: ContextMenuDelegate = ContextMenuDelegate()

    private var syncHandler:((String?, String?) -> Void)?
    
    private var isSyncing = false
    
    class ContextMenuDelegate: NSObject, UIContextMenuInteractionDelegate {
        var changeLanguageHandler: ((String)->Void)?
        
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [weak self] suggestedActions in
                guard let `self` = self else { fatalError() }
                return self.makeContextMenu()
            })
        }
        
        private func makeContextMenu() -> UIMenu {
            var items = [UIAction]()
            Idiom.Language.allCases.forEach { lang in
                let item = UIAction(title: lang.fullDescription()) { [weak self] action in
                    self?.changeLanguageHandler?(action.title)
                }
                items.append(item)
            }
            // Create and return a UIMenu with the share action
            return UIMenu(title: "Language Menu", children: items)
        }
    }
    

    
    func setupNavBar() {
        navigationController?.navigationBar.standardAppearance.shadowColor = nil
        navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor(red: 247/255, green: 235/255, blue: 131/255, alpha: 1.0)
    }
    
    func setSyncLanguages(handler: @escaping (String?, String?) -> Void) {
        syncHandler = handler
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onExternalLanguageChange),
                                               name: Notification.Name(rawValue: kLanguageSyncNotification),
                                               object: nil)
        
    }

    func syncLanguages(fromLang: String?, toString: String?) {
        isSyncing = true
        let data: [String: String?] = ["from": fromLang, "to": toString]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLanguageSyncNotification), object: nil, userInfo: data)
        isSyncing = false
    }
    
    @objc func onExternalLanguageChange(notification: NSNotification) {
        if !isSyncing,  let data = notification.userInfo as NSDictionary? {
            syncHandler?(data["from"] as? String, data["to"] as? String)
        }
    }
}
