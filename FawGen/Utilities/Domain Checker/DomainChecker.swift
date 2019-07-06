//
//  DomainChecker.swift
//  FawGen
//
//  Created by Erick Olibo on 31/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation



/// Instantiate a class that allows to query the whois site for domain name
/// and the extensions.
/// - Note: There are 2 public methods available:
///     - whoisURLs: Checks a domain name with complete or simple extension type
///     - whoisURL: Cheks a single domain name and extension.
public class DomainChecker {
    
    private let whoisAPI = WhoisAPI()
    
    /// Checks a domain name for its availability from the whois server on defkut.com
    /// - Parameters:
    ///     - domain: The domain name to query without its extension
    ///     - completeList: Rather or not it should be the complete list of extensions
    /// or the simple list
    /// - Returns: a dictionary of the extension to the whoisURL query link
    public func whoisURLs(for domain: String, completeList: Bool = true) -> [DomainExtension : String] {
        var urlsCollection = [DomainExtension : String]()
        let lowDomain = domain.lowercased()
        
        for ext in complete {
            urlsCollection[ext] = whoisAPI.createURL(lowDomain, extension: ext)
        }
        return completeList ? urlsCollection : urlsCollection.filter{ simple.contains($0.key) }
    }
    
    /// Checks a domain name for its availability from the whois server on defkut.com
    /// - Parameters:
    ///     - domain: The domain name to query without its extension
    ///     - extension: the particular TLD extension to use
    /// - Returns: the whoisURL query to use against the whois server
    public func whoisURL(for domain: String, extension ext: DomainExtension) -> String {
        let lowDomain = domain.lowercased()
        return whoisAPI.createURL(lowDomain, extension: ext)
    }
    
    
}

/// List of all domain extensions chosen for this FawGen app to be run against
/// the whois server set on defkut.com.
public enum DomainExtension: String, CustomStringConvertible, CaseIterable, Equatable, Hashable {
    case com, net, org, co, io, ai, couk, eu, info, app, biz, me, be, xyz, tech
    
    public var description: String {
        return self.rawValue
    }
    
    /// The simple collection comprise 4 main domain extensions and
    /// the list is: .com, .net, .org, .co
    public static var simpleCollection: [DomainExtension] {
        return simple
    }
    
    /// The complete collection comprise 16 domain extensions and
    /// the list is: com, net, org, co, io, ai, couk, eu, info,
    /// app, biz, me, be, xyz, tech, club
    public static var completeCollection: [DomainExtension] {
        return complete
    }
}


private var simple: [DomainExtension] {
    return [.com, .net, .org, .co]
}

private var complete: [DomainExtension] {
    return DomainExtension.allCases
}


//private func domainExtensionURLs(for name: String, completeList: Bool = true) -> [DomainExtension : String] {
//    var urlsCollection = [DomainExtension : String]()
//    let domain = name.lowercased()
//    let dot = "."
//    for item in complete {
//        switch item {
//        case .couk:
//            urlsCollection[item] = domain + ".co.uk"
//        default:
//            urlsCollection[item] = domain + dot + item.rawValue
//        }
//    }
//    return completeList ? urlsCollection : urlsCollection.filter{ simple.contains($0.key) }
//}



