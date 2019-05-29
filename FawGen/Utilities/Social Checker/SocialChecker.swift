//
//  SocialChecker.swift
//  FawGen
//
//  Created by Erick Olibo on 28/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

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
    
    public static func simpleLookup(_ username: String) -> [SocialNetwork : Bool]? {
        checkSocialNetworkURLs(for: username, isSimple: true)
        return nil
    }
    
    public static func completeLookup(_ username: String) -> [SocialNetwork : Bool]? {
        checkSocialNetworkURLs(for: username, isSimple: false)
        return nil
    }
}


public enum SocialNetwork: String, CustomStringConvertible, CaseIterable, Equatable, Hashable {
    case facebook, youtube, twitter, instagram, github, producthunt, bitbucket, angellist
    case vimeo, behance, medium, reddit, blogger, wordpress, slack, pinterest

    public var description: String {
        return self.rawValue
    }
}

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


// DELETE under

private func checkSocialURLs(name: String) {
    let username = name.lowercased()
    let socialURLs = buildSocialURLs(name: username)
    let myGroup = DispatchGroup()
    var result = socialURLs
    
    for idx in 1..<socialURLs.count {
        myGroup.enter()
        guard let url = URL(string: socialURLs[idx]) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    result[idx] = String(httpResponse.statusCode)
                }
            } else {
                DispatchQueue.main.async {
                    result[idx] = "Failed"
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



private struct Social {
    struct Code {
        static let fb = "FB"
        static let yt = "YT"
        static let tw = "TW"
        static let ig = "IG"
    }
    
    struct URL {
        static let facebook = "https://facebook.com/"
        static let youtube = "https://youtube.com/"
        static let twitter = "https://twitter.com/"
        static let instagram = "https://instagram.com/"

    }
    
    struct name {
        static let facebook = "facebook"
        static let youtube = "youtube"
        static let twitter = "twitter"
        static let instagram = "instagram"
    }
    
}







// ******** PRIVATE CLASSES & Methods
private func buildSocialURLs (name: String) -> [String] {
    
    // Social Platforms to check
    let facebook = "https://facebook.com/"
    let youtube = "https://youtube.com/"
    let twitter = "https://twitter.com/"
    let instagram = "https://instagram.com/"
    
    //    let fb = "FB"
    //    let yt = "YT"
    //    let tw = "TW"
    //    let ig = "IG"
    
    
    var social = [String]()
    social.append(name)
    social.append(facebook + name)
    social.append(youtube + name)
    social.append(twitter + name)
    social.append(instagram + name)
    
    // Build dictionary
    //    result[fb] = facebook + name
    //    result[yt] = youtube + name
    //    result[tw] = twitter + name
    //    result[ig] = instagram + name
    
    print(social)
    return social
}


