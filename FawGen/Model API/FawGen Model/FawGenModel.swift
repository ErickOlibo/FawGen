//
//  FawGenModel.swift
//  ModelForFawGen
//
//  Created by Erick Olibo on 04/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


// MARK: - Protocol
protocol FawGenModelDelegate {
    func FawGenModelLoadingCompletion(at percent: Int)
}


class FawGenModel {
    

    
    // private typeAlias
    private typealias Chains = [String : [String]]
    
    // MARK: - properties
    public var delegate: FawGenModelDelegate?
    //public var requestedQuality = RequestedQuality()
    
    //public var kNN = KNearestNeighbors()
    //public var toolBox: ToolBox!
    
    private let start = Date()
    
    // Load from TXT files
    private(set) var statements = Set<String>()
    private(set) var biGramsStart = Set<String>()
    private(set) var triGramsStart = Set<String>()
    private(set) var wantedLeftBiGramsSet = Set<String>()
    private(set) var wantedLeftTriGramsSet = Set<String>()
    private(set) var wantedLeftFourGramsSet = Set<String>()
    private(set) var wantedRightFourGramsSet = Set<String>()
    private(set) var finalCorpus = Set<String>()
    private(set) var synonymsCorpus = Set<String>()
    private(set) var synonymsWordsRank = [String : [String]]()
    private(set) var biGramFrequencies = [String : Int]()
    
    private(set) var combinedVocabulary = Set<String>()
    private(set) var vectorsNameByLength = [Set<String>]()
    private(set) var combinedNameByLength = [Set<String>]()
    
    private(set) var biGramChains = [String : [String]]()
    private(set) var triGramChains = [String : [String]]()
    
    //private(set) var grams = Grams()
    
    // WORD TO VEC MODEL Loading
    private let corpusSize : Double = 37738.0
    private(set) var nameToVector = [String : Vector]()
    private(set) var collectionOfVectors = [Vector]()
    private(set) var centroids = [Vector]()
    private(set) var classificationByCentroids = [[Vector]](){
        didSet {
            let number = classificationByCentroids.map{ $0.count }.reduce(0, +)
            let percent = Int((Double(number) / corpusSize) * 100)
            let thisPercent = 37 + (percent * 63) / 100
            delegate?.FawGenModelLoadingCompletion(at: thisPercent)
        }
    }
    
    
    public func initialize() {
        
        statements = loadListOfStatements()
        delegate?.FawGenModelLoadingCompletion(at: 4)
        
        biGramsStart = loadBiGramsStart()
        triGramsStart = loadTriGramStart()
        wantedLeftBiGramsSet = loadWantedLeftBiGrams()
        wantedLeftTriGramsSet = loadWantedLeftTriGrams()
        wantedLeftFourGramsSet = loadWantedLeftFourGrams()
        wantedRightFourGramsSet = loadWantedRightFourGrams()
        
        finalCorpus = loadFinalCorpus()
        delegate?.FawGenModelLoadingCompletion(at: 6)
        
        (synonymsWordsRank, synonymsCorpus) = loadSynonymsTable()
        delegate?.FawGenModelLoadingCompletion(at: 16)
        
        biGramFrequencies = loadBiGramFrequencyTable()
        combinedVocabulary = createCombinedVocabulary()
        delegate?.FawGenModelLoadingCompletion(at: 17)
        
        (vectorsNameByLength, combinedNameByLength) = createNameByLengths()
        delegate?.FawGenModelLoadingCompletion(at: 30)
        
        biGramChains = biGramsStartChains()
        delegate?.FawGenModelLoadingCompletion(at: 33)
        
        triGramChains = triGramsStartChains()
        delegate?.FawGenModelLoadingCompletion(at: 37)
        
        loadAndAssignWordToVecModel()

    }
    
    
    
    
}


extension FawGenModel {
    
    // MARK: - Load From Files Methods
    private func loadListOfStatements() -> Set<String> {
        let result = getBundleFileRowsAsSet(from: ModelConstants.statements_20K)
        return result
    }
    
    private func loadBiGramsStart() -> Set<String> {
        let result = getBundleFileRowsAsSet(from: ModelConstants.markovBiGramStart)
        return result
    }
    
