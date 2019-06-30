//
//  CheckerVC+URLsRequests.swift
//  FawGen
//
//  Created by Erick Olibo on 30/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


// Domain Extensions and Social Networks availability request
extension CheckerViewController {
    
    public func getDomainExtensionsAvailability() {
        let orderedDomainViews = domainViews.sorted{ $0.tag < $1.tag }
        var domainViews = [DomainExtension : DomainView]()
        for (idx, domainView) in orderedDomainViews.enumerated() {
            let ext = DomainExtension.allCases[idx]
            domainViews[ext] = domainView
        }
        let domainName = userEnteredWord.lowercased()
        let whoisQueryURLs = DomainChecker().whoisURLs(for: domainName, completeList: true)
        
        for (ext, queryURL) in whoisQueryURLs {
            guard let domainView = domainViews[ext] else { continue }
            guard let url = URL(string: queryURL) else {
                domainView.status = .unknown
                continue
            }
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if (error == nil) {
                    
                    if let result = String(data: data!, encoding: String.Encoding.utf8) {
                        DispatchQueue.main.async {
                            let comp = result.components(separatedBy: ", ")
                            if comp.count == 2 {
                                print("RESULT: \(comp[0]) - tag: \(domainView.tag)")
                                switch comp[1] {
                                case "AVAILABLE":
                                    domainView.status = .available
                                case "TAKEN":
                                    domainView.status = .taken
                                default:
                                    domainView.status = .unknown
                                }
                                //domainView.status = (comp[1] == "AVAILABLE") ? .available : .taken
                            }
                            print("tag[\(domainView.tag)] - Ext: \(ext.description) - Response: \(result)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            domainView.status = .unknown
                            print("Data failed to parse!)")
                        }
                    }
                } else {
                    domainView.status = .unknown
                    print("Error: \(String(describing: error))")
                }
            }
            task.resume()
        }
    }
    
    // New function
    public func getSocialNetworksAvailability() {
        let orderedSocialViews = socialViews.sorted{ $0.tag < $1.tag }
        var socialNetViews = [SocialNetwork : SocialView]()
        for (idx, socialView) in orderedSocialViews.enumerated() {
            let net = SocialNetwork.allCases[idx]
            socialNetViews[net] = socialView
        }
        let handle = userEnteredWord.lowercased()
        let socialURLs = socialNetworkURLs(for: handle, completeList: true)
        
        for (social, link) in socialURLs {
            guard let socialView = socialNetViews[social] else { continue }
            guard let url = URL(string: link) else {
                socialView.status = .unknown
                continue
            }
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    DispatchQueue.main.async {
                        let name = socialView.socialInfo?.name
                        print("Social: \(name ?? "N/A") - Response: \(httpResponse.statusCode)")
                        switch httpResponse.statusCode {
                        case 404:
                            socialView.status = .available
                        case 200:
                            socialView.status = .taken
                        default:
                            socialView.status = .unknown
                        }
                        //socialView.status = httpResponse.statusCode == 404 ? .available : .taken
                    }
                } else {
                    DispatchQueue.main.async { socialView.status = .unknown }
                }
            }
            task.resume()
        }
        
    }
    
}
