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
    @IBOutlet weak var topView: UIView!
    @IBOutlet private weak var logoBackground: UIView!
    @IBOutlet private weak var madeUpLogo: UIImageView!
    @IBOutlet private weak var fakeWordLabel: UILabel!
    @IBOutlet private weak var carret: UIImageView!
    @IBOutlet private weak var saveWordButton: UIButton!
    @IBOutlet private weak var detailedReportButton: UIButton!
    @IBOutlet private weak var textToSpeechButton: UIButton!
    
    // Bottom View
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet private weak var rootTextLabel: UILabel!
    @IBOutlet private var socialViews: [CellSocialView]!
    @IBOutlet private var domainViews: [CellDomainView]!
    
    // DomainViews and SocialViews horizontal spacing constraints
    @IBOutlet weak var rootTextLabelHeight: NSLayoutConstraint!
    
    
    
    
    // MARK: - Properties
    private let expandedViewIndex: Int = 1
    var state: CellState = .collapsed { didSet { toggle() } }
    private(set) var currentFakeword = FakeWord()
    
    
    

    // MARK: - Actions
    @IBAction func tappedSave(_ sender: UIButton) {
        print("Save Fake Word")
        sender.pulse()
        toggleSave()
    }
    @IBAction func tappedDetailedReport(_ sender: UIButton) {
        sender.pulse()
        print("Show Detailed Report")
    }
    @IBAction func tappedTextToSpeech(_ sender: UIButton) {
        sender.pulse()
        let tts = TextToSpeech()
        tts.speakFakeWord(currentFakeword.name, accent: .american)
        print("Speak the fake word in English")
    }
    
    

    // MARK: - Others
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupCell()
        setupSave()
        setupSocialDomain()
    }
    
    
    private func setupSocialDomain() {
        let orderdSocial = socialViews.sorted{ $0.tag < $1.tag }
        let orderedDomain = domainViews.sorted{ $0.tag < $1.tag }

        for idx in 0..<4 {
            switch idx {
            case 0:
                orderdSocial[idx].initialize(SocialNetwork.facebook.info)
                orderedDomain[idx].initialize(DomainExtension.com)
            case 1:
                orderdSocial[idx].initialize(SocialNetwork.youtube.info)
                orderedDomain[idx].initialize(DomainExtension.net)
            case 2:
                orderdSocial[idx].initialize(SocialNetwork.twitter.info)
                orderedDomain[idx].initialize(DomainExtension.org)
            case 3:
                orderdSocial[idx].initialize(SocialNetwork.instagram.info)
                orderedDomain[idx].initialize(DomainExtension.co)
            default:
                break
            }
        }
    }
    
    private func toggleSave() {
        currentFakeword.isSaved = !currentFakeword.isSaved
        setupSave()
    }
    
    private func setupSave() {
        if currentFakeword.isSaved {
            saveWordButton.tintColor = .white
            saveWordButton.backgroundColor = FawGenColors.primary.color
        } else {
            saveWordButton.tintColor = .lightGray
            saveWordButton.backgroundColor = .gray
        }
    }
    
    
    private func setupCell() {
        //textToSpeechButton.tintColor = FawGenColors.secondary.color
        //detailedReportButton.tintColor = FawGenColors.secondary.color
        saveWordButton.layer.cornerRadius = 15
    }
    
    public func update(data: FakeWord) {
        currentFakeword = data
        
        // Setup the cell
        logoBackground.backgroundColor = data.designBarColor
        madeUpLogo.image = data.logo
        fakeWordLabel.text = data.name
        rootTextLabel.text = data.madeUpRoots

        // AFTER getting the root, set the contrainst on the TopViewHeight
        guard let rootFont = rootTextLabel.font else { return }
        let width = topView.bounds.width - 10
        
        let height = heightForView(text: data.madeUpRoots, font: rootFont, width: width)
        print("[\(data.name)] - HeightLabels [ \(rootTextLabel.bounds.height) | \(height) ]")
        rootTextLabelHeight.constant = height
        
    }
    
    private func toggle() {
        stackView.arrangedSubviews[expandedViewIndex].isHidden = stateIsCollapsed()
        carret.image = state.carretImage
    }
    
    private func stateIsCollapsed() -> Bool {
        return state == .collapsed
    }
    
    private func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let frame = CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude)
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
}
