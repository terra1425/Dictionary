//
//  BaseModule.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import Foundation

protocol BaseState: MutableCopyProtocol {}

protocol BaseWish {}

class BaseReducer<TState: BaseState, TAction: BaseWish> {
    open func reduce(state: TState, by action: TAction) -> TState? { return nil }
}

protocol BaseViewModel {}
