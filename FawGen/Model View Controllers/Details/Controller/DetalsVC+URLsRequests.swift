//
//  DetalsVC+URLsRequests.swift
//  FawGen
//
//  Created by Erick Olibo on 01/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


extension DetailsViewController {
    
    public func getDomainExtensionsAvailability() {
        let domainGroup = DispatchGroup()
        let orderedDomainViews = domainViews.sorted{ $0.tag < $1.tag }
        var domainViews = [DomainExtension : DomainView]()
        for (idx, domainView) in orderedDomainViews.enumerated() {
            let ext = DomainExtension.allCases[idx]
            domainViews[ext] = domainView
        }
        let domainName = fakeWord.name.lowercased()
        let whoisQueryURLs = DomainChecker().whoisURLs(for: domainName, completeList: true)
        
        for (ext, queryURL) in whoisQueryURLs {
            domainGroup.enter()
            guard let domainView = domainViews[ext] else { continue }
            guard let url = URL(string: queryURL) else {
                domainView.status = .unknown
                continue
            }
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request) { (data, response, error) in
                if (error == nil) {
                    
                    if let result = String(data: data!, encoding: String.Encoding.utf8) {
                        DispatchQueue.main.async {
                            let comp = result.components(separatedBy: ", ")
                            if comp.count == 2 {
                                switch comp[1] {
                                case "AVAILABLE":
                                    domainView.status = .available
                                case "TAKEN":
                                    domainView.status = .taken
                                default:
                                    domainView.status = .unknown
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            domainView.status = .unknown
                        }
                    }
                } else {
                    domainView.status = .unknown
                    print("Error: \(String(describing: error))")
                }
                domainGroup.leave()
            }
            task.resume()
        }
        domainGroup.notify(queue: .main) {
            print("DOMAIN Lookup DONE!")

        }
    }
    
    
    public func getSocialNetworksAvailability() {
        let socialGroup = DispatchGroup()
        let orderedSocialViews = socialViews.sorted{ $0.tag < $1.tag }
        var socialNetViews = [SocialNetwork : SocialView]()
        for (idx, socialView) in orderedSocialViews.enumerated() {
            let net = SocialNetwork.allCases[idx]
            socialNetViews[net] = socialView
        }
        let handle = fakeWord.name.lowercased()
        let socialURLs = socialNetworkURLs(for: handle, completeList: true)
        
        for (social, link) in socialURLs {
            socialGroup.enter()
            guard let socialView = socialNetViews[social] else { continue }
            guard let url = URL(string: link) else {
                socialView.status = .unknown
                continue
            }
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    DispatchQueue.main.async {
                        
                        switch httpResponse.statusCode {
                        case 404:
                            socialView.status = .available
                        case 200:
                            socialView.status = .taken
                        default:
                            socialView.status = .unknown
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        socialView.status = .unknown
                    }
                }
                socialGroup.leave()
            }
            task.resume()
        }
        socialGroup.notify(queue: .main) {
            print("SOCIAL Lookup DONE!")

        }
        
    }
    
}
