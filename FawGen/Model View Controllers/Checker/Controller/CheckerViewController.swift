//
//  CheckerViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 28/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class CheckerViewController: UIViewController {
    
    let navBar = SPFakeBarView.init(style: .stork)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationCapturesStatusBarAppearance = true
        view.backgroundColor = .white
        navBar.rightButton.setTitle("Hide", for: .normal)
        navBar.rightButton.setTitleColor(FawGenColors.primary.color)
        navBar.rightButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        navBar.titleLabel.text = "Checker"
        navBar.titleLabel.textColor = FawGenColors.secondary.color
        
        view.addSubview(navBar)
        // Do any additional setup after loading the view.
    }
    

    @objc func hide() {
        dismiss(animated: true, completion: nil)
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
