//
//  FakeWordModel.swift
//  FawGen
//
//  Created by Erick Olibo on 14/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

struct FakeWordModel {
    
    enum MadeUpType: String {
        case concat, markov, simple, startBlend, endBlend, vowelsBlend, substitute, flavor
    }
    
    let name: String
    var isSaved: Bool = false
    let root: String // Needs to be updated from the previous FawGen
    let buildType: MadeUpType // Needs to be updated from the previous FawGen
    let font: String
    let color: UIColor
    let simpleSocialURLs: [SocialNetwork : String]
    
    
    // Text-To-Speech to do here
    
    
    
}
