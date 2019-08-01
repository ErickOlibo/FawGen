//
//  ConvenienceExtensions.swift
//  FawGen
//
//  Created by Erick Olibo on 02/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


extension MadeUpWord {
    
    public var rootsStory: String {
        let elements = self.elements
        let algo = self.madeUpAlgo
        switch algo {
        case .concat:
            return "\(algo.description) => \(elements)"
        case .markovChain:
            return "\(algo.description) => \(elements)"
        case .simpleSwap:
            return "\(algo.description) => \(elements)"
        case .startBlendSwap:
            return "\(algo.description) => \(elements)"
        case .endBlendSwap:
            return "\(algo.description) => \(elements)"
        case .vowelsBlendSwap:
            return "\(algo.description) => \(elements)"
        case .substitute:
            return "\(algo.description) => \(elements)"
        case .flavor:
            return "\(algo.description) => \(elements)"
        }
    }
    
    
    
}




extension FakeWord {
    
    /// Formats the text of the roots of the creation of that word
    /// with the appropriate formating for the rootTextLabel
    func formatRootStoryText(fontSize: CGFloat) -> NSMutableAttributedString {
        //let info = "[\(self.logoName) - \(self.font)] --> "
        let newLine = "\n"
        let root = "Root: "
        let algo = "Algo: "
        
        // Here is the one that should be changed
        
        let rootText = NSMutableAttributedString(string: self.roots)
        //let rootText = attributedRootStory(self, fontSize)
        
        let algoType = NSAttributedString(string: self.algoName)
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
    
    
    private func attributedRootStory(_ fakeWord: FakeWord, _ fontSize: CGFloat) -> NSMutableAttributedString {
        let algoNumber = Int(fakeWord.algoNumber)
        guard let mediumFont = UIFont(name: "AvenirNext-DemiBold", size: fontSize) else { return NSMutableAttributedString() }
        let sepa = " - "
        let separation = NSAttributedString(string: sepa)
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor : FawGenColors.primary.color, NSAttributedString.Key.font : mediumFont]
        //let result = NSMutableAttributedString()
        switch algoNumber {
        case 1:
            let size = fakeWord.elements.count
            if size == 3 {
                let word = fakeWord.elements[0]
                let attributedWord = NSMutableAttributedString(string: word)
                let origin = fakeWord.elements[1]
                let swap = fakeWord.elements[2]
                let swapRange = word.ranges(of: origin)
                //printConsole("INSIDE [attributedRootStory] -> Size: \(size) - Word: \(word) - Swap: \(origin) Ranges Size: \(swapRange.count)")
                for ( idx, range) in swapRange.enumerated() {
                    if idx == 0 {
                        attributedWord.addAttributes(attributes, range: NSRange(range, in: word))
                        attributedWord.append(separation)
                        attributedWord.append(NSAttributedString(string: swap, attributes: attributes))
                        return attributedWord
                    }
                }
            }
            
        case 2:
            let size = fakeWord.elements.count
            if size == 4 {
                let first = fakeWord.elements[0]
                let subs = fakeWord.elements[1]
                let second = fakeWord.elements[2]
                let num = first.count - subs.count
                let leftWord = String(first.prefix(num))
                let rightWordEnd = String(second.suffix(second.count - leftWord.count))
                let rightWordStart = String(second.prefix(second.count - rightWordEnd.count))
                let attributedWord = NSMutableAttributedString(string: leftWord, attributes: attributes)
                attributedWord.append(NSAttributedString(string: subs + sepa))
                attributedWord.append(NSAttributedString(string: rightWordStart, attributes: attributes))
                attributedWord.append(NSAttributedString(string: rightWordEnd))
                return attributedWord
            }
            
        case 3:
            let list = fakeWord.elements.joined(separator: sepa)
            let attributedWord = NSMutableAttributedString(string: list)
            return attributedWord

        case 4:
            print("")
        case 5:
            print("")
        default:
            return NSMutableAttributedString(string: fakeWord.roots)
        }
        
        
        return NSMutableAttributedString()
    }
}


let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageUrl: URL?
    
    public func loadImageUsing(_ url: URL) {
        imageUrl = url
        
        image = #imageLiteral(resourceName: "MissingLogo")
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
        }
        
        //guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, reponses, error) in
            if error != nil {
                printConsole("\(error!)")
                return
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                if self.imageUrl == url {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: url as AnyObject)
            }
        }.resume()
    }
}


private let isPrintingOn = true

/// Prints to console, it is a way to silence other console logged.
public func printConsole(_ text: String) {
    if isPrintingOn {
        let filter = " |||"
        print(text + filter)
    }
    
}
