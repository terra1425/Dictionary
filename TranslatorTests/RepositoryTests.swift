//
//  RepositoryTests.swift
//  TranslatorTests
//
//  Created by Alexander Khvan on 30.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import XCTest
@testable import Translator

class RepositoryTests: XCTestCase {

    let futureTranslation = XCTestExpectation(description: "Translation")
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRepo() {
        let repo = Repository()
        repo.removeAllIdiomsFor(language: .en)
        
        let idiom = Idiom(text: "table", lang: .en)
        repo.searchTranslationFor(idiom: idiom, to: .ru) { [weak self] in
            print($0)
            self?.futureTranslation.fulfill()
        }
        
        wait(for: [futureTranslation], timeout: 10)
        
        let fetched = repo.fetchAllIdiomsFor(lang: .en)
        print("Fetched: \(fetched)")
        XCTAssert(fetched.count == 1)
        
        let translations = repo.fetchTranslationsFor(idiom: idiom)
        print("Translation: \(translations)")
        XCTAssert(translations.count == 1)
    }
}
