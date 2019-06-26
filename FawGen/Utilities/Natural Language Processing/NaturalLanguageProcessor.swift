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
    
    /// Tokenizes a string by words and returns a set of said words.
    /// - Warning: The returned Set does not take into considaration
    /// any type of representation of the word as it is set to lowercase to
    /// avoid duplicates
    /// - Returns: a set of unique words contained in that keywords list
    /// - Parameter keywords: a string and list of words entered by the user
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
    
    
    /// Tokenizes a string by words and returns a array of said words.
    /// - Warning: The returned Array does distinguished between
    /// uppercased, lowercase, capitalized, and everything in between.
    /// - Returns: an array of words in the order found in the string
    /// - Parameter keywords: a string and list of words entered by the user
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
