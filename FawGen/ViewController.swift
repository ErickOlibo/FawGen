//
//  ViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 28/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // Font testing and random font Outlets
    @IBOutlet weak var randomFontLabel: UILabel!
    
    @IBAction func selectNewFont(_ sender: UIButton) {
        updateUItext()
    }
    
    
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
    
    @IBOutlet weak var randomColorView: GradientView!
    
    
    private let generator = ColorGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getSocialNetworkAvailability()
//        domainAvailability()
//        let fontLister = FontsLister()
//        fontLister.printListToConsole()
        
        
    }
    
    private func getNewFontName() -> String? {
        let fontLister = FontsLister()
        return fontLister.randomFont()
    }
    
    private func updateUItext() {
        // reset all the views
        resetAvailabilityViews()
        let randFont = getNewFontName() ?? "Avenir-Medium"
        print("FontName: \(randFont)")
        randomFontLabel.font = UIFont(name: randFont, size: 400)
        let rndWord = Constants.fakeWords.randomElement() ?? "Failed!"
        randomFontLabel.text = rndWord.capitalized
        randomFontLabel.fitTextToBounds()
        getDomainAvailability(for: rndWord)
        getSocialNetworkAvailability(for: rndWord)
        randomColorView.randomGradient()
        randomFontLabel.backgroundColor = generator.randomColor()
        
    }
    
    private func resetAvailabilityViews() {
        socialOne.status = .normal
        socialTwo.status = .normal
        socialThree.status = .normal
        socialFour.status = .normal
        
        domainOne.status = .normal
        domainTwo.status = .normal
        domainThree.status = .normal
        domainFour.status = .normal
        
        print("Social: \(socialOne.bounds) - Domain: \(domainOne.bounds)")
    
    }
    
    // Get Social Network Availability
    private func getSocialNetworkAvailability(for username: String) {
        // Dictionary of SocialNetwork to their socialView
        let socialNetViews = [SocialNetwork.facebook : socialOne,
                              SocialNetwork.youtube : socialTwo,
                              SocialNetwork.twitter : socialThree,
                              SocialNetwork.instagram : socialFour]
        
        let handle = username.lowercased()
        let socialURLs = socialNetworkURLs(for: handle, completeList: false)
        
        for (social, link) in socialURLs {
            print("Link: \(link)")
            guard let socialV = socialNetViews[social]  else { print("SocialV failed"); continue }
            guard let socialView = socialV else { print("SocialView failed"); continue }
            guard let url = URL(string: link) else {
                socialView.status = .taken
                print("URL failed");
                continue
            }
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let httpResponse = response as? HTTPURLResponse {
                    DispatchQueue.main.async {
                        socialView.status = httpResponse.statusCode == 404 ? .available : .taken
                    }
                } else {
                    DispatchQueue.main.async {
                        socialView.status = .taken
                    }
                }
            }
            task.resume()
        }
    }
    

    // Testing the construction of URL
    private func queryWhois(for domain: Domain) {
        let whoisAPI = WhoisAPI()
        
        for ext in DomainExtension.simpleCollection {
            let urlQuery = whoisAPI.createURL(domain, extension: ext)
            print(urlQuery)
        }
    }
    
    // Testing the Domain checker
    private func getDomainAvailability(for domain: Domain) {
        let domainViews = [DomainExtension.com : domainOne,
                           DomainExtension.net : domainTwo,
                           DomainExtension.org : domainThree,
                           DomainExtension.co : domainFour]
        let domainName: Domain = domain.lowercased()
        let whoisQueryURLS = DomainChecker().whoisURLs(for: domainName, completeList: false)
        
        for (ext, queryURL) in whoisQueryURLS {
            guard let domainV = domainViews[ext] else { print("DomainV failed"); continue }
            guard let domainView = domainV else { print("DomainView Failed"); continue }
            guard let url = URL(string: queryURL) else {
                domainView.status = .taken
                print("URL Failed")
                continue
            }
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if (error == nil) {
                    
                    if let result = String(data: data!, encoding: String.Encoding.utf8) {
                        DispatchQueue.main.async {
                            // handle result
                            let comp = result.components(separatedBy: ", ")
                            if comp.count == 2 {
                                domainView.status = (comp[1] == "AVAILABLE") ? .available : .taken
                            }
                            print("Ext: \(ext.description) - Response: \(result)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            domainView.status = .taken
                            print("Data failed to parse!)")
                        }
                    }
                } else {
                    domainView.status = .taken
                    print("Error: \(String(describing: error))")
                }
            }
            task.resume()
        }
    }


    

}

