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
    
    enum MadeUpType: String, CaseIterable, Codable {
        case concat, markov, simple, startBlend
        case endBlend, vowelsBlend, substitute, flavor, failed, userDefined
    }
    
    
    private(set) var created: Date
    private(set) var name: String
    private(set) var madeUpRoots: String
    private(set) var madeUpType: MadeUpType
    public var font: String
    public var themeColor: String
    public var logoName: String
    
    init() {
        self.created = Date()
        self.name = _name
        self.madeUpRoots = _madeUpRoots
        self.madeUpType = _madeUpType
        self.font = _font
        self.themeColor = _themeColor
        self.logoName = _logoName
    }
    

    init(_ name: String, madeUpType: MadeUpType = .userDefined) {
        self.created = Date()
        self.name = name
        self.madeUpRoots = String()
        self.madeUpType = madeUpType
        self.font = String()
        self.themeColor = String() //"#EFEEF3"
        self.logoName = String()
    }
    
    private let _name: String = {
        guard let rndWord = Constants.fakeWords.randomElement() else { return "No Fakes"}
        return rndWord.capitalized 
    }()
    
    private let _madeUpRoots: String = {
        guard let story = Constants.hundredStatments.randomElement() else { return "N/A"}
        return story
    }()
    
    private let _madeUpType: MadeUpType = {
        guard let algo = MadeUpType.allCases.randomElement() else { return .failed }
        if algo == .userDefined { return .concat }
        return algo
    }()

    private let _font: String = {
//        let fontLister = FontsLister()
//        guard let rndFont = fontLister.randomFont() else { return "AvenirNext-Bold" }
        return "AvenirNext-Bold"
    }()
    
    private let _themeColor: String = {
        return "#F6511D"
        //return Constants.thousandColors.randomElement() ?? "#F6511D" // Not good but ok for now
    }()
    
    private let _logoName: String = {
        //return dataBaseManager.randomFakeLogoName()
        return "_Abstract_1"
    }()
    
    

    
}

fileprivate let iconNames: Set = ["swift", "opengraph", "angular"]

