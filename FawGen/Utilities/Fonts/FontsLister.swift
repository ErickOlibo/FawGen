//
//  FontsLister.swift
//  FawGen
//
//  Created by Erick Olibo on 28/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

private let wrongFonts: Set<String> = ["BodoniOrnamentsITCTT", "FontAwesome"]

/// Serves to list the system fonts and added fonts to the console
/// and select a random font to use inside the application
/// - Warning: The added font part is not implemented yet and
/// requires some investigation
public class FontsLister {
    
    init () {
        
    }
    /// randomizes the selection of an unique font from the font present in
    /// the system.
    /// - Returns: an optional String as the font name
    /// - Remarks: the font name includes the type (normal, italic, regular, etc..),
    /// therefore this method does not give the opion to choose its type
    public func randomFont() -> String? {
        return pickRandomFont()
    }
    
    /// prints the list of font currently register by the system to the xcode console
    /// - Note: This is not a method that has any use for distribution environment
    /// It must be used only for development purposes.
    public func printListToConsole() {
        printFonts()
    }
    
    public func fontFamilyArray() -> [String] {
        return UIFont.familyNames
    }
    
    /// Collects all fontName and put them in an array
    public func getAllFontNames() -> [String] {
        var collection = [String]()
        for family in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: family) {
                guard !wrongFonts.contains(fontName) else { continue }
                collection.append(fontName)
            }
        }
        return collection
    }
    
    
    
}

private func pickRandomFont() -> String? {
    guard let randomFamily = UIFont.familyNames.randomElement() else { return nil }
    guard let randomFontName = UIFont.fontNames(forFamilyName: randomFamily).randomElement() else { return nil }
    return randomFontName
}


private func printFonts() {
    print("Font FamilyNames size: \(UIFont.familyNames.count)")
    var count = 0
    for familyName in UIFont.familyNames {
        
        //print("\n-- \(familyName) \n")
        for fontName in UIFont.fontNames(forFamilyName: familyName) {
            count += 1
            print("[\(count)] - Family: \(familyName) - Font: \(fontName)")
            //print(fontName)
        }
    }
}
