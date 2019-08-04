//
//  Swapper.swift
//  FawGenModelAPI
//
//  Created by Erick Olibo on 04/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


class Swapper {
    
    // MARK: - Properties
    private var quality: QualityOptions = (nil, nil)
    private var list = Set<String>()
    private var uniqueMadeUpWords = Set<String>()
    private let maxMadeUpWordsByInstance = 1
    private let maxResultsPerType = ModelConstants.maxResultsPerTypeOfAlgorithm
    
    private var combinedVocabulary: Set<String>
    private weak var model: FawGenModel!
    private weak var grams: Grams!
    
    init(_ model: FawGenModel, grams: Grams) {
        combinedVocabulary = model.combinedVocabulary
        self.grams = grams
        print("[Swapper] Combined Vocab size: \(combinedVocabulary.count)")
    }
    
    
}

// MARK: - Public methods
extension Swapper {
    /// Generates all possible MadeUpWords using the Swapper Algorithm. It goes through the list
    /// and swaps using the 4 current algorithms and returns a filter list with a max results per type of 10
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
extension Swapper {
    
    /// Goes through each type of swap and generates every possible MadeUpWords.
    /// It is then filter to comply to maxResultsPerType
    private func allPossibilities() -> Set<MadeUpWord>? {
        var results = Set<MadeUpWord>()
        for word in list {
            guard quality.length == nil ? word.isOfCorrectInAppLength : word.isOfCorrectLength else { continue }
            if let firstLetter = allFirstLetter(for: word) { results.formUnion(firstLetter) }
            if let startBlendConsonant = allStartBlendConsonant(for: word) { results.formUnion(startBlendConsonant) }
            if let endBlendConsonant = allEndBlendConsonant(for: word) { results.formUnion(endBlendConsonant) }
            if let vowelsBlen = allVowelsBlend(for: word) { results.formUnion(vowelsBlen) }
        }
        
        let first = results.filter { $0.madeUpAlgo == .simpleSwap }.shuffled().prefix(maxResultsPerType)
        let startBlend = results.filter { $0.madeUpAlgo == .startBlendSwap }.shuffled().prefix(maxResultsPerType)
        let endBlend = results.filter { $0.madeUpAlgo == .endBlendSwap }.shuffled().prefix(maxResultsPerType)
        let vowelBlend = results.filter { $0.madeUpAlgo == .vowelsBlendSwap }.shuffled().prefix(maxResultsPerType)
        var randomTenResults = Set(first)
        randomTenResults.formUnion(startBlend)
        randomTenResults.formUnion(endBlend)
        randomTenResults.formUnion(vowelBlend)
        return randomTenResults.count == 0 ? nil : randomTenResults
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
    
    
    /// Returns all possible MadeUpwords generated through the firstLetter algorithm
    /// - Parameter word: a string representing a keyword, a synonym or similarity
    private func allFirstLetter(for word: String) -> Set<MadeUpWord>? {
        var results = Set<MadeUpWord>()
        let firstLetter = String(word.prefix(1))
        let restWord = String(word.suffix(word.count - 1))
        var letters = isVowel(firstLetter) ? ModelConstants.vowels : ModelConstants.consonants
        letters.remove(firstLetter)
        let shuffledLetters = letters.shuffled()
        for aLetter in shuffledLetters {
            if results.count == maxMadeUpWordsByInstance { return results }
            let title = aLetter + restWord
            guard hasQualified(title) else { continue }
            let elements = [word, firstLetter, aLetter]
            let madeUpWord = MadeUpWord(title, elements, .simpleSwap)
            guard madeUpWord.isOfRequestedQuality(quality) else { continue }
            uniqueMadeUpWords.insert(title)
            results.insert(madeUpWord)
        }
        return results.count == 0 ? nil : results
    }
    
    
    /// Returns all possible MadeUpwords generated through the StartBlendConsonant algorithm
    /// - Parameter word: a string representing a keyword, a synonym or similarity
    private func allStartBlendConsonant(for word: String) -> Set<MadeUpWord>? {
        var results = Set<MadeUpWord>()
        let startBlend = String(word.prefix(2))
        let endOfWord = String(word.suffix(word.count - 2))
        guard ModelConstants.consonantBlendStart.contains(startBlend) else { return nil }
        var blends = ModelConstants.consonantBlendStart
        
        blends.remove(startBlend)
        let shuffledBlends = blends.shuffled()
        for aBlend in shuffledBlends {
            if results.count == maxMadeUpWordsByInstance { return results }
            let title = aBlend + endOfWord
            guard hasQualified(title) else { continue }
            let elements = [word, startBlend, aBlend]
            let madeUpWord = MadeUpWord(title, elements, .startBlendSwap)
            guard madeUpWord.isOfRequestedQuality(quality) else { continue }
            uniqueMadeUpWords.insert(title)
            results.insert(madeUpWord)
        }
        return results.count == 0 ? nil : results
    }
    
    /// Returns all possible MadeUpwords generated through the EndBlendConsonant algorithm
    /// - Parameter word: a string representing a keyword, a synonym or similarity
    private func allEndBlendConsonant(for word: String) -> Set<MadeUpWord>? {
        var results = Set<MadeUpWord>()
        let endBlend = String(word.suffix(2))
        let startOfWord = String(word.prefix(word.count - 2))
        guard ModelConstants.consonantBlendEnd.contains(endBlend) else { return nil }
        var blends = ModelConstants.consonantBlendEnd
        
        blends.remove(endBlend)
        let shuffledBlends = blends.shuffled()
        for aBlend in shuffledBlends {
            if results.count == maxMadeUpWordsByInstance { return results }
            let title = startOfWord + aBlend
            guard hasQualified(title) else { continue }
            let elements = [word, endBlend, aBlend]
            let madeUpWord = MadeUpWord(title, elements, .endBlendSwap)
            guard madeUpWord.isOfRequestedQuality(quality) else { continue }
            uniqueMadeUpWords.insert(title)
            results.insert(madeUpWord)
        }
        return results.count == 0 ? nil : results
    }
    
    /// Returns all possible MadeUpwords generated through the VowelsBlend algorithm
    /// - Parameter word: a string representing a keyword, a synonym or similarity
    private func allVowelsBlend(for word: String) -> Set<MadeUpWord>? {
        var results = Set<MadeUpWord>()
        var title = word
        let tmpBlends = ModelConstants.vowelBlend.shuffled()
        var blendRanges = [Range<String.Index>]()
        var inWordBlend = String()
        for blend in tmpBlends {
            guard word.contains(blend) else { continue }
            inWordBlend = blend
            blendRanges = word.rangesAPI(of: blend)
        }
        guard inWordBlend.count != 0 else { return nil }
        var blends = Set(tmpBlends)
        
        blends.remove(inWordBlend)
        let shuffledBlends = blends.shuffled()
        for aBlend in shuffledBlends {
            if results.count == maxMadeUpWordsByInstance { return results }
            let idx = (0..<blendRanges.count).randomElement()!
            let range = blendRanges[idx]
            title.replaceSubrange(range, with: aBlend)
            guard hasQualified(title) else { continue }
            let elements = [word, inWordBlend, aBlend]
            let madeUpWord = MadeUpWord(title, elements, .vowelsBlendSwap)
            guard madeUpWord.isOfRequestedQuality(quality) else { continue }
            uniqueMadeUpWords.insert(title)
            results.insert(madeUpWord)
        }
        return results.count == 0 ? nil : results
    }
    
}
