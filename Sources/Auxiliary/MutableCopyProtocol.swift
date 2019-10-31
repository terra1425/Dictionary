//
//  MutableCopyProtocol.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

protocol MutableCopyProtocol {
    func copy<T: MutableCopyProtocol>(_ change: (inout T) -> Void) -> T
}

extension MutableCopyProtocol {
    func copy<T: MutableCopyProtocol>(_ change: (inout T) -> Void) -> T {
        var a: T = self as! T
        change(&a)
        return a
    }
}
