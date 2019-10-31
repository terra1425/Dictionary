//
//  StringChangeWatchdog.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

class StringChangeWatchdog {
    private var string: String = ""
    
    private var workItem: DispatchWorkItem?
    
    var timeoutHandler: ((String) -> Void)?
    
    private let timeout: Double = 1.0
    
    func change(string: String) {
        self.string = string
        workItem?.cancel()
        workItem = DispatchWorkItem { [weak self] in
            guard let `self` = self else { return }
            self.timeoutHandler?(self.string)
            self.workItem = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: workItem!)
    }
}
