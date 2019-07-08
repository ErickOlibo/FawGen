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
        let info = "[\(self.logoName) - \(self.font)] --> "
        let newLine = "\n"
        let root = info + "Root: "
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


let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageUrl: URL?
    
    public func loadImageUsing(_ url: URL) {
        imageUrl = url
        
        image = nil
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

public func printConsole(_ text: String) {
    let filter = " |||"
    print(text + filter)
}
