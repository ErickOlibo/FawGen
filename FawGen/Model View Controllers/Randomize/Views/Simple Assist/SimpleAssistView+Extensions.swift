//
//  SimpleAssistView+Extensions.swift
//  FawGen
//
//  Created by Erick Olibo on 24/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

extension SimpleAssistView {
    
    // MARK: - Methods
    /// Initializes the basic setup nedded for the view
    /// to display properly
    public func commonInitialization() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(view)
        state = .close
    }
    
    /// Updates the cornerRadius for the Let's Go Button depending
    /// on the state (open or close) directly related to the Randomize
    /// type selected (open = Assist, close = Simple)
    private func updateCornerLetsGoButton() {
        switch state {
        case .close:
            letsGoButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case .open:
            letsGoButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    
    /// Sets the necessary UI for the area where the Keywords, or
    /// project description are entered.
    public func keywordsFrameSetup() {
        keywordsFrameView.clipsToBounds = true
        keywordsFrameView.layer.cornerRadius = 10
        keywordsFrameView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        keywordsFrameView.backgroundColor = FawGenColors.secondary.color
        
    }
    
    /// Sets the attributes of the growing UITextView
    public func keywordsGrowningTextSetup() {
        keywordsGrowningTextView.delegate = self
        keywordsGrowningTextView.smartInsertDeleteType = .no
        keywordsGrowningTextView.attributedText = NSAttributedString()
        keywordsGrowningTextView.textColor = FawGenColors.secondary.color
        textMaxLength = keywordsGrowningTextView.maxLength
    }
    
    /// Sets the basic attributes of the Let's Go button
    public func letsGoButtonSetup() {
        letsGoButton.clipsToBounds = true
        letsGoButton.layer.cornerRadius = 10
    }
    
    public func textLengthLabelSetup() {
        textLengthLabel.text = ""
    }
    
    public func closeStack() {
        topView.alpha = 1
        UIView.animate(withDuration: 0.5) {
            self.topView.alpha = 0
        }
        state = .close
    }
    
    public func openStack() {
        topView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.topView.alpha = 1
        }
        state = .open
    }
    
    /// updates the background color of the Simple and Assist button
    /// with respect to the state (open or close)
    private func updateSimpleAssist() {
        switch state {
        case . close:
            simpleButton.backgroundColor = FawGenColors.secondary.color
            assistButton.backgroundColor = .darkGray
        case .open:
            simpleButton.backgroundColor = .darkGray
            assistButton.backgroundColor = FawGenColors.secondary.color
        }
    }
    
    /// toggles the UI from the open state to close state and
    /// the stackView
    public func toggle() {
        print("Toggled() --> State is: \(state.rawValue)")
        updateCornerLetsGoButton()
        updateSimpleAssist()
        stackView.arrangedSubviews[openViewIndex].isHidden = isStateClosed()
        
    }
    
    private func isStateClosed() -> Bool {
        return state == .close
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        keywordsGrowningTextView.resignFirstResponder()
    }
    
    
}

// MARK: - Text View Delegate
extension SimpleAssistView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let attributedText = keywordsGrowningTextView.attributedText {
            textLimitUI(for: attributedText.length)
            
            keywordsGrowningTextView.attributedText = formatEntered(attributedText)
        }
    }
    
    /// Formats the user entered text to highlight keywords that I
    /// part of the model corpus. These keywords are used but the
    /// Words Vector Space to define similarities
    private func formatEntered(_ attributedText: NSAttributedString) -> NSMutableAttributedString {
        let hightlightAttributes: [NSAttributedString.Key: Any] = [
            .backgroundColor: FawGenColors.primary.color,
            .foregroundColor: UIColor.white]
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .backgroundColor: UIColor.clear,
            .foregroundColor: FawGenColors.secondary.color]
        
        let text = attributedText.string
        let endAttributedText = NSMutableAttributedString(attributedString: attributedText)
        let fullRange = NSRange(location: 0, length: endAttributedText.length)
        endAttributedText.addAttributes(normalAttributes, range: fullRange)
        let wordsInText = nlp.tokenize(text)
        let wordsInCorpus = listOfWordsInCorpusArray(for: text) // Lowercased
        let corpusSet = Set(wordsInCorpus)
        let textSet = Set(wordsInText)
        
        for word in textSet {
            guard corpusSet.contains(word.lowercased()) else { continue }
            let wordRanges = text.ranges(of: word)
            for range in wordRanges {
                endAttributedText.addAttributes(hightlightAttributes, range: NSRange(range, in: text))
                print(text[range])
            }
        }
        return endAttributedText
    }
    
    /// Updates the number of characters in the TextView and show
    /// users the remaining characters to limit and when the limit
    /// is reached
    private func textLimitUI(for length: Int ) {
        let remain = textMaxLength - length
        switch length {
        case let len where len <= 0:
            textLengthLabel.text = ""
        case let len where len > 0 && len <= (textMaxLength - 11):
            textLengthLabel.text = String(remain)
            textLengthLabel.textColor = .white
        case let len where len > (textMaxLength - 11) && len <= textMaxLength:
            textLengthLabel.text = String(remain)
            textLengthLabel.textColor = FawGenColors.tertiary.color
        default:
            textLengthLabel.text = "Too long!"
            textLengthLabel.textColor = FawGenColors.primary.color
            fireHapticFeedback()
            textLengthLabel.shake(transform: CGAffineTransform(translationX: 5, y: 0), duration: 0.3)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
    }

}


