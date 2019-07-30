//
//  ToolBox.swift
//  ModelForFawGen
//
//  Created by Erick Olibo on 12/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


class ToolBox {
    
    public var delegate: ToolBoxDelegate?
    public var requestedQuality: QualityOptions = (nil, nil)
    
    // MARK: - Private constants
    private let device = UIDevice.current
    private let model = PersistentModel.shared.model
    private let simpleAssistModel: SimpleAssistModel
    private let nlp: NLProcessor
    private let synonymsFinder: SynonymsFinder
    
    private(set) var swapper: Swapper
    private(set) var concatenater: Concatenater
    private(set) var markovChainer: MarkovChainer
    private(set) var subsituter: Substituter
    private(set) var flavorizer: Flavorizer
    
    private var list = Set<String>()
    private var keywords = String()
    
    init() {
        self.swapper = Swapper()
        self.concatenater = Concatenater()
        self.markovChainer = MarkovChainer()
        self.subsituter = Substituter()
        self.flavorizer = Flavorizer()
        self.nlp = NLProcessor()
        self.simpleAssistModel = SimpleAssistModel()
        self.synonymsFinder = SynonymsFinder()
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
        let start = Date()
        guard let list = simpleAssistModel.getNeighbors(from: synAndKey) else { return Set<String>() }
        printModelAPI("NEIGHBORS [\(list.count)]: \(list.sorted())")
        delegate?.toolBoxResultsReady(for: .neighbors)
        printModelAPI("ToolBox ==> [generateMadeUpWords / getNeighbors] - \(start.toNowProcessDuration)")
        return list
        
    }
    
    /// Collects all Keywords, and Synonyms from the entered keywords or random statement
    private func getAllKeywordsAndSynonyms(from keywords: String) -> String {
        let start = Date()
        let space = " "
        self.keywords = (keywords == String()) ? model.statements.randomOne() : keywords
        printModelAPI("KEYWORDS: \(self.keywords)")
        
  
        let synonyms = getAllSynonyms()?.joined(separator: " ") ?? String()
        let synAndKey = synonyms == String() ?  self.keywords : self.keywords + space + synonyms
        delegate?.toolBoxResultsReady(for: .synonyms)
        printModelAPI("ToolBox ==> [generateMadeUpWords / getAllSynonyms] - \(start.toNowProcessDuration)")
        
        return synAndKey
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
        printModelAPI("TOKENS: [\(tokens.count)] - RESULT: [\(synonymsAsSet.count)] - EXTRA: [\(extra.count)]")
        if maxListSize - tokens.count <= 0 {
            tmpList = Set(tmpList.shuffled().prefix(maxListSize))
        } else {
            tmpList.formUnion(extra.shuffled().prefix(maxListSize - tokens.count))
        }
        
        if tmpList.count == 0 { return nil }
        printModelAPI("SYN AND KEY [\(tmpList.count)]: \(tmpList.sorted())")
        return tmpList
    }
    
    /// Queries all randomizers and collects MadeUpWords from each of them
    /// The returning MadeUpWords are complying to the QualityOptions
    private func queryAllRandomizers() -> Set<MadeUpWord>? {
        var collection = Set<MadeUpWord>()
        var start = Date()
        
        // Swapper --> Quality algo value = 1.0
        if requestedQuality.algo == nil || requestedQuality.algo! == 1.0 {
            start = Date()
            if let swapperResults = swapperResults() { collection.formUnion(swapperResults) }
            delegate?.toolBoxResultsReady(for: .swap)
            printModelAPI("queryAllRandomizers ==> [SWAPPER] - \(start.toNowProcessDuration)")
        }
        
        
        // Subsituter --> Quality algo value = 2.0
        if requestedQuality.algo == nil || requestedQuality.algo! == 2.0 {
            start = Date()
            if let substituterResults = substituterResults() { collection.formUnion(substituterResults) }
            delegate?.toolBoxResultsReady(for: .substitute)
            printModelAPI("queryAllRandomizers ==> [SUBSTITUTER] - \(start.toNowProcessDuration)")
        }
        
        
        // Concatenater --> Quality algo value = 3.0
        if requestedQuality.algo == nil || requestedQuality.algo! == 3.0 {
            start = Date()
            if let concatenaterResults = concatenaterResults() { collection.formUnion(concatenaterResults) }
            delegate?.toolBoxResultsReady(for: .concat)
            printModelAPI("queryAllRandomizers ==> [CONCATENATER] - \(start.toNowProcessDuration)")
        }
        
        
        // MarkovChainer --> Quality algo value = 4.0
        if requestedQuality.algo == nil || requestedQuality.algo! == 4.0 {
            start = Date()
            if let markovChainerResults = markovChainerResults() { collection.formUnion(markovChainerResults) }
            delegate?.toolBoxResultsReady(for: .chain)
            printModelAPI("queryAllRandomizers ==> [MARKOVCHAINER] - \(start.toNowProcessDuration)")
        }
        
        
        // Flavorizer --> Quality algo value = 5.0
        if requestedQuality.algo == nil || requestedQuality.algo! == 5.0 {
            start = Date()
            if let flavorizerResults = flavorizerResults() { collection.formUnion(flavorizerResults) }
            delegate?.toolBoxResultsReady(for: .flavorize)
            printModelAPI("queryAllRandomizers ==> [FLAVORIZER] - \(start.toNowProcessDuration)")
        }
        
        
        return collection.count == 0 ? nil : collection
    }
    
    // Swapper
    private func swapperResults() -> Set<MadeUpWord>? {
        return swapper.generatesAllPossibilities(from: list, with: requestedQuality)
    }
    
    // Substituter
    private func substituterResults() -> Set<MadeUpWord>? {
        return subsituter.generatesAllPossibilities(from: list, with: requestedQuality)
    }
    
    // Concatenater
    private func concatenaterResults() -> Set<MadeUpWord>? {
        return concatenater.generatesAllPossibilities(from: list, with: requestedQuality)
    }
    
    // MarkovChainer
    private func markovChainerResults() -> Set<MadeUpWord>? {
        return markovChainer.generatesAllPossibilities(from: list, with: requestedQuality)
    }
    
    // Flavorizer
    private func flavorizerResults() -> Set<MadeUpWord>? {
        return flavorizer.generatesAllPossibilities(from: list, with: requestedQuality)
    }

}
