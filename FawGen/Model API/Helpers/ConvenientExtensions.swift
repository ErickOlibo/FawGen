//
//  ConvenientExtensions.swift
//  FawGen
//
//  Created by Erick Olibo on 12/04/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns true is the row or line contains the "Centroid_" as prefix.
    /// It helps determine if the current line is the coordinate of a centroid
    public var isCentroidVector: Bool {
        return String(self.prefix(9)) == "Centroid_"
    }
    
    
    /// Returns true is the starting biGram is of similar letters (i.e. llamas)
    public var isStartingWithDoubleLetter: Bool {
        let oneChar = String(self.prefix(1)).lowercased()
        let twoChar = String(self.prefix(2)).lowercased()
        let doubleLetter = oneChar + oneChar
        return doubleLetter == twoChar
    }

    
    /// Returns the biGram of a string
    public func biGrams() -> [String] {
        var results = [String]()
        for idx in 0..<self.count {
            let subWord = String(self.suffix(self.count - idx))
            guard subWord.count > 1 else { continue }
            results.append(String(subWord.prefix(2)))
        }
        return results
    }
    
    
    /// Returns true the string only contains any of the 26 letters of the English alphabet
    public var containsOnlyAlphabetLetters: Bool {
        let state = CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: self))
        return state
    }
    
    /// Returns true if the characters length is of user requirement
    /// Currently the limts are (6, 16) when user selected
    public var isOfCorrectLength: Bool {
        return ModelConstants.minMaxWordLength.contains(self.count)
    }
    
    /// Returns true if the characters length is of app requirement
    /// Currently the limts are (6, 12) when user selected nil
    public var isOfCorrectInAppLength: Bool {
        return ModelConstants.minMaxInAppWordLength.contains(self.count)
    }

    
}

extension Double {
    
    public var isOfCorrectInAppLength: Bool { return Int(self).isOfCorrectInAppLength }
    
    public var isOfCorrectLength: Bool { return Int(self).isOfCorrectLength }
    
    public var isOfCorrectAlgo: Bool { return ModelConstants.minMaxAlgo.contains(self) }
    
    public var correctedLength: Double {
        return Double(Int(self).correctedLength)
    }
    
    public var correctedAlgo: Double {
        if self < ModelConstants.minAlgo { return ModelConstants.minAlgo }
        if self > ModelConstants.maxAlgo { return ModelConstants.maxAlgo }
        return self
    }
 
}

extension Int {
    
    public var correctedLength: Int {
        if self < ModelConstants.minLength { return ModelConstants.minLength }
        if self > ModelConstants.maxLength { return ModelConstants.maxLength }
        return self
    }
    
    public var randomLength: Int {
        return ModelConstants.minMaxWordLength.randomElement() ?? 8
    }
    
    public var isOfCorrectLength: Bool {
        return ModelConstants.minMaxWordLength.contains(self)
    }
    
    
    /// In case where the length is not specify, the max length is upsed.
    /// From the UI/UX perspective, the Length is set to OFF
    public var correctedInAppSize: Int {
        if self < ModelConstants.minLength { return ModelConstants.minLength }
        if self > ModelConstants.maxInAppLength { return ModelConstants.maxInAppLength }
        return self
    }
    
    public var randomInAppLength: Int {
        return ModelConstants.minMaxInAppWordLength.randomElement() ?? 8
    }
    
    public var isOfCorrectInAppLength: Bool {
        return ModelConstants.minMaxInAppWordLength.contains(self)
    }
    

}


extension Date {
    public var toNowProcessDuration: (String, Double, Int) {
        let end = Date()
        let interval = end.timeIntervalSince(self)
        let milliSecs = Int(interval * 1000)
        let secs = Double(Int(interval * 100)) / 100
        let time = Int(interval)
        let hours = time / 3600
        let minutes = time / 60 % 60
        let seconds = time % 60
        let finalTime = String(format: "\(hours)h \(minutes)m \(seconds)s")
        return (finalTime, secs, milliSecs)
    }
}


// Random Generic Methods

/// Pick K random elements from data
func sample<T>(_ data: [T], k: Int) -> [T] {
    var elements = data
    elements.shuffle()
    return Array(elements.prefix(k))
}


// MARK: - NSRange and String extension

/// Taken from the SPAppStore.swift in FawGen app
extension NSRange {
    
    func rangeAPI(for str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        
        guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
        guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        
        return fromIndex ..< toIndex
    }
}

/// Taken from the SPAppStore.swift in FawGen app
extension String {
    
    func rangesAPI(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    func slicesAPI(from: String, to: String) -> [Substring] {
        let pattern = "(?<=" + from + ").*?(?=" + to + ")"
        
        return rangesAPI(of: pattern, options: .regularExpression)
            .map{ self[$0] }
    }
}
