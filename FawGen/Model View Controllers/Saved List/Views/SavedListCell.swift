//
//  SavedListCell.swift
//  FawGen
//
//  Created by Erick Olibo on 02/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class SavedListCell: UITableViewCell {
    
    // MARK: - Properties
    var fakeWord: FakeWord! { didSet { update() } }
    
    // MARK: - Outlets
    @IBOutlet weak var verticalBarView: UIView!
    @IBOutlet weak var fakeWordLabel: UILabel!
    @IBOutlet weak var algoAndTimeLabel: UILabel!
    
    
    // MARK: - Actions    
    @IBAction func tappedTTS(_ sender: UIButton) {
        sender.pulse()
        speakWord()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
    }

    
    /// Updates all that is necessary
    private func update() {
        verticalBarView.backgroundColor = fakeWord.themeColor.convertedToUIColor()
        fakeWordLabel.text = fakeWord.title.uppercased()
        algoAndTimeLabel.text = fakeWord.algoName.capitalized
        guard let iconTime = FAType.FAClockO.text else { return }
        let space = " "
        let attributeOne = [NSAttributedString.Key.font : UIFont(name: "FontAwesome", size: 15.0)!]
        let firstL = fakeWord.algoName.prefix(1).capitalized
        let rest = fakeWord.algoName.dropFirst()
        let algo = "#\(firstL + rest)" + space + space
        let attrsAlgo = NSMutableAttributedString(string: algo)
        let time = NSAttributedString(string: iconTime, attributes: attributeOne)
        let timeAgo = space + fakeWord.created.timeAgoSinceNow()
        let attrsTimeAgo = NSAttributedString(string: timeAgo)
        attrsAlgo.append(time)
        attrsAlgo.append(attrsTimeAgo)
        algoAndTimeLabel.attributedText = attrsAlgo
        
        
    }
    

    
    /// Speak the word
    private func speakWord() {
        let tts = TextToSpeech()
        printConsole("[SavedListCell] TTS -> FakeWord.Title: \(fakeWord.title)")
        tts.speakFakeWord(fakeWord.title, accent: .american)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
