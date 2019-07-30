//
//  WordBreak.swift
//  ModelForFawGen
//
//  Created by Erick Olibo on 23/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

struct WordBreak: CustomStringConvertible, Equatable, Hashable {
    
    private(set) var wordOrigin: String
    private(set) var boundSide: BoundSide
    private(set) var gram: String
    private(set) var firstChar: String
    private(set) var lastChar: String
    
    init(_ word: String, gram: String, side: BoundSide) {
        self.wordOrigin = word
        self.gram = gram
        self.boundSide = side
        self.firstChar = String(gram.prefix(1))
        self.lastChar = String(gram.suffix(1))
    }
    
    var description: String {
        return "\(wordOrigin) - \(gram) - \(boundSide.rawValue)"
    }
    
}

func ==(lhs: WordBreak, rhs: WordBreak) -> Bool {
    guard lhs.wordOrigin == rhs.wordOrigin else { return false }
    guard lhs.gram == rhs.gram else { return false }
    guard lhs.boundSide == rhs.boundSide else { return false }
    return true
}


