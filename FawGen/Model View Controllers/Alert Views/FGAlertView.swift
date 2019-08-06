//
//  FGAlertView.swift
//  FawGen
//
//  Created by Erick Olibo on 31/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

protocol AlertViewDelegate {
    func tappedButton(for state: AlertState)
}

class FGAlertView: UIView {

    
    // MARK: - Properties
    public var delegate: AlertViewDelegate?
    private(set) var view: UIView!
    private(set) var homeImage: UIImage!
    private var currentState: AlertState!
    
    
    // MARK: - Outlets
    @IBOutlet weak var alertTextView: UIView!
    @IBOutlet weak var alertTextLabel: UILabel!
    @IBOutlet weak var alertInfoLabel: UILabel!
    @IBOutlet weak var alertButton: UIButton!
    
    
    // MARK: - Actions
    @IBAction func tappedButton(_ sender: UIButton) {
        delegate?.tappedButton(for: currentState)
        printConsole("tappedButton in FGAlertView")
    }
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitialization()
    }
    
    // MARK: - Public methods
    public func setAlert(for state: AlertState) {
        switch state {
        case .internet:
            currentState = .internet
            setAlertForNoInternet()
            printConsole("NO INTERNET!")
        case .results:
            currentState = .results
            setAlertForNoResults()
            printConsole("NO RESULTS!")
        }
    }
    
    // MARK: - Private methods
    private func commonInitialization() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight]
        
        view.addSubview(alertTextView)
        view.addSubview(alertTextLabel)
        view.addSubview(alertInfoLabel)
        view.addSubview(alertButton)
//        view.layer.cornerRadius = 10
        self.view = view
        self.addSubview(view)
    }
    
    
    private func setAlertForNoInternet() {
        alertTextLabel.text = "No Internet!"
        alertInfoLabel.text = "This action requires an Internet connection."
        alertButton.setTitle("Cancel", for: .normal)
    }
    
    private func setAlertForNoResults() {
        alertTextLabel.text = "No Results!"
        alertInfoLabel.text = "The Engine couldn't generate new words. Change the filters or keywords and try again!"
        alertButton.setTitle("", for: .normal)
        if let buttonImage = UIImage(named: "BackHome") {
            alertButton.setImage(buttonImage, for: .normal)
        }
    }
    
}

// MARK: - Alert state
public enum AlertState: String {
    case internet, results
}