    private func loadTriGramStart() -> Set<String> {
        let result = getBundleFileRowsAsSet(from: ModelConstants.markovTriGramStart)
        return result
    }
    
    private func loadWantedLeftBiGrams() -> Set<String> {
        let result = getBundleFileRowsAsSet(from: ModelConstants.wantedLeftBiGrams)
        return result
    }
    
    private func loadWantedLeftTriGrams() -> Set<String> {
        let result = getBundleFileRowsAsSet(from: ModelConstants.wantedLeftTriGrams)
        return result
    }
    
    private func loadWantedLeftFourGrams() -> Set<String> {
        let result = getBundleFileRowsAsSet(from: ModelConstants.wantedLeftFourGrams)
        return result
    }
    
    private func loadWantedRightFourGrams() -> Set<String> {
        let result = getBundleFileRowsAsSet(from: ModelConstants.wantedRightFourGrams)
        return result
    }
    
    private func loadFinalCorpus() -> Set<String> {
        let result = getBundleFileRowsAsSet(from: ModelConstants.finalCorpusFile)
        return result
    }
    
    
    private func loadSynonymsTable() -> (wordsRank: [String : [String]], corpus: Set<String>) {
        var wordsRank = [String : [String]]()
        var corpus = Set<String>()
        let listRank = getBundleFileRowsAsSet(from: ModelConstants.synonymsRanked)
        
        // *** REWRITE ALL Components
        for line in listRank {
            let comp = line.components(separatedBy: .whitespaces)
            if comp.count >= 2 {
                let word = Array(comp.prefix(1))[0]
                let ranks = Array(comp.suffix(comp.count - 1))
                corpus.insert(word)
                wordsRank[word] = ranks
            }
        }
        // *** END

//        corpus = Set(listRank.map { $0.components(separatedBy: .whitespaces)[0] })
//        wordsRank = listRank.reduce(into: [:]) {result, item in
//            var comp = item.components(separatedBy: .whitespaces)
//            let word = comp.removeFirst()
//            result[word] = comp
//            } as! [String : [String]]
        
        return (wordsRank, corpus)
    }
    
    private func loadBiGramFrequencyTable() -> [String : Int] {
        var freqTable = [String : Int]()
        let rows = getBundleFileRowsAsSet(from: ModelConstants.biGramFreqTable)
        
        // *** CHECKED
        for line in rows {
            let comp = line.components(separatedBy: .whitespaces)
            guard comp.count == 2, let value = Int(comp[1])   else { continue }
            let biGram = comp[0]
            freqTable[biGram] = value
        }
        return freqTable
    }
    
    private func createCombinedVocabulary() -> Set<String> {
        var combined = Set<String>()
        let vocab = finalCorpus
        combined.formUnion(vocab)
        combined.formUnion(StopWords.cleaned)
        combined.formUnion(synonymsCorpus)
        return combined
    }
    
    
    private func createNameByLengths() -> ([Set<String>], [Set<String>]) {
        var vectorsBYL = [Set<String>]()
        var combinedBYL = [Set<String>]()
        
        for idx in 0...ModelConstants.maxLength {
            var combinedWords = Set<String>()
            let filename = "\(idx)" + ModelConstants.letterTXT + ModelConstants.extTXT
            let words = getBundleFileRowsAsSet(from: filename)
            vectorsBYL.append(words)
            
            let synoWords = synonymsCorpus.filter { $0.count == idx }
            let stopWords = StopWords.cleaned.filter { $0.count == idx }
            combinedWords.formUnion(words)
            combinedWords.formUnion(synoWords)
            combinedWords.formUnion(stopWords)
            combinedBYL.append(combinedWords)
        }
        return (vectorsBYL, combinedBYL)
    }
    
    private func biGramsStartChains() -> Chains {
        let rows = getBundleFileRowsAsSet(from: ModelConstants.markovBiGramChains)
        var chains = Chains()
        
        // CHECKED
        for row in rows {
            let comp = row.components(separatedBy: .whitespaces)
            
            let biGram = Array(comp.prefix(1))[0]
            let chain = Array(comp.suffix(comp.count - 1))
            guard biGram.count == 2 else { continue }
            chains[biGram] = chain
        }
        return chains
    }
    
