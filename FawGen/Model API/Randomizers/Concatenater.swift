//
//  Concatenater.swift
//  FawGenModelAPI
//
//  Created by Erick Olibo on 04/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


class Concatenater {
    
    // MARK: - Properties
    private var quality: QualityOptions = (nil, nil)
    private var list = Set<String>()
    private var listByLength = [Int : Set<String>]()
    private var uniqueMadeUpWords = Set<String>()
    private let maxResultsPerType = ModelConstants.maxResultsPerTypeOfAlgorithm * 2
    private let maxIterations = ModelConstants.maxIterations
    private let maxSubIterations = 20
    
    // returns a random length with a bias for length between 7 and 10
    private let weightedRandomLength = [6,6, 7,7,7,7, 8,8,8,8, 9,9,9,9, 10,10,10,10, 11,11, 12,12]
    private let maxWordsPerSplit = 4 // the number of madeUpword to generate by splits of length
    
    private var combinedVocabulary: Set<String>
    private weak var model: FawGenModel!
    private weak var grams: Grams!
    
    init(_ model: FawGenModel, grams: Grams) {
        combinedVocabulary = model.combinedVocabulary
        self.grams = grams
        print("[Concatenater] Combined Vocab size: \(combinedVocabulary.count)")
    }
    
}



// MARK: - Public methods
extension Concatenater {
    
    /// Generates all possible MadeUpWords using the Concatenater Algorithm. It goes through the list and
    /// concatenate words with eachother
    /// - Parameters:
    ///     - list: list of keywords, synonyms and word2Vec similarities as a set of strings
    ///     - options: the quality of the returned MadeUpwords as Length, Type, Symbol
    public func generatesAllPossibilities(from list: Set<String>, with quality: QualityOptions) -> Set<MadeUpWord>? {
        self.quality = quality
        self.list = list
        self.listByLength = organizeListByLength()
        self.uniqueMadeUpWords = Set<String>()
        return allPossibilities()
    }
    
}


// MARK: - Private Methods
extension Concatenater {
    
    /// Returns the list splits by length of the word
    private func organizeListByLength() -> [Int : Set<String>] {
        var collection = [Int : Set<String>]()
        for idx in 0...ModelConstants.maxLength {
            let sameLength = list.filter { $0.count == idx }
            collection[idx] = sameLength
        }
        let ordered = collection.sorted {$0.key < $1.key }
        let map = ordered.map { "\($0.key) - \($0.value.count)" }
        print("BY LENGTH: \(map)")
        return collection
    }
    
    
    
    /// Returns a set of madeUpwords depending on rather the quality.length is nil or not
    private func allPossibilities() -> Set<MadeUpWord>? {
        var results = Set<MadeUpWord>()
        
        if let requestedLength = quality.length {
            let splits = allPossibleSplits(for: Int(requestedLength))
            var tmpSplits = splits.shuffled()
            var firstCounter = 0
            while results.count < maxResultsPerType && firstCounter < maxIterations {
                firstCounter += 1
                if tmpSplits.count == 0 { tmpSplits = splits.shuffled() }
                let aSplit = tmpSplits.removeFirst()
                guard let madeUpWord = createMadeUpWord(from: aSplit) else { continue }
                uniqueMadeUpWords.insert(madeUpWord.title.lowercased())
                results.insert(madeUpWord)
            }
            
        } else {
            var secondCounter = 0
            while results.count < maxResultsPerType && secondCounter < maxIterations {
                secondCounter += 1
                
                let randomLength = weightedRandomLength.randomElement()!
                let splits = allPossibleSplits(for: Int(randomLength))
                var subResults = Set<MadeUpWord>()
                var tmpSplits = splits.shuffled()
                var subCounter = 0
                while results.count < maxResultsPerType && subResults.count < maxWordsPerSplit && subCounter <  maxSubIterations {
                    subCounter += 1
                    if tmpSplits.count == 0 { tmpSplits = splits.shuffled() }
                    let aSplit = tmpSplits.removeFirst()
                    guard let madeUpWord = createMadeUpWord(from: aSplit) else { continue }
                    uniqueMadeUpWords.insert(madeUpWord.title.lowercased())
                    subResults.insert(madeUpWord)
                    results.insert(madeUpWord)
                }
            }
        }
        return results.count == 0 ? nil : results
    }
    
    
    // Returns a MadeUpWord depending on the splits
    private func createMadeUpWord(from splits: [Int]) -> MadeUpWord? {
        let size = splits.count
        switch splits.count {
            
        case size where size == 2:
            guard let leftWord = listByLength[splits[0]]!.randomElement() else { return nil }
            guard let rightWord = listByLength[splits[1]]!.randomElement() else { return nil }
            guard leftWord != rightWord else { return nil }
            let title = leftWord.capitalized + rightWord.capitalized
            guard hasQualified(title.lowercased()) else { return nil }
            let elements = [leftWord, rightWord]
            let madeUpWord = MadeUpWord(title, elements, .concat)
            guard madeUpWord.isOfRequestedQuality(quality) else { return nil }
            return madeUpWord
            
        case size where size == 3:
            guard let leftWord = listByLength[splits[0]]!.randomElement() else { return nil }
            guard let middleWord = listByLength[splits[1]]!.randomElement() else { return nil }
            guard let rightWord = listByLength[splits[2]]!.randomElement() else { return nil }
            let title = leftWord.capitalized + middleWord.capitalized + rightWord.capitalized
            guard hasQualified(title.lowercased()) else { return nil }
            let elements = [leftWord, middleWord, rightWord]
            let madeUpWord = MadeUpWord(title, elements, .concat)
            guard madeUpWord.isOfRequestedQuality(quality) else { return nil }
            return madeUpWord
            
        default:
            return nil
        }
        
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
    
    
    
    /// Returns all possible ways to split a length
    /// - Parameter length: the integer length to determing all splits
    private func allPossibleSplits(for length: Int) -> [[Int]] {
        var allSplits = [[Int]]()
        // for 2 & 3 splits
        for i in ModelConstants.minCharacter...length - ModelConstants.minCharacter {
            allSplits.append([i, (length - i)])
            let rest = length - i
            if rest < 4 { continue }
            for k in ModelConstants.minCharacter...rest - ModelConstants.minCharacter {
                allSplits.append([i, k, (rest - k)])
            }
        }
        let workableSplits = allSplits.filter {
            let hasElements = $0.compactMap { listByLength[$0] }
            return hasElements.count == $0.count
        }
        
        return workableSplits
    }
    
    
    /// Splits a Integer randomly into smaller integers which each
    /// integer is bigger or equal to 2
    /// - Parameter length: the integer to split or break in smaller parts
    /// - Returns: and Array of integers which sum equal the length
    private func randomSplit(for length: Int) -> [Int] {
        var lengths = [Int]()
        var sum = lengths.reduce(0, +)
        while sum < length {
            
            let len = Int.random(in: ModelConstants.minCharacter...length - ModelConstants.minCharacter - sum)
            lengths.append(len)
            sum = lengths.reduce(0, +)
            let remainder = length - sum
            if remainder < 4 {
                lengths.append(remainder)
                sum = lengths.reduce(0, +)
            }
        }
        // plits can only be of 2 or 3 elements
        if lengths.count >= 4 { return randomSplit(for: length) }
        return lengths
    }
    
}

