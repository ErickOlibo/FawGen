//
//  DetailsViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 01/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    // MARK: - Properties
    public var isFromSavedList: Bool = false
    //public var isSaved: Bool = false
    let dataBaseManager = DefaultDB()
    public let session = URLSession(configuration: .ephemeral)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public var  widthConstants: [CGFloat] {
        let deviceWidth = UIScreen.main.nativeBounds.width
        let scale = UIScreen.main.nativeScale
        return (deviceWidth / scale).splitsSpacing
    }
    
    public var fakeWord = FakeWord()
    
    
    // MARK: - Outlets
    @IBOutlet weak var typedWord: UILabel!
    @IBOutlet weak var rootStory: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textToSpeech: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var domainViews: [DomainView]!
    @IBOutlet var socialViews: [SocialView]!
    
    
    // MARK: - Layout Constraints
    @IBOutlet var domainLeadSpaces: [NSLayoutConstraint]!
    @IBOutlet var domainTrailSpaces: [NSLayoutConstraint]!
    @IBOutlet var domainSpaces: [NSLayoutConstraint]!
    @IBOutlet var domainWidths: [NSLayoutConstraint]!
    
    @IBOutlet var socialLeadSpaces: [NSLayoutConstraint]!
    @IBOutlet var socialTrailSpaces: [NSLayoutConstraint]!
    @IBOutlet var socialSpaces: [NSLayoutConstraint]!
    @IBOutlet var socialWidths: [NSLayoutConstraint]!
    
    // MARK: - Actions
    @IBAction func tappedTextToSpeech(_ sender: UIButton) {
        sender.pulse()
        touchedTextToSpeech()
    }
    
    /// The Save word to Database will need to be done later..
    /// There is a need to implement a data type for tha fake word
    /// creation.
    @IBAction func tappedSave(_ sender: UIButton) {
        sender.pulse()
        toggleSave()
    }
    
    
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
        view.backgroundColor = .white
        navigationItem.title = "Details"
        saveButton.layer.cornerRadius = 5.0
        typedWord.text = fakeWord.title.uppercased()
        setRootStoryText()
        updateDomainSocialViewsConstraints()
        setupDomainViews()
        setupSocialViews()
        //setupSaveButton()
        
        updateSaveButtonUI()
        
        if isFromSavedList {
            saveButton.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDomainExtensionsAvailability()
        getSocialNetworksAvailability()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    
    
    // MARK: - Methods
    
    // Set the text for root story
    private func setRootStoryText() {
        let fontSize = rootStory.font.pointSize
        let attributedStory = fakeWord.formatRootStoryText(fontSize: fontSize)
        rootStory.attributedText = attributedStory
    }
    
    
    
    /// Toggles the UI/UX layout for the save button
    private func toggleSave() {
        if fakeWord.isSaved() {
            dataBaseManager.removeFromSavedList(fakeWord)
        } else {
            dataBaseManager.addToSavedList(fakeWord)
        }
        updateSaveButtonUI()
    }
    
    private func updateSaveButtonUI() {
        if fakeWord.isSaved() {
            saveButton.backgroundColor = FawGenColors.primary.color
            saveButton.setTitle("saved", for: .normal)
        } else {
            saveButton.backgroundColor = .lightGray
            saveButton.setTitle("save", for: .normal)
        }
    }
    
    
    private func setupDomainViews() {
        let orderedDomainViews = domainViews.sorted{ $0.tag < $1.tag }
        for (idx, domainView) in orderedDomainViews.enumerated() {
            domainView.initialize(DomainExtension.allCases[idx])
            domainView.backgroundColor = FawGenColors.secondary.color
            domainView.layer.cornerRadius = 5.0
        }
    }
    
    private func setupSocialViews() {
        let orderedSocialViews = socialViews.sorted{ $0.tag < $1.tag }
        for (idx, socialView) in orderedSocialViews.enumerated() {
            socialView.initialize(SocialNetwork.allCases[idx].info)
            socialView.backgroundColor = .clear
        }
    }
    
    private func touchedTextToSpeech() {
        let tts = TextToSpeech()
        printConsole("[DetailsViewController] TTS -> FakeWord.Title: \(fakeWord.title)")
        tts.speakFakeWord(fakeWord.title, accent: .american)
    }
    
    /// Updates the DomainViews and SocialViews constraints to
    /// fit the size of the Device bounds
    private func updateDomainSocialViewsConstraints() {
        let faveWidth = widthConstants[0]
        let leftSpace = widthConstants[1]
        let viewSpace = widthConstants[2]
        let rightSpace = widthConstants[3]
        
        for lead in domainLeadSpaces { lead.constant = leftSpace }
        for trail in domainTrailSpaces { trail.constant = rightSpace }
        for space in domainSpaces { space.constant = viewSpace }
        for width in domainWidths { width.constant = faveWidth }
        
        for lead in socialLeadSpaces { lead.constant = leftSpace }
        for trail in socialTrailSpaces { trail.constant = rightSpace }
        for space in socialSpaces { space.constant = viewSpace }
        for width in socialWidths { width.constant = faveWidth }
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
