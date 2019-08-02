//
//  FakeWord.swift
//  FawGen
//
//  Created by Erick Olibo on 14/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit
private var dataBaseManager = DefaultDB()

public struct FakeWord: Codable, Equatable {
    

    
    private(set) var created: Date
    private(set) var title: String
    private(set) var elements: [String]
    private(set) var roots: String
    private(set) var algoName: String
    private(set) var algoNumber: Double
    private(set) var titleLength: Double
    
    //private(set) var madeUpType: MadeUpType
    
    public var font = String()
    public var themeColor = String()
    public var logoName = String()
    
    // From a MadeUpWord result of the Model
    init(_ madeUpWord: MadeUpWord) {
        self.created = Date()
        self.title = madeUpWord.title
        self.elements = madeUpWord.elements
        self.roots = madeUpWord.rootsStory
        self.algoName = madeUpWord.madeUpQuality.algoName
        self.algoNumber = madeUpWord.madeUpQuality.algoNumber
        self.titleLength = Double(madeUpWord.title.count)
    }
    
    // A UserDefined FakeWord initializer or empty if nothing 
    init(_ userTitle: String = String()) {
        self.created = Date()
        self.title = userTitle
        self.elements = [String]()
        self.roots = "Not Available..."
        self.algoName = "user defined"
        self.algoNumber = Double()
        self.titleLength = Double()
    }

}


extension FakeWord {
    
    /// Returns if a fakeword is of the current Filters (quality) settings
    /// - Note: As this is reserved for a filtered on FakeWords that are already compliant
    /// to the App requirement, the check is only made on the All or nothing basis.
    /// Meaning that checking if Length and Algo are nil or equal to filters
    public func isOfCurrentFiltersQuality() -> Bool {
        let quality = dataBaseManager.getRequestedQuality()
        let reqLength = quality.length
        let reqAlgo = quality.algo
        
        if reqLength == nil && reqAlgo == nil { return true }
        if reqLength == self.titleLength && reqAlgo == nil { return true }
        if reqLength == nil && self.algoNumber == reqAlgo { return true }
        if reqLength == self.titleLength && reqAlgo == self.algoNumber { return true }
        
        return false
    }
    
}
