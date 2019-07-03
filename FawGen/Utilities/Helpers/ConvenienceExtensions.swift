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
    
    
//    /// Updates the list after a removeFromList has been performed
//    private func updateSavedList(_ list: SavedList) {
//        
//        
//    }
    
    /// Saves the current fakeWord to the SaveList in DefaultDatabase
    public func addToList() {
        do {
            let encodeFakeWord = try PropertyListEncoder().encode(self)
            if var savedList = DefaultDB.getValue(for: .list)! as SavedList? {
                savedList[self.name] = encodeFakeWord
                DefaultDB.save(savedList, for: .list)
                print("[addToList] - LIST SIZE: \(savedList.count)")
            } else {
                DefaultDB.save([self.name : encodeFakeWord], for: .list)
                print("SAVE LIST Initial Value")
            }
        } catch {
            print("Encoding FakeWard failed with ERROR: \(error)")
        }
    }
    
    
    /// Removes a fakeword from the list
    public func removeFromList() {
        guard var savedList = DefaultDB.getValue(for: .list)! as SavedList? else { return }
        print("[removeFromList] - LIST BEFORE size: \(savedList.count)")
        savedList.removeValue(forKey: self.name)
        DefaultDB.save(savedList, for: .list)
        print("[removeFromList] - LIST AFTER size: \(savedList.count)")
        let list = savedList.map { $0.key }.sorted()
        print(list)
    }
    

    /// Returns if a fakeword is in the saveList by cheking if its name
    /// is key to the dictionary
    public func isSaved() -> Bool {
        guard let savedList = DefaultDB.getValue(for: .list)! as SavedList? else { return false }
        let saved = savedList[self.name] != nil
        print("TESTING: [isSaved] for - \(self.name) ==> \(saved)")
        return saved
    }
    
    
    
    
    
}

