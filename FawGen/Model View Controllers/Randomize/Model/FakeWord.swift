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
    
//    enum MadeUpType: String, CaseIterable, Codable {
//        case swaps, subs, concat, chains, flavor
//        case userDefined, undefined
//    }
    
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
    
    // An empty FakeWord
//    init() {
//        self.created = Date()
//        self.title = String()
//        self.elements = [String]()
//    }
    
    
    
    
    private func createRootsStory() -> String {
        
        // Switch with all 5 algos with their elements and then if none of them,
        // it means that elements is empty and it was a userDefined word
        return ""
    }
    
//    // Empty FakeWord
//    init() {
//        self.created = Date()
//        self.title = _name
//        self.roots = _madeUpRoots
//        //self.madeUpType = _madeUpType
//        self.font = _font
//        self.themeColor = _themeColor
//        self.logoName = _logoName
//    }
    

//    // UserDefined
//    init(_ name: String, madeUpType: MadeUpType = .userDefined) {
//        self.created = Date()
//        self.title = name
//        //self.roots = String()
//        //self.madeUpType = madeUpType
//        self.font = String()
//        self.themeColor = String() //"#EFEEF3"
//        self.logoName = String()
//    }
    
//    private let _name: String = {
//        guard let rndWord = Constants.fakeWords.randomElement() else { return "No Fakes"}
//        return rndWord.capitalized
//    }()
//
//    private let _madeUpRoots: String = {
//        guard let story = Constants.hundredStatments.randomElement() else { return "N/A"}
//        return story
//    }()
//
//    private let _madeUpType: MadeUpType = {
//        guard let algo = MadeUpType.allCases.randomElement() else { return .undefined }
//        if algo == .userDefined { return .concat }
//        return algo
//    }()
//
//    private let _font: String = {
////        let fontLister = FontsLister()
////        guard let rndFont = fontLister.randomFont() else { return "AvenirNext-Bold" }
//        return "AvenirNext-Bold"
//    }()
//
//    private let _themeColor: String = {
//        return "#F6511D"
//        //return Constants.thousandColors.randomElement() ?? "#F6511D" // Not good but ok for now
//    }()
//
//    private let _logoName: String = {
//        //return dataBaseManager.randomFakeLogoName()
//        return "_Abstract_1"
//    }()
//
    

    
}

//fileprivate let iconNames: Set = ["swift", "opengraph", "angular"]

