//
//  DictionaryViewController.swift
//  Translator
//
//  Created by Alexander Khvan on 30.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import UIKit

class DictionaryViewController: BaseUIViewController {
    var interactor: DictionaryInteractorProtocol?
    
    var router: DictionaryRouterProtocol?
    
    var delegate: TableDelegate?
    
    @IBOutlet weak var langSelector: LanguageSelectorView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onDeleteAllAction(_ sender: Any) {
        interactor?.deleteAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Dict.Configurator.inject(viewController: self)
        setupTable()
        setupSearchBar()
        setupNavBar()
        setupLanguageSelector()
        setSyncLanguages() { [weak self] fromLang, toLang in
            if let lang = fromLang, let _ = Idiom.Language.from(string: lang) {
                self?.interactor?.changeSourceLanguage(to: lang)
            }
            if let lang = toLang, let _ = Idiom.Language.from(string: lang) {
                self?.interactor?.changeDestinationLanguage(to: lang)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.text = ""
        delegate?.filterWith(predicate: "")
        interactor?.update()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    private func setupTable() {
        let tableDelegate = TableDelegate(with: tableView)
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDelegate
        delegate = tableDelegate
        tableView.keyboardDismissMode = .onDrag
        delegate?.selectionHandler = { [weak self] index, text in
            guard let `self` = self else { return }
            self.router?.rootRouter?.route(.translator(text: text))
        }
    }
    
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
}

// MARK: - DictionaryViewProtocol

extension DictionaryViewController: DictionaryViewProtocol {
    func render(model: Dict.ViewModel) {
        delegate?.initialData = model.items
        langSelector.sourceText = model.langFrom
        langSelector.destinationText = model.langTo
    }
}

// MARK: - Table Delegates implementation

extension DictionaryViewController {
    class TableDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
        typealias SelectionHandler = (Int, String) -> Void
        
        var selectionHandler: SelectionHandler?

        var initialData: [(text: String, translation: String)] = [] {
            didSet {
                data = initialData
                if !lastFilterPredicate.isEmpty {
                    filterWith(predicate: lastFilterPredicate)
                }
                table.reloadData()
            }
        }

        private var filteredData: [(text: String, translation: String)] = []
        
        private var data: [(text: String, translation: String)] = []
        
        private let kCellId = "DictionaryCell"
        
        private let table: UITableView
        
        private var lastFilterPredicate = ""
        
        init(with table: UITableView) {
            self.table = table
            super.init()
            registerCells(table: table)
        }
        
        func filterWith(predicate: String) {
            if predicate.isEmpty {
                data = initialData
                filteredData.removeAll()
                table.reloadData()
            }
            else {
                filteredData = initialData.filter { $0.text.contains(predicate) || $0.translation.contains(predicate)}
                data = filteredData
                table.reloadData()
            }
            lastFilterPredicate = predicate
        }
        
        // MARK: - UITableViewDataSource
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let index = indexPath.row
            if let cell = tableView.dequeueReusableCell(withIdentifier: kCellId, for: indexPath) as? DictionaryTableViewCell, index < data.count {
                cell.idiomText.text = data[index].text
                cell.translationText.text = data[index].translation
                return cell
            }
            return UITableViewCell()
        }

        // MARK: - UITableViewDelegate
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.row < data.count {
                selectionHandler?(indexPath.row, data[indexPath.row].text)
            }
        }
        
        // MARK: - Helpers
        
        private func registerCells(table: UITableView) {
            table.register(UINib(nibName: "DictionaryTableViewCell", bundle: nil), forCellReuseIdentifier: kCellId)
        }
    }
}

// MARK: - SearchBar delegate

extension DictionaryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.filterWith(predicate: searchText.lowercased())
    }
}
