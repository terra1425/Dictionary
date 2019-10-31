//
//  LanguageSelectorView.swift
//  Translator
//
//  Created by Alexander Khvan on 29.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import UIKit

class LanguageSelectorView: UIView {
    typealias ActionHandler = (String, String)->Void
    
    var onReverseHandler: ActionHandler?
    
    var sourceText: String {
        get {
            sourceLanguageBtn.title(for: .normal) ?? ""
        }
        
        set {
            sourceLanguageBtn.setTitle(newValue, for: .normal)
        }
    }
    
    var destinationText: String {
        get {
            destinationLanguageBtn.title(for: .normal) ?? ""
        }
        
        set {
            destinationLanguageBtn.setTitle(newValue, for: .normal)
        }
    }
    
    func setSelectSource(delegate: UIContextMenuInteractionDelegate) {
        sourceLanguageBtn.addInteraction(UIContextMenuInteraction(delegate: delegate))
    }
    
    func setSelectDestination(delegate: UIContextMenuInteractionDelegate) {
        destinationLanguageBtn.addInteraction(UIContextMenuInteraction(delegate: delegate))
    }
            
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var sourceLanguageBtn: UIButton!
    
    @IBOutlet weak var destinationLanguageBtn: UIButton!
    
    @IBAction func onReverse(_ sender: Any) {
        onReverseHandler?(destinationText, sourceText)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        internalInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        internalInit()
    }

    private func internalInit() {
        Bundle.main.loadNibNamed("LanguageSelector", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}



