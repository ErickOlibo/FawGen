//
//  FontsLister.swift
//  FawGen
//
//  Created by Erick Olibo on 28/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

private let wrongFonts: Set<String> = ["BodoniOrnamentsITCTT", "FontAwesome", "PartyLetPlain", "SavoyeLetPlain", "Zapfino"]
private let wrongFamily: Set<String> = ["Snell Roundhand", "Bodoni Ornaments", "FontAwesome", "Party LET", "Savoye LET", "Zapfino"]

private let maxListSize = 30

/// Serves to list the system fonts and added fonts to the console
/// and select a random font to use inside the application
/// - Warning: The added font part is not implemented yet and
/// requires some investigation
public class FontsLister {
    

    
    /// prints the list of font currently register by the system to the xcode console
    /// - Note: This is not a method that has any use for distribution environment
    /// It must be used only for development purposes.
    public func printListToConsole() {
        printFonts()
    }
    
    
    /// Collects all fontName and put them in an array
    public func getAllFontNames() -> [String] {
        var collection = [String]()
        for family in UIFont.familyNames {
            guard !wrongFamily.contains(family) else { continue }
            for fontName in UIFont.fontNames(forFamilyName: family) {
                collection.append(fontName)
            }
        }
        
        //printConsole("[getAllFontNames] COLLECTION SIZE: \(collection.count)")
//        var count = 0
//        for item in collection {
//            count += 1
//            printConsole("[\(count)] - FontName: \(item)")
//        }
        collection.shuffle()
        let sample = collection.prefix(maxListSize)
        return Array(sample)
    }
    
    
    
}

//private func pickRandomFont() -> String? {
//    guard let randomFamily = UIFont.familyNames.randomElement() else { return nil }
//    guard let randomFontName = UIFont.fontNames(forFamilyName: randomFamily).randomElement() else { return nil }
//    return randomFontName
//}


private func printFonts() {
    printConsole("Font FamilyNames size: \(UIFont.familyNames.count)")
    var count = 0
    for familyName in UIFont.familyNames {
        
        //print("\n-- \(familyName) \n")
        for fontName in UIFont.fontNames(forFamilyName: familyName) {
            count += 1
            printConsole("[\(count)] - Family: \(familyName) - Font: \(fontName)")
            //print(fontName)
        }
    }
}
