//
//  MadeUpWord.swift
//  FawGen
//
//  Created by Erick Olibo on 10/04/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


struct MadeUpWord: Hashable, CustomStringConvertible, Equatable {
    
    private(set) var title: String
    private(set) var elements: [String]
    private(set) var madeUpAlgo: MadeUpAlgo
    private(set) var madeUpQuality: MadeUpQuality
    
    init(_ title: String, _ elements: [String], _ madeUpAlgo : MadeUpAlgo) {
        self.title = title
        self.elements = elements
        self.madeUpAlgo = madeUpAlgo
        self.madeUpQuality = MadeUpQuality(title, algo: madeUpAlgo)
    }

    var description: String {
        let listElements = elements.joined(separator: ", ")
        return "\(title), [\(listElements)], \(madeUpAlgo)"
    }

}


func ==(lhs: MadeUpWord, rhs: MadeUpWord) -> Bool {
    return lhs.title == rhs.title
}


extension MadeUpWord {
    public func isOfRequestedQuality(_ quality: QualityOptions) -> Bool {
        // madeUpword Quality
        let wordLength = self.madeUpQuality.length
        let wordAlgo = self.madeUpQuality.algoNumber
        
        // Requested Quality
        let reqLength = quality.length
        let reqAlgo = quality.algo
        
        if reqLength == nil && !wordLength.isOfCorrectInAppLength { return false }
        if reqAlgo == nil && !wordAlgo.isOfCorrectAlgo { return false }
        let updatedReqLength = reqLength == nil ? wordLength : reqLength!.correctedLength
        let updatedReqAlgo = reqAlgo == nil ? wordAlgo : reqAlgo!.correctedAlgo
        
        let updReqQuality = (updatedReqLength, updatedReqAlgo)
        let wordQuality = (wordLength, wordAlgo)
        return updReqQuality == wordQuality
    }
    
    
}

extension String {
    public func isOfRequestedLengthQuality(_ qualityLength: Double?) -> Bool {
        if qualityLength == nil && !self.isOfCorrectInAppLength { return false }
        if qualityLength != nil && !self.isOfCorrectLength { return false }
        return true
    }
}
