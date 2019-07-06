//
//  WhoisAPI.swift
//  FawGen
//
//  Created by Erick Olibo on 31/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

public class WhoisAPI {
    
    /// creates the proper URL to query the Whois Server located at Defkut.com
    /// - Parameters:
    ///     - domain: This is the domain name only without the extension
    ///     - extension: The domain extension to check for availability
    public func createURL(_ domain: String, extension ext: DomainExtension) -> String {
        let lowDomain = domain.lowercased()
        let dot = "."
        let checkedExt = ext == .couk ? "co.uk" : ext.rawValue
        let query = "domain=" + lowDomain + dot + checkedExt
        let key = "key=" + Credentials.key
        let token = "token=" + Credentials.token
        let amp = "&"
        return WhoisServer.address + query + amp + key + amp + token
    }
}


private struct Credentials {
    static let key = "YQbVYWEU6Mcpe2dsxY8b2c"
    static let token = "3mM44UYhwX4D53_YQbRpn6b7rCmvkMrwHLt52"
}


private struct WhoisServer {
    static let address = "https://fawgen.com/FawGenWhois/SearchDomain/simpleQuery.php?"
}


