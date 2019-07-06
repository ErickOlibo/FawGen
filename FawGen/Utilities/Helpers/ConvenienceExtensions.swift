//
//  ConvenienceExtensions.swift
//  FawGen
//
//  Created by Erick Olibo on 02/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


extension FakeWord {
    
    /// Formats the text of the roots of the creation of that word
    /// with the appropriate formating for the rootTextLabel
    func formatRootStoryText(fontSize: CGFloat) -> NSMutableAttributedString {
        let newLine = "\n"
        let root = "Root: "
        let algo = "Algo: "
        let rootText = NSMutableAttributedString(string: self.madeUpRoots)
        let algoType = NSAttributedString(string: self.madeUpType.rawValue)
        //let fontSize = rootTextLabel.font.pointSize
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

    
}

