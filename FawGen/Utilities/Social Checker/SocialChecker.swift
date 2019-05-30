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
    
    /// - Warning: This method might be useless as it requires all URLRequest
    /// to finish before passing on the result.
    /// This method must be improved or deleted
    public static func simpleLookup(_ username: String) -> [SocialNetwork : Bool]? {
        checkSocialNetworkURLs(for: username, isSimple: true)
        return nil
    }
    
    /// - Warning: This method might be useless as it requires all URLRequest
    /// to finish before passing on the result.
    /// This method must be improved or deleted
    public static func completeLookup(_ username: String) -> [SocialNetwork : Bool]? {
        checkSocialNetworkURLs(for: username, isSimple: false)
        return nil
    }
}

/// Enumeration of ALL social networks used in this app
public enum SocialNetwork: String, CustomStringConvertible, CaseIterable, Equatable, Hashable {
    case facebook, youtube, twitter, instagram, github, producthunt, bitbucket, angellist
    case vimeo, behance, medium, reddit, blogger, wordpress, slack, pinterest

    public var description: String {
        return self.rawValue
    }
    
    /// A data type carrying information about a social Network, its icon
    /// and dominant color.
    public var info: SocialMedia {
        return SocialMedia(self.rawValue, icon: UIImage(named: self.rawValue)!, color: self.color())
    }
}

extension SocialNetwork {
    
    /// Returns the SocialNetwork Dominant color as a UIColor
    /// - Note: There are forced unwrapped as the dominant HEX colors
    /// should never be badly formatted.
    fileprivate func color() -> UIColor {
        switch self {
        case .facebook:
            return SocialColor.facebook.rawValue.convertedToUIColor()!
        case .youtube:
            return SocialColor.youtube.rawValue.convertedToUIColor()!
        case .twitter:
            return SocialColor.twitter.rawValue.convertedToUIColor()!
        case .instagram:
            return SocialColor.instagram.rawValue.convertedToUIColor()!
        case .github:
            return SocialColor.github.rawValue.convertedToUIColor()!
        case .producthunt:
            return SocialColor.producthunt.rawValue.convertedToUIColor()!
        case .bitbucket:
            return SocialColor.bitbucket.rawValue.convertedToUIColor()!
        case .angellist:
            return SocialColor.angellist.rawValue.convertedToUIColor()!
        case .vimeo:
            return SocialColor.vimeo.rawValue.convertedToUIColor()!
        case .behance:
            return SocialColor.behance.rawValue.convertedToUIColor()!
        case .medium:
            return SocialColor.medium.rawValue.convertedToUIColor()!
        case .reddit:
            return SocialColor.reddit.rawValue.convertedToUIColor()!
        case .blogger:
            return SocialColor.blogger.rawValue.convertedToUIColor()!
        case .wordpress:
            return SocialColor.wordpress.rawValue.convertedToUIColor()!
        case .slack:
            return SocialColor.slack.rawValue.convertedToUIColor()!
        case .pinterest:
            return SocialColor.pinterest.rawValue.convertedToUIColor()!

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


/// - Warning: This method URLSession does not fit the current App
/// It must be improve to allow dispatch to social view
private func checkSocialNetworkURLs(for username: String, isSimple: Bool) {
    let socialURLs = socialNetworkURLs(for: username)
    let filteredURLs = isSimple ? socialURLs.filter{ simple.contains($0.key) } : socialURLs
    let myGroup = DispatchGroup()
    var result = [SocialNetwork : Bool]()
    
    for (social, link) in filteredURLs {
        myGroup.enter()
        guard let url = URL(string: link) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    result[social] = (httpResponse.statusCode == 404)
                }
            } else {
                DispatchQueue.main.async {
                    result[social] = false
                }
            }
            myGroup.leave()
        }
        task.resume()
    }
    myGroup.notify(queue: .main) {
        print(result)
    }
    
}

private var simple: [SocialNetwork] {
    return [.facebook, .youtube, .twitter, .instagram]
}

private var complete: [SocialNetwork] {
    return SocialNetwork.allCases
}

/// Return the Social Network URLS for a username
private func socialNetworkURLs(for username: String) -> [SocialNetwork : String] {
    var urlsCollection = [SocialNetwork : String]()
    for item in SocialNetwork.allCases {
        var domain = "https://"
        switch item {
        case .angellist:
            domain += "angel.co/"
        case .bitbucket, .wordpress:
            domain += item.rawValue + ".org/"
        case .behance:
            domain += item.rawValue + ".net/"
        default:
            domain += item.rawValue + ".com/"
        }
        
        let url = domain + username.lowercased()
        urlsCollection[item] = url
    }
    
    return urlsCollection
}

