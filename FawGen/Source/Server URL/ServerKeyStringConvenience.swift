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
    static let fawgen = "https://www.fawgen.com/"
    static let webLink = "https://www.inroze.com/webROze/"
    
    static let explanation = UrlFor.webLink + "missing.html"
    static let faq = UrlFor.webLink + "frequently.html"
    static let feedback = UrlFor.webLink + "feedback.html"
    static let fawgenStory = UrlFor.webLink + "about-inroze.html"
    static let termOfUse =  UrlFor.webLink + "terms.html"
    static let privacy = UrlFor.webLink + "privacy.html"
    static let openSource = UrlFor.webLink + "open-source.html"
    static let disclaimer = UrlFor.webLink + "frequently.html"
    
    
}