    private func triGramsStartChains() -> Chains {
        let rows = getBundleFileRowsAsSet(from: ModelConstants.markovTriGramChains)
        var chains = Chains()
        
        // CHECKED
        for row in rows {
            let comp = row.components(separatedBy: .whitespaces)
            
            let triGram = Array(comp.prefix(1))[0]
            let chain = Array(comp.suffix(comp.count - 1))
            guard triGram.count == 3 else { continue }
            chains[triGram] = chain
        }
        return chains
    }
    
    private func loadAndAssignWordToVecModel() {
        for idx in 1...ModelConstants.numberOfClusters {
            let rows = getClusterFileRowsForCentroid(number: idx)
            processCluster(rows)
        }
    }

}


extension FawGenModel {
    // MARK: - Utility methods
    
    /// Returns the rows of a file included in the main bundle
    /// - Parameter filename: The name of the file from which rows are to be extracted.
    /// - Returns: The rows from the file as a Set of Strings.
    private func getBundleFileRowsAsSet(from filename: String) -> Set<String> {
        var rows = Set<String>()
        
        let comp = filename.components(separatedBy:".")
        if comp.count != 2 { return Set<String>() }
        let fileURL = Bundle.main.url(forResource:comp[0], withExtension: comp[1])
        let wordsList = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        
        let listArray = wordsList.components(separatedBy: NSCharacterSet.newlines)
        for line in listArray {
            if line.count == 0 { continue }
            rows.insert(line)
        }

        return rows
    }
    
    // Because the file is in the Bundle, there should not be a problem with forced unwraping
    public func getOneRandomStatement() -> String {
        return statements.randomElement()!
    }
    
    
}


extension FawGenModel {
    
    /// Get the Cluster file in the bundle at the position n
    /// and return each rows as array of string
    private func getClusterFileRowsForCentroid(number n: Int) -> [String] {
        var rows = [String]()
        let filename = ModelConstants.clusterTXT + "\(n)" + ModelConstants.extTXT
        var fileContent = String()
        let comp = filename.components(separatedBy: ".")
        let fileURL = Bundle.main.url(forResource: comp[0], withExtension: comp[1])
        do {
            fileContent = try String(contentsOf: fileURL!, encoding: .utf8)
        } catch {
            print("[WordToVecModel Init FAILED!] - Error reading file named: \(filename) - Error description: \(error)")
        }
        rows = fileContent.components(separatedBy: NSCharacterSet.newlines)
        return rows
    }
    
    /// Processes Cluster rows to updates the properties: nameToVector
    /// collectionOfVectors, centroids and classificationByCentroids
    /// - Note: This is the method that takes all the time during StartUp
    /// - ToDo: There is a need to optinize this method in the near future. Maybe
    /// this should be the fisrt question you ask on StackOverflow
    private func processCluster(_ _rows: [String]) {
        var rows = _rows
        let first = rows.removeFirst()
        guard let centroidVector = getVector(from: first) else { return }
        centroids.append(centroidVector)
        let centroidClass = rows.reduce(into: []) { result, line in
            if let vector = getVector(from: line) {
                collectionOfVectors.append(vector)
                nameToVector[vector.name] = vector
                result.append(vector)
            }
            } as! [Vector]
        classificationByCentroids.append(centroidClass)
    }
    
    /// Returns a Vector type from a clusters row line
    private func getVector(from line: String) -> Vector? {
        
        let comp = line.components(separatedBy: .whitespaces)
        let word = Array(comp.prefix(1))[0]
        let coordinates = Array(comp.suffix(comp.count - 1))
        if word.count < ModelConstants.minCharacter || word.count > ModelConstants.maxLength { return nil }
        let data = coordinates.map{ Double($0)! }
        return Vector(data, name: word)
    }
    
}


extension FawGenModel {
    private func loadingPercent(_ percent: Int) {
        delegate?.FawGenModelLoadingCompletion(at: percent)
    }
    
}
