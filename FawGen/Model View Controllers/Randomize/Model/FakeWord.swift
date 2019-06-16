//
//  FakeWord.swift
//  FawGen
//
//  Created by Erick Olibo on 14/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

struct FakeWord {
    
    enum MadeUpType: String, CaseIterable {
        case concat, markov, simple, startBlend, endBlend, vowelsBlend, substitute, flavor, failed
        
    }
    
    var isSaved: Bool = false
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
    
    let designBarColor: UIColor = {
        guard let rndColor = Constants.thousandColors.randomElement()?.convertedToUIColor() else { return .white }
        return rndColor
    }()
    
    let logo: UIImage = {
        let imgName = iconNames.randomElement() ?? "swift"
        guard let image = UIImage(named: imgName) else { return #imageLiteral(resourceName: "swift") }
        return image
    }()
    
    //let simpleSocialURLs: [SocialNetwork : String]
    
    
    // Text-To-Speech to do here
    
}

fileprivate let iconNames: Set = ["swift", "opengraph", "angular"]
