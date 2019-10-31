//
//  YandexTranslator.swift
//  YandexTranslator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

class YandexTranslator: TranslatorProtocol {
    func searchTranslationFor(idiom: Idiom, to lang: Idiom.Language, handler: @escaping ([Idiom]) -> Void) {
        let downloader = Downloader()
        let direction = idiom.lang.direction(to: lang)
        downloader.requestTranslationFor(text: idiom.text, lang: direction, handler: { translations, _ in
            handler(translations.map { Idiom(text: $0, lang: lang) }) // TODO: parse direction given in the reply
        }, errHandler: { err in
            print("Error: \(err)")
            handler([])
        })
    }
    
    class Downloader {
        private let url = "https://translate.yandex.net/api/v1.5/tr.json/translate"
        
        private let apiKey = "trnsl.1.1.20191029T091852Z.726f9bf44a94a758.3466a089a624ec85a41740578597b54da3163f29"
        
        private let timeout = 10.0
        
        private let maxParamsLength = 10000
        
        func requestTranslationFor(text: String, lang: String, handler: @escaping ([String] /* arr of translations */, String /* lang */ ) -> Void, errHandler: @escaping (String) -> Void) {
            let params = "key=\(apiKey)&text=\(text)&lang=\(lang)"
            guard
                params.count < maxParamsLength
            else {
                errHandler("The text is too long")
                return
            }
            
            let headers = ["Content-Type": "application/x-www-form-urlencoded"]
            let postData = NSMutableData(data: params.data(using: String.Encoding.utf8)!)
            let request = NSMutableURLRequest(url: URL(string: url)!,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: timeout)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, _, error) -> Void in
                if error != nil {
                    errHandler(error!.localizedDescription)
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        if let values = json as? [String: Any],
                            let translatedText = values["text"] as? [String],
                            let translatedLang = values["lang"] as? String,
                            let code = values["code"] as? Int {
                            print("Received code: \(code), translations: \(translatedText), language: \(translatedLang)")
                            handler(translatedText, translatedLang)
                            return
                        }
                        errHandler("Unexpected server reply")
                    } catch {
                        errHandler(error.localizedDescription)
                    }
                }
            })
            
            dataTask.resume()
        }
    }
}
