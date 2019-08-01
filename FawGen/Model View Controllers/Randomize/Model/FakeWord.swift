//
//  FakeWord.swift
//  FawGen
//
//  Created by Erick Olibo on 14/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit
private var dataBaseManager = DefaultDB()

public struct FakeWord: Codable {
    

    
    private(set) var created: Date
    private(set) var title: String
    private(set) var elements: [String]
    private(set) var roots: String
    private(set) var algoName: String
    private(set) var algoNumber: Double
    
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
    }
    
    // A UserDefined FakeWord initializer or empty if nothing 
    init(_ userTitle: String = String()) {
        self.created = Date()
        self.title = userTitle
        self.elements = [String]()
        self.roots = "Not Available..."
        self.algoName = "user defined"
        self.algoNumber = Double()
    }

}


