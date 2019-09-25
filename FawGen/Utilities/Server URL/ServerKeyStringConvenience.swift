//
//  ServerKeyStringConvenience.swift
//  FawGen
//
//  Created by Erick Olibo on 07/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


/// URLs to connect to the server or the FawGen website
/// - Warning: Right now for development purpose, www.inroze.com
/// links are used. There is a need to change it once fawgen.com
/// is up and running
public struct UrlFor {
    static let fawgen = "https://www.fawgen.com/AppSettings/"
    static let fawgenAssets = "https://www.fawgen.com/Assets/xcassets/"
    static let webLink = "https://www.inroze.com/webROze/"
    
    static let algoExplanation = UrlFor.fawgen + "algoExplanation.html"
    static let faq = UrlFor.fawgen + "questions.html"
    static let feedback = UrlFor.fawgen + "feedback.html"
    static let fawgenStory = UrlFor.fawgen + "about-inroze.html"
    static let termOfUse =  UrlFor.fawgen + "terms.html"
    static let privacy = UrlFor.fawgen + "privacy.html"
    static let openSource = UrlFor.fawgen + "open-source.html"
    static let disclaimer = UrlFor.fawgen + "disclaimer.html"
    static let fakeIconsFolder = UrlFor.fawgenAssets + "fakeIcons/"
    
    
}
