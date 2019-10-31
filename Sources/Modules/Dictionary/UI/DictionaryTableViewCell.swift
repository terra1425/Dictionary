//
//  DictionaryTableViewCell.swift
//  Translator
//
//  Created by Alexander Khvan on 30.10.2019.
//  Copyright © 2019 terra1425. All rights reserved.
//

import UIKit

class DictionaryTableViewCell: UITableViewCell {
    @IBOutlet weak var idiomText: UILabel!
    
    @IBOutlet weak var translationText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
