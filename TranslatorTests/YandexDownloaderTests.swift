//
//  YandexDownloaderTests.swift
//  TranslatorTests
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import XCTest
@testable import Translator

class YandexDownloaderTests: XCTestCase {

    private let downloadExpectation = XCTestExpectation(description: "Download")
    private let translateExpectation = XCTestExpectation(description: "Translate")
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDownloaded() {
        let downloader = YandexTranslator.Downloader()
        let word = "house"
        downloader.requestTranslationFor(text: word,
                                         lang: "en-de",
                                         handler: { [weak self] translations, lang in
                                            print(translations)
                                            XCTAssert(translations.first! != word)
                                            self?.downloadExpectation.fulfill()
                                            
        },
                                         errHandler: { err in
                                            XCTFail()
                                            print(err)
        })
        
        wait(for: [downloadExpectation], timeout: 10)
    }
    
    func testTranslator() {
        let translator = YandexTranslator()
        let idiom = Idiom(text: "book", lang: Idiom.Language.en)
        translator.searchTranslationFor(idiom: idiom, to: Idiom.Language.de) { [weak self] result in
            XCTAssert(!result.isEmpty)
            print("Result: \(result)")
            self?.translateExpectation.fulfill()
        }
        wait(for: [translateExpectation], timeout: 10)
    }
}
