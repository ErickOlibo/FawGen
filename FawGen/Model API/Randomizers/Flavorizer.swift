//
//  Flavorizer.swift
//  FawGenModelAPI
//
//  Created by Erick Olibo on 04/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

class Flavorizer {
    
    // MARK: - Properties
    private enum form: String {
        case vcv = "VCV"
        case cv = "CV"
        case vc = "VC"
    }
    
    private let vows = ModelConstants.vows
    private let cons = ModelConstants.cons
    private let vowels = ModelConstants.vowels
    private let consonants = ModelConstants.consonants
    
    private var quality: QualityOptions = (nil, nil)
    private var list = Set<String>()
    private var uniqueMadeUpWords = Set<String>()
    private let maxResultsPerType = ModelConstants.maxResultsPerTypeOfAlgorithm * 2
    private let maxIterations = ModelConstants.maxIterations
    private let listMinCount = 20
    private let space = " "
    
    private var allWordBreaks = [WordBreak]()
    private var left = Set<WordBreak>()
    private var center = Set<WordBreak>()
    private var right = Set<WordBreak>()
    
    private var combinedVocabulary: Set<String>
    private weak var model: FawGenModel!
    private weak var grams: Grams!
    
    init(_ model: FawGenModel, grams: Grams) {
        combinedVocabulary = model.combinedVocabulary
        self.grams = grams
        print("[Flavorizer] Combined Vocab size: \(combinedVocabulary.count)")
    }
    
    
    
}

// MARK: - Public methods
extension Flavorizer {
    
    /// Generates all possible MadeUpWords using the Flavorizer Algorithm, and retuns a set of
    /// MadeUpwords
    /// - Parameters:
    ///     - list: list of keywords, synonyms and word2Vec similarities as a set of strings
    ///     - options: the quality of the returned MadeUpwords as Length, Type, Symbol
    public func generatesAllPossibilities(from list: Set<String>, with quality: QualityOptions) -> Set<MadeUpWord>? {
        if list.count < listMinCount { return nil }
        self.quality = quality
        self.list = list
        guard let allBreaks = breakDownsFromList() else { return nil }
        self.allWordBreaks = allBreaks
        (self.left, self.center, self.right) = separateWordBreaks()
        
        self.uniqueMadeUpWords = Set<String>()
        return allPossibilities()
    }
}



// MARK: - Private methods
extension Flavorizer {
    
    /// Goes through the list and creates MdeUpWords  using Flavorizer algorithm.
    /// The returned MadeUpWords comply to the quality options
    private func allPossibilities() -> Set<MadeUpWord>? {
        var results = Set<MadeUpWord>()
        var counter = 0
        while results.count < maxResultsPerType && counter < maxIterations {
            counter += 1
            guard let times = (2...5).randomElement() else { continue }
            guard let leftWordBreak = left.randomElement() else { continue }
            var title = leftWordBreak.gram
            var elements = [leftWordBreak.wordOrigin + space + leftWordBreak.gram]
            
            for idx in 1..<times {
                if idx == times - 1 {
                    // the right End
                    let lastChar = String(title.suffix(1))
                    let tmpRight = right.filter{ $0.firstChar == lastChar }.randomElement()
                    guard let rightWordBreak = tmpRight else { continue }
                    let rightGram = rightWordBreak.gram
                    let rest = rightGram.dropFirst()
                    title += rest
                    elements.append(rightWordBreak.wordOrigin + space + rightWordBreak.gram)
                } else {
                    // The Center part
                    let lastChar = String(title.suffix(1))
                    let tmpCenter = center.filter{ $0.firstChar == lastChar }.randomElement()
                    guard let centerWordBreak = tmpCenter else { continue }
                    let centerGram = centerWordBreak.gram
                    let rest = centerGram.dropFirst()
                    title += rest
                    elements.append(centerWordBreak.wordOrigin + space + centerWordBreak.gram)
                }
            }
            guard hasQualified(title.lowercased()) else { continue }
            let madeUpWord = MadeUpWord(title, elements, .flavor)
            guard madeUpWord.isOfRequestedQuality(quality) else { continue }
            uniqueMadeUpWords.insert(madeUpWord.title.lowercased())
            results.insert(madeUpWord)
        }
        return results.count == 0 ? nil : results
    }
    
    
    /// Returns an array of WordBreak from a list of words
    /// The list is coming from the user or selected randomly from the statements
    private func breakDownsFromList() -> [WordBreak]? {
        var collection = [WordBreak]()
        for word in list {
            guard let wordBreaks = flavoredBreakDownOf(word) else { continue }
            collection.append(contentsOf: wordBreaks)
        }
        return collection.count == 0 ? nil : collection
    }
    
    
    /// Returns an array of WordBreak from a single word
    /// - Parameter word: the word to create the left, center and right
    /// WordBreak from.
    private func flavoredBreakDownOf(_ word: String) -> [WordBreak]? {
        var results = [WordBreak]()
        guard let breaks = breakDown(of: word) else { return nil }
        
        guard breaks.count > 1 else { return nil }
        if breaks.count == 2 {
            results.append(WordBreak(word, gram: breaks[0], side: .left))
            results.append(WordBreak(word, gram: breaks[1], side: .right))
        } else {
            results.append(WordBreak(word, gram: breaks[0], side: .left))
            results.append(WordBreak(word, gram: breaks[breaks.count - 1], side: .right))
            let centers = breaks[1..<breaks.count - 1].map{ WordBreak(word, gram: $0, side: .center) }
            results.append(contentsOf: centers)
        }
        return results
    }
    
    
    /// Breaks down a word into defined Symbol forms such as VCV, CV, VC
    /// - Parameter word: a word of length larger than 2 letters
    /// - Returns: a breaks in flavored syllabels
    private func breakDown(of word: String) -> [String]? {
        guard word.count > 2 else { return nil }
        guard CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: word)) else { return nil }
        var breaks = [String]()
        let firstChar = String(word.prefix(1))
        var cvRep = vowels.contains(firstChar) ? vows : cons
        var gram = firstChar
        
        var someVows = String()
        for (idx, char) in word.enumerated() {
            if idx == 0 { continue }
            if consonants.contains(String(char)) {
                if cvRep == form.cv.rawValue || cvRep == form.vcv.rawValue {
                    breaks.append(gram)
                    gram = someVows
                    cvRep = form.vc.rawValue
                    someVows = String()
                }
            } else { someVows += String(char) }
            
            let cv = vowels.contains(String(char)) ? vows : cons
            gram += String(char)
            
            if cvRep.suffix(1) != cv { cvRep += cv }
            if idx == word.count - 1 { breaks.append(gram) }
        }
        return breaks
    }
    
    
    /// Returns the left, center and right set of WordBreak from the list enter by
    /// the user.
    private func separateWordBreaks() -> (left: Set<WordBreak>, center: Set<WordBreak>, right: Set<WordBreak>) {
        let left = Set(allWordBreaks.filter { $0.boundSide == .left })
        let center = Set(allWordBreaks.filter { $0.boundSide == .center })
        let right = Set(allWordBreaks.filter { $0.boundSide == .right })
        return (left, center, right)
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

