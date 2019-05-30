//
//  ViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 28/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // SocialView outlets
    @IBOutlet weak var socialOne: SocialView! {
        didSet {
            socialOne.initialize(SocialNetwork.facebook.info, status: .normal)
        }
    }
    @IBOutlet weak var socialTwo: SocialView! {
        didSet {
            socialTwo.initialize(SocialNetwork.youtube.info, status: .normal)
        }
    }
    @IBOutlet weak var socialThree: SocialView! {
        didSet {
            socialThree.initialize(SocialNetwork.twitter.info, status: .normal)
        }
    }
    
    @IBOutlet weak var socialFour: SocialView! {
        didSet {
            socialFour.initialize(SocialNetwork.instagram.info, status: .normal)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    



}

