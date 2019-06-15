//
//  RandomizeCell.swift
//  FawGen
//
//  Created by Erick Olibo on 03/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class FakeWordCell: UITableViewCell {
    
    enum CellState {
        case collapsed
        case expanded
        
        var carretImage: UIImage {
            switch self {
            case .collapsed:
                return #imageLiteral(resourceName: "collapse")
            case .expanded:
                return #imageLiteral(resourceName: "expand")
            }
        }
    }

    // MARK: - Outlets
    // Container and Stack
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    
    
    
    
    
    // Top View
    @IBOutlet private weak var designBar: UIView!
    @IBOutlet private weak var madeUpLogo: UIImageView!
    @IBOutlet private weak var fakeWordLabel: UILabel!
    @IBOutlet private weak var carret: UIImageView!
    @IBOutlet private weak var saveWordButton: UIButton!
    @IBOutlet private weak var detailedReportButton: UIButton!
    @IBOutlet private weak var textToSpeechButton: UIButton!
    
    // Bottom View
    @IBOutlet private weak var fakeWordRootLabel: UILabel!
    @IBOutlet private var socialViews: [SocialView]!
    @IBOutlet private var domainViews: [DomainView]!
    
    // MARK: - Properties
    private let expandedViewIndex: Int = 1
    var state: CellState = .collapsed { didSet { toggle() } }
    private(set) var currentFakeword: FakeWord?
    
    
    

    
    
    // MARK: - Actions
    @IBAction func tappedSave(_ sender: UIButton) {
        print("Save Fake Word")
    }
    @IBAction func tappedDetailedReport(_ sender: UIButton) {
        print("Show Detailed Report")
    }
    @IBAction func tappedTextToSpeech(_ sender: UIButton) {
        print("Speak the fake word in English")
    }
    
    

    // MARK: - Others
    override func awakeFromNib() {
        //super.awakeFromNib()
        selectionStyle = .none
        containerView.layer.cornerRadius = 5.0
    }
    
    public func update(data: FakeWord) {
        currentFakeword = data
        
        // Setup the cell
        
        
    }
    
    private func toggle() {

    }
    
    private func stateIsCollapsed() -> Bool {
        return state == .collapsed
    }
    
}
