//
//  NaturalLanguageProcessor.swift
//  FawGen
//
//  Created by Erick Olibo on 08/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation
import NaturalLanguage


class NaturalLanguageProcessor {
    
    // Properties
    
    
    // Methods
    
    // Get all the tokens (word split) from a mission statement, or keywords list
    func tokenizeByWords(_ keywords: String) -> Set<String>{
        let statement = keywords
        var listWords = Set<String>()
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = statement
        tokenizer.enumerateTokens(in: statement.startIndex..<statement.endIndex) { (tokenRange, _) -> Bool in
            let token = statement[tokenRange].lowercased()
            listWords.insert(token)
            return true
        }
        return listWords
    }
    
    
    func tokenize(_ keywords: String) -> [String] {
        var list = [String]()
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = keywords
        tokenizer.enumerateTokens(in: keywords.startIndex..<keywords.endIndex) { (tokenRange, _) -> Bool in
            let token = String(keywords[tokenRange])
            list.append(token)
            return true
        }
        return list
    }
}
