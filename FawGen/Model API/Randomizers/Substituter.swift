//
//  Substituter.swift
//  FawGenModelAPI
//
//  Created by Erick Olibo on 04/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

class Substituter {
    
    // MARK: - Properties
    private var quality: QualityOptions = (nil, nil)
    private var list = Set<String>()
    private var uniqueMadeUpWords = Set<String>()
    private let maxResultsPerType = ModelConstants.maxResultsPerTypeOfAlgorithm * 2
    
    private var combinedVocabulary: Set<String>
    private weak var model: FawGenModel!
    private weak var grams: Grams!
    
    init(_ model: FawGenModel, grams: Grams) {
        combinedVocabulary = model.combinedVocabulary
        self.grams = grams
        print("[Substituter] Combined Vocab size: \(combinedVocabulary.count)")
    }
    
}


// MARK: - Public methods
extension Substituter {
    
    /// Generates all possible MadeUpWords using the Substituter Algorithm. It goes through the list and
    /// substitute part of a word with another one
    /// - Parameters:
    ///     - list: list of keywords, synonyms and word2Vec similarities as a set of strings
    ///     - options: the quality of the returned MadeUpwords as Length, Type, Symbol
    public func generatesAllPossibilities(from list: Set<String>, with quality: QualityOptions) -> Set<MadeUpWord>? {
        self.quality = quality
        self.list = list
        self.uniqueMadeUpWords = Set<String>()
        return allPossibilities()
    }
    
}



// MARK: - Private methods
extension Substituter {
    
    /// Goes through each words of the list and created all possible subsitutions.
    /// It them complies to the Quality Options.
    /// - Note: The maxResultsPerType is set to 2 times the default one.
    private func allPossibilities() -> Set<MadeUpWord>? {
        var results = Set<MadeUpWord>()
        for leftWord in list {
            for aGram in 2...4 {
                if leftWord.count < aGram + 2  { continue }
                let lastChars = String(leftWord.suffix(aGram))
                
                let subCollection = list.filter{ leftWord != String($0.prefix(leftWord.count)) &&
                    lastChars == String($0.prefix(leftWord.count).suffix(aGram))}
                guard subCollection.count != 0 else { continue }
                
                for rightWord in subCollection {
                    let newWord = rightWord.replacingOccurrences(of: String(rightWord.prefix(leftWord.count)), with: leftWord)
                    if newWord == leftWord || newWord == rightWord { continue }
                    guard hasQualified(newWord) else { continue }
                    let elements = [leftWord, lastChars, rightWord, String(aGram)]
                    let madeUpWord = MadeUpWord(newWord, elements, .substitute)
                    guard madeUpWord.isOfRequestedQuality(quality) else { continue }
                    uniqueMadeUpWords.insert(madeUpWord.title)
                    results.insert(madeUpWord)
                }
            }
        }
        let maxResults = Set(results.shuffled().prefix(maxResultsPerType))
        return maxResults.count == 0 ? nil : maxResults
    }
    
    /// Returns a true if the madeUpWord as passed the qualifying test. Length quality, a uniqueness,
    /// a biGram and triGram, and a corpus tests.
    /// - Parameter word: the newWord to be tester
    private func hasQualified(_ word: String) -> Bool {
        guard word.isOfRequestedLengthQuality(quality.length) else { return false }
        guard !uniqueMadeUpWords.contains(word) else { return false }
        guard grams.hasPassedGramsChecker(word) else { return false }
        guard !combinedVocabulary.contains(word) else { return false }
        return true
    }
    
    
}
