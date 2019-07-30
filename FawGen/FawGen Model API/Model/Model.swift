//
//  Model.swift
//  FawGen
//
//  Created by Erick Olibo on 07/04/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


class Model {
    
    // MARK: - Properties
    public var delegate: ModelDelegate?
    public var requestedQuality: RequestedQuality
    
    private(set) var vocab = ModelVocabulary()
    private(set) var nameToVector = [String : Vector]()
    private(set) var collectionOfVectors = [Vector]()
    private(set) var centroids = [Vector]()
    private(set) var classificationByCentroids = [[Vector]]()
    private(set) var grams = Grams()
    private(set) var statements = Statements()
    private(set) var name: String
    
    // MARK: - Initialization
    init(_ name: String) {
        self.name = name
        self.requestedQuality = RequestedQuality()
    }
    
    public func initialize() {
        self.statements = Statements()
        self.statements.delegate = self
        self.statements.initialize()
        
        self.grams = Grams()
        self.grams.delegate = self
        self.grams.initialize()
        
        self.vocab.delegate = self
        self.vocab.initialize()
        
        let wordToVec = WordToVecModel()
        wordToVec.delegate = self
        wordToVec.initialize()
        
        self.nameToVector = wordToVec.nameToVector
        self.collectionOfVectors = wordToVec.collectionOfVectors
        self.centroids = wordToVec.centroids
        self.classificationByCentroids = wordToVec.classificationByCentroids
        
    }
    

    // MARK: - Public Properties
    public var randomWord: String {
        var rndWord = String()
        while rndWord.count == 0 {
            guard let aWord = vocab.vocabulary.randomElement() else { continue }
            rndWord = aWord
        }
        return rndWord
    }
    
    
    // MARK: - Public Methods
    /// Returns a randomly selected word of a defined length
    /// pick from the vectorsNameByLength
    public func randomWord(ofLength len: Int) -> String {
        var rndWord = String()
        while rndWord.count == 0 {
            guard let aWord = vocab.vectorsNameByLength[len].randomElement() else { continue }
            rndWord = aWord
        }
        return rndWord
    }
}


extension Model: StatementsDelegate {
    func statementsLoading(_ percent: Int) {
        if percent == 100 { loadingPercent(4)}
    }
}

extension Model: GramsDelegate {
    func gramsLoading(_ percent: Int) {
        switch percent {
        case 10:
            loadingPercent(5)
        case 49:
            loadingPercent(9)
        case 100:
            loadingPercent(14)
        default:
            break
        }
    }
}

extension Model: ModelVocabularyDelegate {
    func modelVocabularyLoading(_ percent: Int) {
        switch percent {
        case 78:
            loadingPercent(27)
        case 100:
            loadingPercent(31)
        default:
            break
        }
    }
}

extension Model: WordToVecModelDelegate {
    func wordToVecLoading(_ percent: Int) {
        let thisPercent = 31 + (percent * 69) / 100
        loadingPercent(thisPercent)
    }
}

extension Model {
    private func loadingPercent(_ percent: Int) {
        delegate?.modelLoadingCompletion(at: percent)
    }
}

