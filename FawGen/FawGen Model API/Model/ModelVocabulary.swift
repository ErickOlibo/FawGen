//
//  ModelVocabulary.swift
//  FawGen
//
//  Created by Erick Olibo on 04/04/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

class ModelVocabulary {
    

    public var delegate: ModelVocabularyDelegate?
    private(set) var vocabulary = Set<String>()
    private(set) var combinedVocabulary = Set<String>()
    private(set) var vectorsNameByLength = [Set<String>]()
    private(set) var combinedNameByLength = [Set<String>]()
    
    public func initialize() {
        var start = Date()
        createVocabularies()
        printModelAPI("VOCAB Loading [1] - \(start.toNowProcessDuration)")
        delegate?.modelVocabularyLoading(78) // time was 1.69 sec out of 2.16
        
        start = Date()
        createNameByLengths()
        printModelAPI("VOCAB Loading [2] - \(start.toNowProcessDuration)")
        delegate?.modelVocabularyLoading(100) // time was 0.47 sec out of 2.16 but finished
    }
    
    private func createVocabularies() {
        vocabulary = ModelConstants.finalCorpus
        combinedVocabulary = vocabulary.union(StopWords.cleaned)
        combinedVocabulary.formUnion(ModelConstants.synonymsCorpus)
    }
    
    /// Creates the array of set of string with respect of the length of words.
    /// The combined is the normal corpus combined with the StopWords and the
    /// synonyms corpus
    private func createNameByLengths() {
        for idx in 0...ModelConstants.maxLength {
            var combinedWords = Set<String>()
            let filename = "\(idx)" + ModelConstants.letterTXT + ModelConstants.extTXT
            let words = getBundleFileRowsAsSet(from: filename)
            vectorsNameByLength.append(words)
            
            let synoWords = ModelConstants.synonymsCorpus.filter { $0.count == idx }
            let stopWords = StopWords.cleaned.filter { $0.count == idx }
            combinedWords.formUnion(words)
            combinedWords.formUnion(synoWords)
            combinedWords.formUnion(stopWords)
            combinedNameByLength.append(combinedWords)
        }
    }
    
}
