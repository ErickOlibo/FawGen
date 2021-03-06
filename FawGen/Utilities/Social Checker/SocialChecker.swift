//
//  SocialChecker.swift
//  FawGen
//
//  Created by Erick Olibo on 28/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

/**
 Checks the availability of usernames in the list of social network platform.
 There are two checkers available: Simple & Complete
 - Remark:
 The boolean return TRUE if page is available (status code 404)
 The boolean return FALSE if page is not available (Status code 200 and other)
 Get an instance of this class and access the two checkers directly
 TRUE ==> AVAILABLE || FALSE ==> TAKEN
 
 */


public class SocialChecker {
    // Maybe adding something here later
    

}

/// Enumeration of ALL social networks used in this app
public enum SocialNetwork: String, CustomStringConvertible, CaseIterable, Equatable, Hashable {
    case facebook, youtube, twitter, instagram, github, producthunt, bitbucket, angellist
    case vimeo, behance, medium, reddit, pinterest, wordpress, slack

    public var description: String {
        return self.rawValue
    }
    
    /// A data type carrying information about a social Network, its icon
    /// and dominant color.
    public var info: SocialMedia {
        return SocialMedia(self.rawValue, icon: UIImage(named: self.rawValue)!, color: self.color())
    }
    
    /// Returns the simple Array for the 4 major Social Networks
    public var simpleList: [SocialNetwork] {
        return simple
    }
}

extension SocialNetwork {
    
    /// Returns the SocialNetwork Dominant color as a UIColor
    /// - Note: These are forced unwrapped as the dominant HEX colors
    /// are manually entered and should never be of wrong format.
    fileprivate func color() -> UIColor {
        switch self {
        case .facebook:
            return SocialColor.facebook.rawValue.convertedToUIColor()
        case .youtube:
            return SocialColor.youtube.rawValue.convertedToUIColor()
        case .twitter:
            return SocialColor.twitter.rawValue.convertedToUIColor()
        case .instagram:
            return SocialColor.instagram.rawValue.convertedToUIColor()
        case .github:
            return SocialColor.github.rawValue.convertedToUIColor()
        case .producthunt:
            return SocialColor.producthunt.rawValue.convertedToUIColor()
        case .bitbucket:
            return SocialColor.bitbucket.rawValue.convertedToUIColor()
        case .angellist:
            return SocialColor.angellist.rawValue.convertedToUIColor()
        case .vimeo:
            return SocialColor.vimeo.rawValue.convertedToUIColor()
        case .behance:
            return SocialColor.behance.rawValue.convertedToUIColor()
        case .medium:
            return SocialColor.medium.rawValue.convertedToUIColor()
        case .reddit:
            return SocialColor.reddit.rawValue.convertedToUIColor()
        case .pinterest:
            return SocialColor.pinterest.rawValue.convertedToUIColor()
        case .wordpress:
            return SocialColor.wordpress.rawValue.convertedToUIColor()
        case .slack:
            return SocialColor.slack.rawValue.convertedToUIColor()


        }
    }
    
}


/// Social Networks color theme enumeration
/// The format is HEX color and the data type is String
private enum SocialColor: String {
    case facebook = "#3b5998" // Chinese Blue
    case youtube = "#CD201F" // Engine Red
    case twitter = "#1DA1F2" // Button Blue
    case instagram = "#3F729B" // Queen Blue
    case github = "#211F1F" // Raisin Black
    case producthunt = "#DA552F" // Flame
    case bitbucket = "#253858" // Indigo
    case angellist = "#000000" // Black
    case vimeo = "#19B7EA" // Spiro Disco Ball
    case behance = "#1769FF" // Shade Of Blue
    case medium = "#3B3B3B" // Dark Black
    case reddit = "#FF4500" // Red Orange
    case blogger = "#F57D00" // Giants Orange
    case wordpress = "#00749C" // CG Blue
    case slack = "#3AAE84" // Mint
    case pinterest = "#F0002A" // Spanish Red
}




private var simple: [SocialNetwork] {
    return [.facebook, .youtube, .twitter, .instagram]
}

private var complete: [SocialNetwork] {
    return SocialNetwork.allCases
}

/// Return the Social Network URLS for a username
/// - Parameter username: the username handle to add after each domain
/// - Parameter completeList: Rather or not this should be for the 4 main socialNetworks
/// or the complete list of 16 (for the time being)
/// - Returns: A dictionary of socialNetwork type with their coresponding URL
public func socialNetworkURLs(for username: String, completeList: Bool = true) -> [SocialNetwork : String] {
    var urlsCollection = [SocialNetwork : String]()
    let handle = username.lowercased()
    let www = "www."
    let at = "@"
    let dot = "."
    for item in complete {
        var urlUsername = "https://"
        switch item {
        case .facebook:
            urlUsername += item.rawValue + ".com/" + handle
        case .youtube:
            urlUsername += item.rawValue + ".com/" + handle
        case .twitter:
            urlUsername += item.rawValue + ".com/" + handle
        case .instagram:
            urlUsername += item.rawValue + ".com/" + handle
        case .github:
            urlUsername += item.rawValue + ".com/" + handle
        case .producthunt:
            urlUsername += www + item.rawValue + ".com/" + at + handle
        case .bitbucket:
            urlUsername += item.rawValue + ".org/" + handle
        case .angellist:
            urlUsername += "angel.co/" + handle
        case .vimeo:
            urlUsername += item.rawValue + ".com/" + handle
        case .behance:
            urlUsername += www + item.rawValue + ".net/" + handle
        case .medium:
            urlUsername += item.rawValue + ".com/" + at + handle
        case .reddit:
            urlUsername += www + item.rawValue + ".com/user/" + handle
        case .pinterest:
            urlUsername += www + item.rawValue + ".com/" + handle
        case .wordpress:
            urlUsername += handle + dot + item.rawValue + ".com/"
        case .slack:
            urlUsername += handle + dot + item.rawValue + ".com/"
        
        }
        urlsCollection[item] = urlUsername
    }
    return completeList ? urlsCollection : urlsCollection.filter{ simple.contains($0.key) }
}

