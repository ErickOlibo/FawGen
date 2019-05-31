//
//  ViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 28/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // SocialViews Outlets
    @IBOutlet weak var socialOne: SocialView! {
        didSet { socialOne.initialize(SocialNetwork.facebook.info) }
    }
    @IBOutlet weak var socialTwo: SocialView! {
        didSet { socialTwo.initialize(SocialNetwork.youtube.info) }
    }
    @IBOutlet weak var socialThree: SocialView! {
        didSet { socialThree.initialize(SocialNetwork.twitter.info) }
    }
    @IBOutlet weak var socialFour: SocialView! {
        didSet { socialFour.initialize(SocialNetwork.instagram.info) }
    }
    
    // DomainViews Outlets
    @IBOutlet weak var domainOne: DomainView! {
        didSet { domainOne.initialize(DomainExtension.com) }
    }
    @IBOutlet weak var domainTwo: DomainView!{
        didSet { domainTwo.initialize(DomainExtension.net) }
    }
    @IBOutlet weak var domainThree: DomainView!{
        didSet { domainThree.initialize(DomainExtension.org) }
    }
    @IBOutlet weak var domainFour: DomainView!{
        didSet { domainFour.initialize(DomainExtension.co) }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getSocialNetworkAvailability()
        
    }
    
    // Get Social Network Availability
    private func getSocialNetworkAvailability() {
        // Dictionary of SocialNetwork to their socialView
        let socialNetViews = [SocialNetwork.facebook : socialOne,
                              SocialNetwork.youtube : socialTwo,
                              SocialNetwork.twitter : socialThree,
                              SocialNetwork.instagram : socialFour]
        
        let username = "sweetlove"
        let socialURLs = socialNetworkURLs(for: username, completeList: false)
        
        for (social, link) in socialURLs {
            print("Link: \(link)")
            guard let socialV = socialNetViews[social]  else { print("SocialV failed"); continue }
            guard let socialView = socialV else { print("SocialView failed"); continue }
            guard let url = URL(string: link) else {
                socialView.currentStatus = .taken
                print("URL failed");
                continue
            }
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let httpResponse = response as? HTTPURLResponse {
                    DispatchQueue.main.async {
                        socialView.currentStatus = httpResponse.statusCode == 404 ? .available : .taken
                    }
                } else {
                    DispatchQueue.main.async {
                        socialView.currentStatus = .taken
                    }
                }
            }
            task.resume()
        }
    }
    



}

