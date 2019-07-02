//
//  FakeWord.swift
//  FawGen
//
//  Created by Erick Olibo on 14/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

struct FakeWord: Codable {
    
    enum MadeUpType: String, CaseIterable, Codable {
        case concat, markov, simple, startBlend, endBlend, vowelsBlend, substitute, flavor, failed
        
    }
    
    var isSaved: Bool = false
    var lastQueryUpdate: Date?
    private(set) var created: Date
    
    init() {
        self.created = Date()
    }
    
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
        return algo
    }()

    let font: String = {
        let fontLister = FontsLister()
        guard let rndFont = fontLister.randomFont() else { return "AvenirNext-Bold" }
        return rndFont
    }()
    
    
    let logoBackgroundHexColor: String = {
        return Constants.thousandColors.randomElement() ?? "#F6511D" // Not good but ok for now
    }()
    
    
    let logoName: String = {
        return iconNames.randomElement() ?? "swift"
    }()
    
    //let simpleSocialURLs: [SocialNetwork : String]
    

    
}

fileprivate let iconNames: Set = ["swift", "opengraph", "angular"]

