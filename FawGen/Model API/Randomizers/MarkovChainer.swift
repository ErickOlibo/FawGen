//
//  MarkovChainer.swift
//  FawGenModelAPI
//
//  Created by Erick Olibo on 04/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

class MarkovChainer {
    
    // MARK: - Properties
    private var quality: QualityOptions = (nil, nil)
    private var list = Set<String>()
    private var biGramsChains = [String : [String]]() // from list
    private var biGramsStarts = Set<String>() // from list
    private var uniqueMadeUpWords = Set<String>()
    private let maxResultsPerType = ModelConstants.maxResultsPerTypeOfAlgorithm * 2
    private let maxIterations = ModelConstants.maxIterations
    private let listMinCount = 20
    
    private var combinedVocabulary: Set<String>
    private weak var model: FawGenModel!
    private weak var grams: Grams!
    
    init(_ model: FawGenModel, grams: Grams) {
        combinedVocabulary = model.combinedVocabulary
        self.grams = grams
        print("[MarkovChainer] Combined Vocab size: \(combinedVocabulary.count)")
    }
    
    
}


// MARK: - Public methods
extension MarkovChainer {
    
    /// Generates all possible MadeUpWords using the Swapper Algorithm. It goes through the list
    /// and swaps using the 4 current algorithms and returns a filter list with a max results per type of 10
    /// - Parameters:
    ///     - list: list of keywords, synonyms and word2Vec similarities as a set of strings
    ///     - options: the quality of the returned MadeUpwords as Length, Type, Symbol
    public func generatesAllPossibilities(from list: Set<String>, with quality: QualityOptions) -> Set<MadeUpWord>? {
        if list.count < listMinCount { return nil }
        self.quality = quality
        self.list = list
        self.uniqueMadeUpWords = Set<String>()
        (self.biGramsChains, self.biGramsStarts) = grams.createBiGramsChainsAndStarts(from: list)
        if biGramsChains.count == 0 { return nil } // number of words in list larger than 2 letters
        return allPossibilities()
    }
    
}


// MARK: - Private methods
extension MarkovChainer {
    
    /// Goes through the list and creates MdeUpWords  using Markov Chain algorithm.
    /// The returned MadeUpWords comply to the quality options
    private func allPossibilities() -> Set<MadeUpWord>?  {
        var results = Set<MadeUpWord>()
        var counter = 0
        while results.count < maxResultsPerType && counter < maxIterations {
            counter += 1
            let length = randomLength()
            var title = randomBiGramStart()
            var elements = [title]
            while title.count < length {
                guard counter < maxIterations else { break }
                let rightMostBiGram = String(title.suffix(2))
                if let nextChar = biGramsChains[rightMostBiGram]?.randomElement() {
                    title += nextChar
                    elements.append(nextChar)
                } else if let nextChar = grams.biGramChains[rightMostBiGram]?.randomElement() {
                    title += nextChar
                    elements.append(nextChar)
                } else {
                    guard let nextAlphaChar = ModelConstants.alphabet.randomElement() else { counter += 1; continue }
                    title += nextAlphaChar
                    elements.append(nextAlphaChar)
                }
            }
            guard hasQualified(title.lowercased()) else { continue }
            let madeUpWord = MadeUpWord(title, elements, .markovChain)
            guard madeUpWord.isOfRequestedQuality(quality) else { continue }
            uniqueMadeUpWords.insert(madeUpWord.title.lowercased())
            results.insert(madeUpWord)
        }
        return results.count == 0 ? nil : results
    }
    
    
    private func randomLength() -> Int {
        if let length = quality.length {
            return Int(length)
        } else {
            return ModelConstants.minMaxInAppWordLength.randomElement() ?? 8
        }
    }
    
    
    private func randomBiGramStart() -> String {
        return biGramsStarts.randomElement()!
    }
    
    /// Returns a true if the madeUpWord as passed the qualifying test. Length quality, a uniqueness,
    /// a biGram and triGram, a corpus tests.
    /// - Parameter madeUpword: a data type MadeUpWord to be tester
    private func hasQualified(_ word: String) -> Bool {
        guard word.isOfRequestedLengthQuality(quality.length) else { return false }
        guard !uniqueMadeUpWords.contains(word) else { return false }
        guard grams.hasPassedGramsChecker(word) else { return false }
        guard !combinedVocabulary.contains(word) else { return false }
        return true
    }
}
