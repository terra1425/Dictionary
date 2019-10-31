//
//  TranslatorViewController.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import UIKit

class TranslatorViewController: BaseUIViewController {
    var interactor: TranslatorInteractorProtocol?
    var router: TranslatorRouterProtocol?

    private var watchdog = StringChangeWatchdog()
    
    @IBOutlet weak var bkgView: UIView!
    
    @IBOutlet weak var sourceText: UITextView!
    
    @IBOutlet weak var translationText: UITextView!
    
    @IBOutlet weak var langSelector: LanguageSelectorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Translator.Configurator.inject(viewController: self)
        setupLanguageSelector()
        setupTextView()
        setupWatchdog()
        setupNavBar()
        setupBkgView()
        setSyncLanguages() { [weak self] fromLang, toLang in
            if let lang = fromLang, let _ = Idiom.Language.from(string: lang) {
                self?.interactor?.changeSourceLanguage(to: lang)
            }
            if let lang = toLang, let _ = Idiom.Language.from(string: lang) {
                self?.interactor?.changeDestinationLanguage(to: lang)
            }
        }
        interactor?.update()
        textViewDidEndEditing(sourceText)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sourceText.text = ""
        translationText.text = ""
        textViewDidEndEditing(sourceText)
    }
    
    // MARK:  Helpers
    
    private func setupLanguageSelector() {
        sourceLangChangeDelegate.changeLanguageHandler = { [weak self] langFullDescription in
            self?.interactor?.changeSourceLanguage(to: langFullDescription)
            self?.syncLanguages(fromLang: langFullDescription, toString: nil)
        }
        langSelector.setSelectSource(delegate: sourceLangChangeDelegate)

        destinationLangChangeDelegate.changeLanguageHandler = { [weak self] langFullDescription in
            self?.interactor?.changeDestinationLanguage(to: langFullDescription)
            self?.syncLanguages(fromLang: nil, toString: langFullDescription)
        }
        langSelector.setSelectDestination(delegate: destinationLangChangeDelegate)

        langSelector.onReverseHandler = { [weak self] fromLang, toLang in
            self?.interactor?.reverseLanguages()
            self?.syncLanguages(fromLang: fromLang, toString: toLang)
        }
    }

    private func setupWatchdog() {
        watchdog.timeoutHandler = { [weak self] text in
            self?.interactor?.translate(text: text.lowercased())
        }
    }
    
    private func setupTextView() {
        sourceText.delegate = self
        sourceText.textColor = UIColor.lightGray
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        sourceText.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        translationText.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    private func setupBkgView() {
        bkgView.layer.cornerRadius = 8
    }
    
    @objc private func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        sourceText.resignFirstResponder()
    }
}

// MARK: - TranslatorViewProtocol, TranslatorExternalProtocol

extension TranslatorViewController: TranslatorViewProtocol, TranslatorExternalProtocol {
    func render(model: Translator.ViewModel) {
        langSelector.sourceText = model.langFrom
        langSelector.destinationText = model.langTo
        translationText.text = model.translation
        sourceText.text = model.text
    }

    func setExternal(text: String?) {
        if let text = text {
            textViewDidBeginEditing(sourceText)
            sourceText.text = text
            interactor?.translate(text: text)
        }
    }
}

// MARK: - UITextViewDelegate

extension TranslatorViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        watchdog.change(string: textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter text"
            textView.textColor = UIColor.lightGray
        }
    }
}
