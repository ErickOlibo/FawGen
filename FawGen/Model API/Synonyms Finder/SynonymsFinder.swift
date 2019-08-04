//
//  SynonymsFinder.swift
//  FawGenModelAPI
//
//  Created by Erick Olibo on 04/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

class SynonymsFinder {
    
    // MARK: - Private Properties
    private weak var model: FawGenModel!
    private var wordsRank: [String : [String]]
    private var corpus: Set<String>
    
    init(_ model: FawGenModel) {
        self.model = model
        wordsRank = model.synonymsWordsRank
        corpus = model.synonymsCorpus
        print("[SynonymsFinder] Finder Corpus size: \(corpus.count)")
    }
    
    
}

// MARK - Public methods
extension SynonymsFinder {
    
    /// Returns a list of synonyms for a given word
    /// - Parameter word: a word for which synonyms are requested
    /// - Returns: an array of words or nil if none found
    public func getSynonyms(of word: String) -> [String]? {
        let lowerWord = word.lowercased()
        guard let synoRank = wordsRank[lowerWord]?.randomElement() else { return nil }
        let list = wordsRank.filter{ $0.value.contains(synoRank) }
        if list.count == 0 { return nil }
        let synonyms = list.reduce(into: []) { result, item in
            result.append(item.key)
        }
        return synonyms
    }
}
