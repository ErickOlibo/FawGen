//
//  FontsLister.swift
//  FawGen
//
//  Created by Erick Olibo on 28/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

/// Prints to the console the list of fonts present in the device
/// - Warning:
/// This is not to be use for during development and distribution
public class FontsLister {
    
    init () {
        printFonts()
    }
    
    private func printFonts() {
        print("Font name size: \(UIFont.familyNames.count)")
        for familyName in UIFont.familyNames {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }
    
    
}