// MARK: - Let's Go Button
extension SimpleAssistView {
    
    /// Executes the request for the creation of random words using
    /// the simple Model engine. This is performed by the ViewController
    /// (RandomizeViewController) via a delegation protocol
    public func letsGoSimple() {
        print("Let's Go SIMPLE")
        simpleAssistDelegate?.querySimpleModel()
        // Send to model
    }
    
    /// Executes the request for the creation of random words using
    /// the assisted Model engine. This is performed by the ViewController
    /// (RandomizeViewController) via a delegation protocol
    public func letsGoAssist() {
        // Save to history
        if let text = keywordsGrowningTextView.text {
            if text.count == 0 {
                letsGoSimple()
            } else {
                print("Let's Go ASSIST")
                let entry = String(text.prefix(textMaxLength))
                saveToHistory(entry)
                keywordsGrowningTextView.text = String()
                textLengthLabel.text = String()
                simpleAssistDelegate?.queryAssistedModel(by: entry)
            }
            
        }
        // Send to model
        
    }
    
    
}


// MARK: - Keywords and Description History
extension SimpleAssistView {
    
    /// Records the keywords query to the UserDefault Database. The keywords
    /// and the date when it was queried is saved
    /// - Parameter keywords: the string text to query against
    public func saveToHistory(_ keywords: String) {
        let now = Date()
        if DefaultDB.getValue(for: .history)! as KeywordsHistory? == nil {
            DefaultDB.save([keywords : now], for: .history)
        } else {
            var savedHistory = DefaultDB.getValue(for: .history)! as KeywordsHistory
            savedHistory[keywords] = now
            let sanitizedHistory = DefaultDB.sanitize(savedHistory)
            DefaultDB.save(sanitizedHistory, for: .history)
        }
    }
    
    /// Returns the number of keywords that are part of the model's corpus
    /// As a Set is returned, the order and the repeatitiveness are not important
    /// - Parameter keywords: the text inserted or type by the user.
    private func listOfWordsInCorpus(for keywords: String) -> Set<String> {
        let wordsList = nlp.tokenizeByWords(keywords)
        return wordsList.filter { Constants.thousandWords.contains($0)}
    }
    
    /// Returns the number of keywords that are part of the model's corpus
    /// As an Array is returned, the order and the repeatitiveness are crucial.
    /// - Parameter keywords: the text inserted or type by the user.
    private func listOfWordsInCorpusArray(for keywords: String) -> [String] {
        let list = nlp.tokenize(keywords).map{ $0.lowercased() }
        return list.filter { Constants.thousandWords.contains($0)}
    }
    
}



// MARK: - animation
extension SimpleAssistView {
    // MARK: - Haptic Feedback
    /// Vibrates the device to indicate a warning
    public func fireHapticFeedback() {
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        }
    }
}


extension UIView {
    public func shake(transform: CGAffineTransform, duration: TimeInterval) {
        
        self.transform = transform
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}


/// https://stackoverflow.com/questions/32305891/index-of-a-substring-in-a-string-with-swift
extension StringProtocol {
    
    /// Returns the start String.index of a string (or subString) in another string
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    /// Returns the end String.index of a string (or subString) in another string
    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    /// Returns the startIndex and endIndex (lowerBound and upperBound) of a string
    /// in another string
    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    /// Returns the start and end index of a string as a [Range<Index>]
    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
