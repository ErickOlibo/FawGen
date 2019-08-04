//
//  NLProcessor.swift
//  FawGenModelAPI
//
//  Created by Erick Olibo on 04/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation
import NaturalLanguage

class NLProcessor {
    
    
    /// Tokenizes a string by words and returns a set of said words.
    /// - Warning: The returned Set does not take into considaration
    /// any type of representation of the word as it is set to lowercase to
    /// avoid duplicates
    /// - Returns: a set of unique words contained in that keywords list
    /// - Parameter keywords: a string and list of words
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
    
    
}


extension String {
    /// - Warning: This var doesnt mean anything when it comes to a single word.
    /// DO NOT USE IT IN PRODUCTION and DISTRIBUTION
    /// - Note: It is in place just as an false indicator. DO NOT USE IT IN PRODUCTION
    public var isEnglish: Bool {
        let dominantLang = NLLanguageRecognizer.dominantLanguage(for: self.lowercased())
        return dominantLang != nil && dominantLang == NLLanguage.english
    }
    
    public var containsNoneAlphabeticCharacters: Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
        let str = self.lowercased()
        return str.rangeOfCharacter(from: characterset.inverted) != nil
    }
}
