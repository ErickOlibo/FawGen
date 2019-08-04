//
//  ToolBox.swift
//  FawGenModelAPI
//
//  Created by Erick Olibo on 04/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


class ToolBox {
    
    public var requestedQuality: QualityOptions = (nil, nil)
    
    // MARK: - Properties
    private let device = UIDevice.current
    private weak var model: FawGenModel!
    private weak var grams: Grams!
    private weak var kNN: KNearestNeighbors!
    private let nlp: NLProcessor!
    
    // *** NOTE: are the variable below supposed to be public? (i.e. private(set))
    private(set) var statements: Set<String>
    private(set) var nameToVector: [String : Vector]
    private(set) var synonymsCorpus: Set<String>
    private(set) var synonymsWordsRank: [String : [String]]
    private(set) var combinedVocabulary: Set<String>
    
    // Public Randomizers
    private(set) var swapper: Swapper
    private(set) var substituter: Substituter
    private(set) var concatenater: Concatenater
    private(set) var markovChainer: MarkovChainer
    private(set) var flavorizer: Flavorizer
    
    private let simpleAssistModel: SimpleAssistModel
    private let synonymsFinder: SynonymsFinder
    
    private var list = Set<String>()
    private var keywords = String()
    
    
    init(_ model: FawGenModel, grams: Grams, kNN: KNearestNeighbors) {
        
        statements = model.statements
        nameToVector = model.nameToVector
        synonymsCorpus = model.synonymsCorpus
        synonymsWordsRank = model.synonymsWordsRank
        combinedVocabulary = model.combinedVocabulary
        simpleAssistModel = SimpleAssistModel(model, kNN: kNN)
        synonymsFinder = SynonymsFinder(model)
        swapper = Swapper(model, grams: grams)
        substituter = Substituter(model, grams: grams)
        concatenater = Concatenater(model, grams: grams)
        markovChainer = MarkovChainer(model, grams: grams)
        flavorizer = Flavorizer(model, grams: grams)
        nlp = NLProcessor()
        
    }
    
}


// MARK: - Public methods
extension ToolBox {
    
    /// Returns a list of MadeUpWords generated using all types of randomizers.
    /// - Parameters:
    ///     - keywords: List of keywords enter by the user to assist the model
    ///     - options: These are three quality that can be set. The length, the type and symbol.
    /// When a quality does not matter, nil is used to indicate that particular quality is to be set false.
    public func generateMadeUpWords(from keywords: String = String()) -> Set<MadeUpWord>? {
        let synAndKey = getAllKeywordsAndSynonyms(from: keywords)
        self.list = getAllNeighbors(from: synAndKey)
        return queryAllRandomizers()
    }
}



// MARK: - Private methods
extension ToolBox {
    
    /// Collects all the neighbors for the list of keywords and synonyms
    private func getAllNeighbors(from synAndKey: String) -> Set<String> {
        guard let list = simpleAssistModel.getNeighbors(from: synAndKey) else { return Set<String>() }
        return list
        
    }
    
    /// Collects all Keywords, and Synonyms from the entered keywords or random statement
    private func getAllKeywordsAndSynonyms(from keywords: String) -> String {
        let space = " "
        self.keywords = (keywords == String()) ? getOneRandomStatement() : keywords
        print("KEYWORDS: \(self.keywords)")
        
        let synonyms = getAllSynonyms()?.joined(separator: " ") ?? String()
        let synAndKey = synonyms == String() ?  self.keywords : self.keywords + space + synonyms
        return synAndKey
    }
    
    // Because the file is in the Bundle, there should not be a problem with forced unwraping
    private func getOneRandomStatement() -> String {
        return statements.randomElement()!
    }
    
    
    /// Collects the synonyms of words from the keywords list
    private func getAllSynonyms() -> Set<String>? {
        let tokens = nlp.tokenizeByWords(keywords)
        var tmpList = tokens
        let maxListSize = device.processingPowerKeywordsAndSynonymsLimit
        let synonyms = tokens.reduce(into: []) { result, item in
            if let syno = synonymsFinder.getSynonyms(of: item) {
                result.append(contentsOf: syno)
            }
            
            } as! [String]
        let synonymsAsSet = Set(synonyms)
        let extra = synonymsAsSet.subtracting(tokens)
        print("TOKENS: [\(tokens.count)] - RESULT: [\(synonymsAsSet.count)] - EXTRA: [\(extra.count)]")
        if maxListSize - tokens.count <= 0 {
            tmpList = Set(tmpList.shuffled().prefix(maxListSize))
        } else {
            tmpList.formUnion(extra.shuffled().prefix(maxListSize - tokens.count))
        }
        
        if tmpList.count == 0 { return nil }
        print("SYN AND KEY [\(tmpList.count)]: \(tmpList.sorted())")
        return tmpList
    }
    
    /// Queries all randomizers and collects MadeUpWords from each of them
    /// The returning MadeUpWords are complying to the QualityOptions
    private func queryAllRandomizers() -> Set<MadeUpWord>? {
        var collection = Set<MadeUpWord>()
        
        if requestedQuality.algo == nil || requestedQuality.algo! == 1.0 {
            if let swapperResults = swapperResults() { collection.formUnion(swapperResults) }
        }
        
        if requestedQuality.algo == nil || requestedQuality.algo! == 2.0 {
            if let substituterResults = substituterResults() { collection.formUnion(substituterResults) }
        }
        
        if requestedQuality.algo == nil || requestedQuality.algo! == 3.0 {
            if let concatenaterResults = concatenaterResults() { collection.formUnion(concatenaterResults) }
        }
        
        if requestedQuality.algo == nil || requestedQuality.algo! == 4.0 {
            if let markovChainerResults = markovChainerResults() { collection.formUnion(markovChainerResults) }
        }
        
        if requestedQuality.algo == nil || requestedQuality.algo! == 5.0 {
            if let flavorizerResults = flavorizerResults() { collection.formUnion(flavorizerResults) }
        }
        
        return collection.count == 0 ? nil : collection
    }
    
    private func swapperResults() -> Set<MadeUpWord>? {
        return swapper.generatesAllPossibilities(from: list, with: requestedQuality)
    }
    
    private func substituterResults() -> Set<MadeUpWord>? {
        return substituter.generatesAllPossibilities(from: list, with: requestedQuality)
    }
    
    private func concatenaterResults() -> Set<MadeUpWord>? {
        return concatenater.generatesAllPossibilities(from: list, with: requestedQuality)
    }
    
    private func markovChainerResults() -> Set<MadeUpWord>? {
        return markovChainer.generatesAllPossibilities(from: list, with: requestedQuality)
    }
    
    private func flavorizerResults() -> Set<MadeUpWord>? {
        return flavorizer.generatesAllPossibilities(from: list, with: requestedQuality)
    }
    
}
