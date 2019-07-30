//
//  FilterVCExtension.swift
//  FawGen
//
//  Created by Erick Olibo on 09/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


// MARK: - Steppers
extension FilterViewController {
    
    /// Initializes the Steppers for the Length and Algo sliders
    public func setupSteppers() {
        for category in SettingCategory.allCases {
            let collection = getStepperCollection(for: category)
            let minMax = getStepperMinMaxValue(for: category)
            let stepper = getStepper(for: category)
            stepper.textCollection = collection
            stepper.minimumValue = minMax[0]
            stepper.maximumValue = minMax[1]
            switch category {
            case .length:
                stepper.value = dataBaseManager.lengthValue
            case .algo:
                stepper.value = dataBaseManager.algoValue
            }
            enabledStatus(for: stepper)
        }
    }
    
    /// Saves to local UserDefault database the current values for
    /// each stepper.
    public func saveSteppersValues() {
        for stepper in steppers {
            let currentValue = stepper.value
            switch stepper.tag {
            case 1:
                dataBaseManager.lengthValue = currentValue
            case 2:
                dataBaseManager.algoValue = currentValue
            default:
                break
            }
        }
    }
    
    /// Gets the stepper of the right setting category from the outlet
    /// collection of steppers
    /// - Parameter category: a SettingCategory enum case
    /// - Returns: the right TEOStepper from the collection of steppers
    private func getStepper(for category: SettingCategory) -> TEOStepper {
        return steppers.filter{ $0.tag == category.rawValue }[0]
    }
    
    
    /// Gets the right collection [Double : String] in order to set the right
    /// steppers label for the length or algo
    /// - Parameter category: a SettingCategory enum case
    /// - Returns: the right collection [Double : String] for Stepper setup
    private func getStepperCollection(for category: SettingCategory) -> [Double : String] {
        let lengthCollection: [Double : String] = [6 : "6 letters", 7 : "7 letters", 8 : "8 letters", 9 : "9 letters", 10 : "10 letters", 11 : "11 letters", 12 : "12 letters", 13 : "13 letters", 14 : "14 letters", 15 : "15 letters", 16 : "16 letters" ]
        let algoCollection: [Double : String] = [1 : "swaps", 2 : "subs", 3 : "concat", 4 : "chains", 5 : "flavor"]
        switch category {
        case .length:
            return lengthCollection
        case .algo:
            return algoCollection
        }
    }
    
    /// Get the right minValue and maxValue in order to set up the right stepper
    /// boundaries values
    /// - Parameter category: a SettingCategory enum case
    /// - Returns: the min and max as array.
    private func getStepperMinMaxValue(for category: SettingCategory) -> [Double] {
        switch category {
        case .length:
            return [6, 16]
        case .algo:
            return [1, 5]
        }
    }
}


// MARK: - ON OFF Buttons
extension FilterViewController {
    
    /// Initializes the On Off buttons and their current status
    public func setupOnOffs() {
        for category in SettingCategory.allCases { setupOnOff(for: category) }
    }
    
    
    /// Initializes the OnOff buttons and prepare them to appear
    /// with the right status
    /// - Parameter category: a SettingCategory enum case
    private func setupOnOff(for category: SettingCategory) {
        var button = UIButton()
        switch category {
        case .length:
            button = getOnOffButton(for: .length)
        case .algo:
            button = getOnOffButton(for: .algo)
        }
        button.contentHorizontalAlignment = .center
        let status = currentOnOffStatus(for: button)
        updateOnOff(for: button, with: status)
    }
    
    /// Keep the OnOff Steppers indicators in sync with the UserDefault
    /// database. Enables or disables the touch actions and the visibility
    /// of the Button
    /// - Parameter stepper: a stepper from the Steppers collection
    private func enabledStatus(for stepper: TEOStepper) {
        var onOffIsEnabled = false
        switch stepper.tag {
        case 1:
            onOffIsEnabled = dataBaseManager.lengthStatus
        case 2:
            onOffIsEnabled = dataBaseManager.algoStatus
        default:
            break
        }
        
        stepper.isEnabled = onOffIsEnabled
        stepper.labelBackgroundColor = onOffIsEnabled ? FawGenColors.primary.color : .darkGray
        stepper.buttonsBackgroundColor = onOffIsEnabled ? FawGenColors.primaryDark.color : .darkGray
        stepper.limitHitAnimationColor = onOffIsEnabled ? FawGenColors.primary.color : .gray
        stepper.buttonsTextColor = onOffIsEnabled ? .white : .clear
        stepper.labelTextColor = onOffIsEnabled ? .white : .clear
        
    }
    
    /// Gets the button of the right setting category from the outlet
    /// collection of onOffs (UIButton)
    /// - Parameter category: a SettingCategory enum case
    /// - Returns: the right OnOff UIButton from the collection of buttons
    private func getOnOffButton(for category: SettingCategory) -> UIButton {
        return onOffs.filter{ $0.tag == category.rawValue }[0]
    }
    
    
    /// Returns the current OnOff status, as Bool, for the button that was tapped
    /// - Parameter sender: UIButton from OnOffs button collection
    private func currentOnOffStatus(for sender: UIButton) -> Bool {
        switch sender.tag {
        case 1:
            return dataBaseManager.lengthStatus
        case 2:
            return dataBaseManager.algoStatus
        default:
            break
        }
        return false
    }
    
    
    /// Switches between ON and OFF for the button that was touched
    /// - Parameter sender: UIButton from OnOffs button collection
    public func switchOnOff(for sender: UIButton) {
        let status = currentOnOffStatus(for: sender)
        var stepper = TEOStepper()
        switch sender.tag {
        case 1:
            dataBaseManager.lengthStatus = !status
            stepper = getStepper(for: .length)
        case 2:
            dataBaseManager.algoStatus = !status
            stepper = getStepper(for: .algo)
        default:
            break
        }
        enabledStatus(for: stepper)
        updateOnOff(for: sender, with: !status)
    }
    
    /// updates the OnOff button to a chosen status Bool
    /// - Parameters:
    ///     - sender: UIButton from OnOffs button collection
    ///     - status: update the OnOff button to rather On or Off
    private func updateOnOff(for sender: UIButton, with status: Bool) {
        let normal = ""
        let isOn = status ? "On" : "Off"
        let attributedLength = NSMutableAttributedString(string: normal)
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 22)]
        let attributedBold = NSMutableAttributedString(string: isOn, attributes: attrs)
        attributedLength.append(attributedBold)
        if status {
            sender.setAttributedTitle(attributedLength, for: .normal)
            sender.titleLabel?.textColor = .white
            sender.backgroundColor = FawGenColors.primary.color
        } else {
            sender.setAttributedTitle(attributedLength, for: .normal)
            sender.titleLabel?.textColor = .white
            sender.backgroundColor = .darkGray
        }
    }
}


// MARK: - Close Button
extension FilterViewController {
    /// Sets up the close Button and its attributes
    public func setupCloseButton() {
        closeButton.sizeToFit()
        closeButton.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        closeButton.frame = CGRect(x: view.bounds.width - 50, y: 20, width: 30, height: 30)
        view.addSubview(closeButton)
    }
    
    @objc private func tapCloseButton() {
        saveSteppersValues()
        self.dismiss(animated: true, completion: nil)
    }
}

