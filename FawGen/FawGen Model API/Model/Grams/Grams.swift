//
//  Grams.swift
//  ModelForFawGen
//
//  Created by Erick Olibo on 16/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


class Grams {
    
    // private typeAlias
    private typealias Start = Set<String>
    private typealias Chains = [String : [String]]
    private typealias Frequencies = [String : Int]
    
    // MARK: - Properties
    public var delegate: GramsDelegate?
    private(set) var biGramChains = [String : [String]]()
    private(set) var triGramChains = [String : [String]]()
    
    private(set) var biGramFrequencies = [String : Int]()
    private(set) var biGramStart = Set<String>()
    private(set) var triGramStart = Set<String>()
    
    private(set) var wantedLeftBiGrams = Set<String>()
    private(set) var wantedLeftTriGrams = Set<String>()
    private(set) var wantedLeftFourGrams = Set<String>()
    private(set) var wantedRightFourGrams = Set<String>()

    
    public func initialize() {
        var start = Date()
        self.biGramFrequencies = ModelConstants.biGramFrequencies
        self.biGramStart = ModelConstants.biGramsStart
        self.triGramStart = ModelConstants.triGramsStart
        self.wantedLeftBiGrams = ModelConstants.wantedLeftBiGramsSet
        self.wantedLeftTriGrams = ModelConstants.wantedLeftTriGramsSet
        self.wantedLeftFourGrams = ModelConstants.wantedLeftFourGramsSet
        self.wantedRightFourGrams = ModelConstants.wantedRightFourGramsSet
        printModelAPI("GRAM Loading [1] - \(start.toNowProcessDuration)")
        delegate?.gramsLoading(10)
        
        start = Date()
        self.biGramChains = biGramsStartChains()
        printModelAPI("GRAM Loading [2] - \(start.toNowProcessDuration)")
        delegate?.gramsLoading(49)
        
        start = Date()
        self.triGramChains = triGramsStartChains()
        printModelAPI("GRAM Loading [3] - \(start.toNowProcessDuration)")
        delegate?.gramsLoading(100)
    }
  
}

// MARK: - Public methods
extension Grams {
    
    public var randomBiGramStart: String {
        while true {
            guard let startGram = biGramStart.randomElement(), wantedLeftBiGrams.contains(startGram) else { continue }
            return startGram
        }
    }
    
    public func createBiGramsChainsAndStarts(from list: Set<String>) -> (chains: [String : [String]], starts: Set<String>)  {
        var starts = Set<String>()
        var chains = [String : [String]]()
        let n = 2
        for word in list {
            guard word.count > n else { continue }
            let stop = word.count - n
            for idx in 0..<stop {
                let idxGramStart = word.index(word.startIndex, offsetBy: idx)
                let idxGramEnd = word.index(word.startIndex, offsetBy: idx + n)
                let idxNextCharStart = word.index(word.startIndex, offsetBy: idx + n)
                let idxNextCharEnd = word.index(word.startIndex, offsetBy: idx + n + 1)
                let gram = word[idxGramStart..<idxGramEnd].lowercased()
                if idx == 0 { starts.insert(gram) }
                let nextChar = word[idxNextCharStart..<idxNextCharEnd].lowercased()
                if let aChain = chains[gram] {
                    let newChain = aChain + [nextChar]
                    chains[gram] = newChain
                } else { chains[gram] = [nextChar] }
            }
        }
        return (chains, starts)
    }
    
}


// MARK: - Private Methods
extension Grams {
    
    /// Checks a string of length at least 4 so see if, leftBiGram, leftTriGram,
    /// leftFourGram and rightFourGram are in the list of wanted
    /// Returns false if any of the test fails
    /// - Parameter word: a word as string of minimum character length 4
    public func hasPassedGramsChecker(_ word: String) -> Bool {
        guard word.count >= 4 else { return false }
        guard wantedLeftBiGrams.contains(String(word.prefix(2))) else { return false }
        guard wantedLeftTriGrams.contains(String(word.prefix(3))) else { return false }
        guard wantedLeftFourGrams.contains(String(word.prefix(4))) else { return false }
        guard wantedRightFourGrams.contains(String(word.suffix(4))) else { return false }
        return true
    }
    
    private func generateBiGrams(for word: String) -> [String] {
        var biGrams = [String]()
        for idx in 0..<word.count {
            let subWord = String(word.suffix(word.count - idx))
            guard subWord.count > 1 else { continue }
            biGrams.append(String(subWord.prefix(2)).lowercased())
        }
        return biGrams
    }
    
    
    
    private func biGramsStartChains() -> Chains {
        let rows = getBundleFileRowsAsSet(from: ModelConstants.markovBiGramChains)
        var chains = Chains()
        for row in rows {
            var comp = row.components(separatedBy: .whitespaces)
            let biGram = comp.removeFirst()
            guard biGram.count == 2 else { continue }
            chains[biGram] = comp
        }
        return chains
    }
    
    private func triGramsStartChains() -> Chains {
        let rows = getBundleFileRowsAsSet(from: ModelConstants.markovTriGramChains)
        var chains = Chains()
        for row in rows {
            var comp = row.components(separatedBy: .whitespaces)
            let triGram = comp.removeFirst()
            guard triGram.count == 3 else { continue }
            chains[triGram] = comp
        }
        return chains
    }
    
    

}
