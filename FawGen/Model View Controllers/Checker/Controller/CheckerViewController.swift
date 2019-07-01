//
//  CheckerViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 28/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class CheckerViewController: UIViewController {
    
    // MARK: - Properties
    let navBar = SPFakeBarView.init(style: .stork)
    public let safeCharacters: Set<Character> = {
        return Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    }()
    public var wasQueried: Bool = false
    public var userEnteredWord = String()
    public var isSaved: Bool = false
    //public var wasReset: Bool = false
    public var resetCount: Int = 0
    
    public var socialGroupIsDone: Bool = false
    public var domainGroupIsDone: Bool = false
    
    // Dispatch Group for handling Task to Server
    let myGroup = DispatchGroup()
    let session = URLSession(configuration: .ephemeral)
    var domainDataTasks = [DomainExtension : URLSessionDataTask]() {
        didSet {
            //print("Domain Data Tasks Size: \(domainDataTasks.count)")
        }
    }
    var socialDataTasks = [SocialNetwork : URLSessionDataTask]() {
        didSet {
            //print("Social Data Tasks Size: \(socialDataTasks.count)")
        }
    }
    
    enum GroupType {
        case social
        case domain
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public var  widthConstants: [CGFloat] {
        let deviceWidth = UIScreen.main.nativeBounds.width
        let scale = UIScreen.main.nativeScale
        return (deviceWidth / scale).splitsSpacing
    }
    
    // MARK: - Outlets
    @IBOutlet weak var textField: TextFieldCounter!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var typedWord: UILabel!
    @IBOutlet weak var textToSpeech: UIButton!
    
    @IBOutlet var domainViews: [DomainView]!
    @IBOutlet var socialViews: [SocialView]!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    // MARK: - Layout Constraints
    @IBOutlet var leadingSpaces: [NSLayoutConstraint]!
    @IBOutlet var trailingSpaces: [NSLayoutConstraint]!
    @IBOutlet var domainSpaces: [NSLayoutConstraint]!
    @IBOutlet var domainWidths: [NSLayoutConstraint]!
    
    @IBOutlet var socialLeadSpaces: [NSLayoutConstraint]!
    @IBOutlet var socialTrailSpaces: [NSLayoutConstraint]!
    @IBOutlet var socialSpaces: [NSLayoutConstraint]!
    @IBOutlet var socialWidths: [NSLayoutConstraint]!
    
    
    
    // MARK: - Actions
    @IBAction func tappedSend(_ sender: UIButton) {
        sender.pulse()
        touchedSendButton()
    }
    
    @IBAction func tappedTextToSpeech(_ sender: UIButton) {
        sender.pulse()
        touchedTextToSpeech()
    }
    
    /// The Save word to Database will need to be done later..
    /// There is a need to implement a data type for tha fake word
    /// creation.
    @IBAction func tappedSave(_ sender: UIButton) {
        print("tapped Save")
        sender.pulse()
        toggleSaveRemove()
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
        view.backgroundColor = .white
        textField.delegate = self
        typedWord.text = String()
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        setupNavBar()
        setupTextfieldArea()
        setupSaveTextToSeepechArea()
        updateDomainSocialViewsConstraints()
        setupDomainViews()
        setupSocialViews()
        setupTapGestureForScrollView()
        setupSendButton()
        setupTextToSpeechSaveButton()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("NavBar Size: \(navBar.bounds)")
    }
    

    @objc func hide() {
        dismiss(animated: true, completion: nil)
    
    }
    
    public func setupTextToSpeechSaveButton() {
        updateEnabledTextToSpeechSaveForSendQuery()

    }
    
    public func setupSendButton() {
        let textCount = textField.text?.count ?? 0
        if textCount < 6 {
            sendButton.tintColor = .white
            sendButton.backgroundColor = .gray
            if sendButton.isEnabled { sendButton.isEnabled = false }
        } else {
            sendButton.tintColor = .white
            sendButton.backgroundColor = FawGenColors.primary.color
            if !sendButton.isEnabled { sendButton.isEnabled = true }
        }
    }
    
    
    private func setupTapGestureForScrollView() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(touchedScrollView))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(recognizer)
    }
    
    private func setupSocialViews() {
        let orderedSocialViews = socialViews.sorted{ $0.tag < $1.tag }
        
        for (idx, socialView) in orderedSocialViews.enumerated() {
            socialView.initialize(SocialNetwork.allCases[idx].info)
            socialView.backgroundColor = .clear
            
        }
        
    }
    
    
    
    private func updateDomainSocialViewsConstraints() {
        let faveWidth = widthConstants[0]
        let leftSpace = widthConstants[1]
        let viewSpace = widthConstants[2]
        let rightSpace = widthConstants[3]
        
        for lead in leadingSpaces { lead.constant = leftSpace }
        for trail in trailingSpaces { trail.constant = rightSpace }
        for space in domainSpaces { space.constant = viewSpace }
        for width in domainWidths { width.constant = faveWidth }

        for lead in socialLeadSpaces { lead.constant = leftSpace }
        for trail in socialTrailSpaces { trail.constant = rightSpace }
        for space in socialSpaces { space.constant = viewSpace }
        for width in socialWidths { width.constant = faveWidth }
    }
    
    private func setupDomainViews() {
        let orderedDomainViews = domainViews.sorted{ $0.tag < $1.tag }
        
        for (idx, domainView) in orderedDomainViews.enumerated() {
            domainView.initialize(DomainExtension.allCases[idx])
            domainView.backgroundColor = FawGenColors.secondary.color
            domainView.layer.cornerRadius = 5.0
        }
    }
    
    private func setupTextfieldArea() {
        // Text Field
        textField.animate = true
        textField.ascending = true
        textField.maxLength = 16
        textField.counterColor = .gray
        textField.limitColor = FawGenColors.primary.color
        textField.backgroundColor = FawGenColors.cellGray.color
        
        // Send Button (remember change of color with number of chars(min=6)
        sendButton.layer.cornerRadius = 15.0
    }
    
    private func setupSaveTextToSeepechArea() {
        saveButton.layer.cornerRadius = 5.0
        saveButton.backgroundColor = .lightGray
        saveButton.setTitle("save")

        
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


