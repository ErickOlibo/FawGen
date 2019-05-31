//
//  DomainChecker.swift
//  FawGen
//
//  Created by Erick Olibo on 31/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation



public class DomainChecker {
    
    
    
    
}

public enum DomainExtension: String, CustomStringConvertible, CaseIterable, Equatable, Hashable {
    case com, net, org, co, io, ai, couk, eu, app, biz, me, info, xyz, tech, name, mobi
    
    public var description: String {
        return self.rawValue
    }
}

private var simple: [DomainExtension] {
    return [.com, .net, .org, .co]
}

private var complete: [DomainExtension] {
    return DomainExtension.allCases
}


public func domainExtensionURLs(for name: String, completeList: Bool = true) -> [DomainExtension : String] {
    var urlsCollection = [DomainExtension : String]()
    let domain = name.lowercased()
    let dot = "."
    for item in complete {
        switch item {
        case .couk:
            urlsCollection[item] = domain + ".co.uk"
        default:
            urlsCollection[item] = domain + dot + item.rawValue
        }
    }
    return completeList ? urlsCollection : urlsCollection.filter{ simple.contains($0.key) }
}
