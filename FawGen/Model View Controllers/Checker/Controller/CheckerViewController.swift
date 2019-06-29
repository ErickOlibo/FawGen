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
    
    // MARK: - Outlets
    @IBOutlet weak var textField: TextFieldCounter!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var typedWord: UILabel!
    
    
    // MARK: - Actions
    @IBAction func tappedSend(_ sender: UIButton) {
        print("tapped Send")
    }
    
    @IBAction func tappedTextToSpeech(_ sender: UIButton) {
        print("tapped textToSpeech")
    }
    
    @IBAction func tappedSave(_ sender: UIButton) {
        print("tapped Save")
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
        view.backgroundColor = .white
        setupNavBar()
        setupSendButton()
        setupTextfield()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("NavBar Size: \(navBar.bounds)")
    }
    

    @objc func hide() {
        dismiss(animated: true, completion: nil)
    
    }
    
    private func setupTextfield() {
        textField.animate = true
        textField.ascending = true
        textField.maxLength = 16
        textField.counterColor = .gray
        textField.limitColor = FawGenColors.primary.color
        textField.backgroundColor = FawGenColors.cellGray.color
    }
    
    private func setupSendButton() {
        sendButton.layer.cornerRadius = 15.0
        
        // set the state of the button as darken for start but with the number of letter
        
    }
    
    
    private func setupNavBar() {
        navBar.rightButton.setTitle("Hide", for: .normal)
        navBar.rightButton.setTitleColor(FawGenColors.primary.color)
        navBar.rightButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        navBar.titleLabel.text = "Checker"
        navBar.titleLabel.textColor = FawGenColors.secondary.color
        print("NavBar Size: \(navBar.bounds)")
        view.addSubview(navBar)
        print("NavBar Size: \(navBar.bounds)")
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
