//
//  RandomizeCell.swift
//  FawGen
//
//  Created by Erick Olibo on 03/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class FakeWordCell: UITableViewCell {
    
    // Properties
    let newLine = "\n"
    let root = "Root: "
    let algo = "Algo: "
    
    enum CellState {
        case closed
        case opened
        
        var carretImage: UIImage {
            switch self {
            case .closed:
                return #imageLiteral(resourceName: "collapse")
            case .opened:
                return #imageLiteral(resourceName: "expand")
            }
        }
    }
    
    private enum DomainTag: Int {
        case com = 1, net, org, co
    }
    private enum SocialTag: Int {
        case facebook = 1, youtube, twitter, instagram
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
    @IBOutlet private var cellSocialViews: [CellSocialView]!
    @IBOutlet private var cellDomainViews: [CellDomainView]!
    
    // DomainViews and SocialViews horizontal spacing constraints
    @IBOutlet weak var rootTextLabelHeight: NSLayoutConstraint!
    
    
    
    
    // MARK: - Properties
    private let openedViewIndex: Int = 1
    var state: CellState = .closed { didSet { toggle() } }
    private(set) var currentFakeword = FakeWord()
    private(set) var orderedSocialViews = [CellSocialView]()
    private(set) var orderedDomainViews = [CellDomainView]()
    
    
    

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
        orderedSocialViews = cellSocialViews.sorted{ $0.tag < $1.tag }
        orderedDomainViews = cellDomainViews.sorted{ $0.tag < $1.tag }

        for idx in 0..<4 {
            switch idx {
            case 0:
                orderedSocialViews[idx].initialize(SocialNetwork.facebook.info)
                orderedDomainViews[idx].initialize(DomainExtension.com)
            case 1:
                orderedSocialViews[idx].initialize(SocialNetwork.youtube.info)
                orderedDomainViews[idx].initialize(DomainExtension.net)
            case 2:
                orderedSocialViews[idx].initialize(SocialNetwork.twitter.info)
                orderedDomainViews[idx].initialize(DomainExtension.org)
            case 3:
                orderedSocialViews[idx].initialize(SocialNetwork.instagram.info)
                orderedDomainViews[idx].initialize(DomainExtension.co)
            default:
                break
            }
        }
    }
    
    private func toggleSave() {
        currentFakeword.isSaved = !currentFakeword.isSaved
        updateSave()
    }
    
    private func setupSave() {
        saveWordButton.layer.cornerRadius = 15
        updateSave()
    }
    
    private func updateSave() {
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
        let attributedRootText = formatRootText()
        rootTextLabel.attributedText = attributedRootText
        rootTextLabelHeight.constant = heightForRootLabel()
        
    }
    
    private func formatRootText() -> NSMutableAttributedString {
        let rootText = NSMutableAttributedString(string: currentFakeword.madeUpRoots)
        let algoType = NSAttributedString(string: currentFakeword.madeUpType.rawValue)
        let fontSize = rootTextLabel.font.pointSize
        guard let boldFont = UIFont(name: "AvenirNext-Bold", size: fontSize) else { return rootText }
        rootText.append(NSAttributedString(string: newLine))
        let attrs = [NSAttributedString.Key.font : boldFont]
        let attrsRoot = NSMutableAttributedString(string: root, attributes: attrs)
        let attrsAlgo = NSMutableAttributedString(string: algo, attributes: attrs)
        
        attrsRoot.append(rootText)
        attrsRoot.append(attrsAlgo)
        attrsRoot.append(algoType)
        return attrsRoot
    }
    
    private func heightForRootLabel() -> CGFloat {
        guard let rootFont = rootTextLabel.font else { return 0.0 }
        guard let attrText = rootTextLabel.attributedText?.string else { return 0.0 }
        let rootWidth = rootTextLabel.bounds.width
        let frame = CGRect(x: 0, y: 0, width: rootWidth, height: CGFloat.greatestFiniteMagnitude)
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.font = rootFont
        label.text = attrText
        label.sizeToFit()
        return label.frame.height
    }
    
    private func toggle() {
        stackView.arrangedSubviews[openedViewIndex].isHidden = stateIsClosed()
        carret.image = state.carretImage
    }
    
    private func stateIsClosed() -> Bool {
        return state == .closed
    }
    
    
    public func queryDomainSocialChecker() {
        getSocialNetworkAvailability()
        getDomainExtensionAvailability()
    }
    
    public func cancelQueryDomainSocialChecker() {
        
        print("NEED TO CANCEL THE QUERY")
    }
    
    
    private func getSocialNetworkAvailability() {
        let socialOne = cellSocialViews.filter{ $0.tag == 1 }[0]
        let socialTwo = cellSocialViews.filter{ $0.tag == 2 }[0]
        let socialThree = cellSocialViews.filter{ $0.tag == 3 }[0]
        let socialFour = cellSocialViews.filter{ $0.tag == 4 }[0]
        
        let socialNetViews = [SocialNetwork.facebook : socialOne,
                              SocialNetwork.youtube : socialTwo,
                              SocialNetwork.twitter : socialThree,
                              SocialNetwork.instagram : socialFour]
        
        let handle = currentFakeword.name.lowercased()
        let socialURLs = socialNetworkURLs(for: handle, completeList: false)

        for (social, link) in socialURLs {
            print("Link: \(link)")
            guard let socialView = socialNetViews[social] else { continue }
            guard let url = URL(string: link) else {
                socialView.status = .taken
                continue
            }
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    DispatchQueue.main.async {
                        socialView.status = httpResponse.statusCode == 404 ? .available : .taken
                    }
                } else {
                    DispatchQueue.main.async { socialView.status = .taken }
                }
            }
            task.resume()
        }
    }
    
    private func getDomainExtensionAvailability() {
        let domainOne = cellDomainViews.filter{ $0.tag == 1 }[0]
        let domainTwo = cellDomainViews.filter{ $0.tag == 2 }[0]
        let domainThree = cellDomainViews.filter{ $0.tag == 3 }[0]
        let domainFour = cellDomainViews.filter{ $0.tag == 4 }[0]
        
        let domainViews = [DomainExtension.com : domainOne,
                           DomainExtension.net : domainTwo,
                           DomainExtension.org : domainThree,
                           DomainExtension.co : domainFour ]
        let domainName = currentFakeword.name.lowercased()
        let whoisQueryURLS = DomainChecker().whoisURLs(for: domainName, completeList: false)
        
        for (ext, queryURL) in whoisQueryURLS {
            guard let domainView = domainViews[ext] else { continue }
            guard let url = URL(string: queryURL) else {
                domainView.status = .taken
                print("URL Failed")
                continue
            }
            
            print("[\(ext.rawValue)] - tag[\(domainView.tag)] - WhoIs URL: \(queryURL)")
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if (error == nil) {
                    
                    if let result = String(data: data!, encoding: String.Encoding.utf8) {
                        DispatchQueue.main.async {
                            let comp = result.components(separatedBy: ", ")
                            if comp.count == 2 {
                                print("RESULT: \(comp[0]) - tag: \(domainView.tag)")
                                domainView.status = (comp[1] == "AVAILABLE") ? .available : .taken
                            }
                            print("tag[\(domainView.tag)] - Ext: \(ext.description) - Response: \(result)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            domainView.status = .taken
                            print("Data failed to parse!)")
                        }
                    }
                } else {
                    domainView.status = .taken
                    print("Error: \(String(describing: error))")
                }
            }
            task.resume()
            
        }
    }
    
    
    
}
