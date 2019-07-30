//
//  FawGenWord.swift
//  FawGen
//
//  Created by Erick Olibo on 30/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

public struct FawGenWord: Codable {
    
    private(set) var title: String
    private(set) var elements: [String]
    private(set) var algo: MadeUpAlgo
    private(set) var quality: MadeUpQuality
    private(set) var created: Date
    
    init(_ madeUpWord: MadeUpWord) {
        self.created = Date()
        self.title = madeUpWord.title
        self.elements = madeUpWord.elements
        self.algo = madeUpWord.madeUpAlgo
        self.quality = madeUpWord.madeUpQuality
        
    }
    
    
}
