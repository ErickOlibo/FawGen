//
//  RandomizeCell.swift
//  FawGen
//
//  Created by Erick Olibo on 03/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

protocol FakeWordCellDelegate {
    func didTapShowDetails(fakeWord: FakeWord)
}

class FakeWordCell: UITableViewCell {
    
    // Properties
    //private let newLine = "\n"
    //private let root = "Root: "
    //private let algo = "Algo: "
    private let dataBaseManager = DefaultDB()
    private let reachability = Reachability()
    
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

    // MARK: - Outlets
    // Container and Stack
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    

    // Top View
    @IBOutlet weak var topView: UIView!
    @IBOutlet private weak var madeUpLogo: CustomImageView!
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
    var fakeword: FakeWord! { didSet { update() } }
    var delegate: FakeWordCellDelegate?

    // MARK: - Actions
    @IBAction func tappedSave(_ sender: UIButton) {
        sender.pulse()
        toggleSave()
    }
    
    @IBAction func tappedDetailedReport(_ sender: UIButton) {
        sender.pulse()
        delegate?.didTapShowDetails(fakeWord: fakeword)
    }
    
    @IBAction func tappedTextToSpeech(_ sender: UIButton) {
        sender.pulse()
        let tts = TextToSpeech()
        tts.speakFakeWord(fakeword.name, accent: .american)
    }

    // MARK: - Others
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        saveWordButton.layer.cornerRadius = 15
        setupSocialDomain()
    }
    

    
    /// Sets the default UI for the domainViews and socialViews
    private func setupSocialDomain() {
        let orderedSocialViews = cellSocialViews.sorted{ $0.tag < $1.tag }
        let orderedDomainViews = cellDomainViews.sorted{ $0.tag < $1.tag }
        
        for (idx, socialView) in orderedSocialViews.enumerated() {
            socialView.initialize(SocialNetwork.allCases[idx].info)
        }
        
        for (idx, domainView) in orderedDomainViews.enumerated() {
            domainView.initialize(DomainExtension.allCases[idx])
        }
    }
    
    private func toggleSave() {
        if fakeword.isSaved() {
            dataBaseManager.removeFromList(fakeword)
        } else {
            dataBaseManager.addToList(fakeword)
        }
        
        updateSave()
    }
    
    private func setupSave() {
        saveWordButton.layer.cornerRadius = 15
        updateSave()
    }
    
    private func updateSave() {
        if fakeword.isSaved() {
            saveWordButton.tintColor = .white
            saveWordButton.backgroundColor = FawGenColors.primary.color
        } else {
            saveWordButton.tintColor = .lightGray
            saveWordButton.backgroundColor = .gray
        }
    }
    

    
    /// Updates the cell with the correct FaveWord entity
    /// - Parameter data: of type FakeWord containing the
    /// name, icon, color and other information
    public func update() {
        let fakeLogo = FakeLogo(fakeword.logoName)
        if let logoUrl = fakeLogo.imageURL {
            madeUpLogo.loadImageUsing(logoUrl)
        }

        let fakeWordFontSize = fakeWordLabel.font.pointSize
        fakeWordLabel.font = UIFont(name: fakeword.font, size: fakeWordFontSize)
        fakeWordLabel.text = fakeword.name
        fakeWordLabel.textColor = fakeword.themeColor.convertedToUIColor()
        let fontSize = rootTextLabel.font.pointSize
        let attributedRootText = fakeword.formatRootStoryText(fontSize: fontSize)
        rootTextLabel.attributedText = attributedRootText
        rootTextLabelHeight.constant = heightForRootLabel()
        
        setupSave()
        updateSave()
        let cellNum = self.tag
        printConsole("DEFKUT[\(cellNum)] --> \(fakeword.name) ==> [\(fakeword.font)] ==> \(fakeword.logoName)")
        
    }
    
    /// Determines the height of the rootTextLabel after the formating
    /// as been applied. it allows to change the constraints on the height
    /// of the Cell and therefore the height of the TopView (from StackView)
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
    
    
    /// Queries the availability of the fakeWord as an handle for the
    /// social network sites and the domain extensions
    /// - Note: This query is requested by the CellState open
    /// from the tableView didSelectRowAt
    public func queryDomainSocialChecker() {
        printConsole("queryDomainSocialChecker")
        getSocialNetworkAvailability()
        getDomainExtensionAvailability()
    }
    
    /// Cancels any ongoing URL queries to the availability checkers
    /// - Note: This method is trigger by the tableView didDeselectRowAt
    public func cancelQueryDomainSocialChecker() {

    }
    
    /// Clear the query and sets the potition to .normal
    public func setDomainSocialViewsToNormal() {
        setupSocialDomain()
    }
    
    
    //private func listTaks
    
    /// Gets the availability from the handle (fakeword.name) and
    /// return if the username is available or taken
    private func getSocialNetworkAvailability() {
        let orderedSocialViews = cellSocialViews.sorted{ $0.tag < $1.tag }
        var socialNetViews = [SocialNetwork : CellSocialView]()
        for (idx, socialView) in orderedSocialViews.enumerated() {
            let net = SocialNetwork.allCases[idx]
            socialNetViews[net] = socialView
        }
        let handle = fakeword.name.lowercased()
        let socialURLs = socialNetworkURLs(for: handle, completeList: false)

        for (social, link) in socialURLs {
            guard let socialView = socialNetViews[social] else { continue }
            guard let url = URL(string: link) else {
                socialView.status = .unknown
                continue
            }
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    DispatchQueue.main.async {
                        switch httpResponse.statusCode {
                        case 404:
                            socialView.status = .available
                        case 200:
                            socialView.status = .taken
                        default:
                            socialView.status = .unknown
                        }
                    }
                } else {
                    DispatchQueue.main.async { socialView.status = .unknown }
                }
            }
            task.resume()
        }
    }
    
    /// Gets the availability from the domain (fakeword.name) and
    /// return if the domain+extension is available or taken
    private func getDomainExtensionAvailability() {
        let orderedDomainViews = cellDomainViews.sorted{ $0.tag < $1.tag }
        var domainViews = [DomainExtension : CellDomainView]()
        
        for (idx, domainView) in orderedDomainViews.enumerated() {
            let ext = DomainExtension.allCases[idx]
            domainViews[ext] = domainView
        }
        
        let domainName = fakeword.name.lowercased()
        let whoisQueryURLS = DomainChecker().whoisURLs(for: domainName, completeList: false)
        
        for (ext, queryURL) in whoisQueryURLS {
            guard let domainView = domainViews[ext] else { continue }
            guard let url = URL(string: queryURL) else {
                domainView.status = .unknown
                continue
            }
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if (error == nil) {
                    
                    if let result = String(data: data!, encoding: String.Encoding.utf8) {
                        DispatchQueue.main.async {
                            let comp = result.components(separatedBy: ", ")
                            if comp.count == 2 {
                                switch comp[1] {
                                case "AVAILABLE":
                                    domainView.status = .available
                                case "TAKEN":
                                    domainView.status = .taken
                                default:
                                    domainView.status = .unknown
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            domainView.status = .unknown
                        }
                    }
                } else {
                    domainView.status = .unknown
                    printConsole("Error: \(String(describing: error))")
                }
            }
            task.resume()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
}

