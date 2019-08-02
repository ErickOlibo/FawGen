//
//  FilterViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 08/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    public var delegate: FilterViewControllerDelegate?
    public let closeButton = SPLarkSettingsCloseButton()
    public var dataBaseManager = DefaultDB()
    public enum SettingCategory: Int, CaseIterable, Equatable, Hashable {
        case length = 1, algo
    }
    
    @IBOutlet var steppers: [TEOStepper]!
    @IBOutlet var onOffs: [UIButton]!
    
    @IBAction func tappedOnOff(_ sender: UIButton) {
        sender.pulse()
        switchOnOff(for: sender)
    }
    
    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCloseButton()
        setupSteppers()
        setupOnOffs()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveSteppersValues()
        //delegate?.filterViewControllerWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.filterViewControllerDidDisappear()
    }
    
}

protocol FilterViewControllerDelegate {
    //func filterViewControllerWillDisappear()
    func filterViewControllerDidDisappear()
}
