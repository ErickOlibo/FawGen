//
//  RandomizeCell.swift
//  FawGen
//
//  Created by Erick Olibo on 03/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class RandomizeCell: UITableViewCell {
    
    // MARK: - Properties
    static var identifier: String { return String(describing: self) }
    private let expandedViewIndex: Int = 1
    
    enum CellState {
        case collapsed
        case expanded
    }
    
    
    // MARK: - Outlets
    @IBOutlet var socialViews: [SocialView]!
    @IBOutlet var domainViews: [DomainView]!
    
    @IBOutlet weak var saveWordButton: UIButton!
    @IBOutlet weak var detailedReportButton: UIButton!
    @IBOutlet weak var textToSpeechButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fakeWordLabel: UILabel!
    @IBOutlet weak var fakeWordRootLabel: UILabel!
    
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var detailsView: UIView!
    
    
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
    var state: CellState = .collapsed {
        didSet{
            toggle()
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        containerView.layer.cornerRadius = 10.0
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    public func update(title: String) {
        fakeWordLabel.text = title
        fakeWordRootLabel.text = "ROOT: \(Date().description)"
    }
    
    private func toggle() {
        stackView.arrangedSubviews[expandedViewIndex].isHidden = stateIsCollapsed()
        topStackView.arrangedSubviews[expandedViewIndex].isHidden = !stateIsCollapsed()
    }
    
    private func stateIsCollapsed() -> Bool {
        return state == .collapsed
    }
    
}
