//
//  ViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 28/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var socialViewTwo: MySocialView!
    @IBOutlet weak var socialView: MySocialView!
    @IBOutlet weak var socialViewThree: MySocialView!
    
    // SocialView outlets
    @IBOutlet weak var socialOne: SocialView! {
        didSet {
            print("Social One is Set")
            socialOne.initialize(SocialNetwork.youtube.info, status: .normal)
        }
    }
    @IBOutlet weak var socialTwo: SocialView! {
        didSet {
            print("Social Two is Set")
            socialTwo.initialize(SocialNetwork.slack.info, status: .available)
        }
    }
    @IBOutlet weak var socialThree: SocialView! {
        didSet {
            print("Social Three is Set")
            socialThree.initialize(SocialNetwork.vimeo.info, status: .taken)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the social view for 3 items
        
        print("-> One")
        
        print("-> Two")
        
        print("-> Three")

        
        
        
    }
    



}

