//
//  KeywordsHistoryCell.swift
//  FawGen
//
//  Created by Erick Olibo on 01/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class KeywordsHistoryCell: UITableViewCell {
    
    
    // MARK: - Outlets
    @IBOutlet weak var keywordsLabel: UILabel!
    @IBOutlet weak var keywordsDateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
