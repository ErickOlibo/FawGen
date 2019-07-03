//
//  FakeWord.swift
//  FawGen
//
//  Created by Erick Olibo on 14/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

public struct FakeWord: Codable {
    
    enum MadeUpType: String, CaseIterable, Codable {
        case concat, markov, simple, startBlend
        case endBlend, vowelsBlend, substitute, flavor, failed, userDefined
    }
    
    //var isSaved: Bool = false
    //var lastQueryUpdate: Date?
    private(set) var created: Date
    
    init() {
        self.created = Date()
    }
    
//    init(_ isEmpty: Bool) {
//        
//    }
    
    let name: String = {
        guard let rndWord = Constants.fakeWords.randomElement() else { return "No Fakes"}
        return rndWord.capitalized 
    }()
    
    let madeUpRoots: String = {
        guard let story = Constants.hundredStatments.randomElement() else { return "N/A"}
        return story
    }()
    
    let madeUpType: MadeUpType = {
        guard let algo = MadeUpType.allCases.randomElement() else { return .failed }
        if algo == .userDefined { return .concat }
        return algo
    }()

    let font: String = {
        let fontLister = FontsLister()
        guard let rndFont = fontLister.randomFont() else { return "AvenirNext-Bold" }
        return rndFont
    }()
    
    let logoBackColor: String = {
        return Constants.thousandColors.randomElement() ?? "#F6511D" // Not good but ok for now
    }()
    
    let logoName: String = {
        return iconNames.randomElement() ?? "swift"
    }()
    
    //let simpleSocialURLs: [SocialNetwork : String]
    

    
}

fileprivate let iconNames: Set = ["swift", "opengraph", "angular"]

