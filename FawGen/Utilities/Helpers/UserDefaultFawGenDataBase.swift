//
//  UserDefaultFawGenDataBase.swift
//  FawGen
//
//  Created by Erick Olibo on 10/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

private let defaults = UserDefaults.standard
private let maxEntries = 30 // maxim

// Save the keywords and description history to a file
// in the system. History has date and text as data type.


/// enumeration of the different type of data title to keep
public enum LightDB: String, CustomStringConvertible, Equatable {
    case history, length, lengthOnOff, type, typeOnOff, symbol, symbolOnOff, list
    
    public var description: String {
        return self.rawValue
    }
}


/// organizes and saves the simple data values necessary to keep
/// the FawGen app running
/// - Note: There is a great example on how to use generic method
public struct DefaultDB {
    
    static func save<T: Equatable>(_ value: T, for key: LightDB) {
        defaults.setValue(value, forKey: convert(key))
        defaults.synchronize()
    }
    
    static func getValue<T: Equatable>(for key: LightDB) -> T? {
        
        return defaults.object(forKey: convert(key)) as? T
    }
    
    static func synchronize() {
        defaults.synchronize()
    }
    
    /// Assures the latest keywords history is properly documented
    /// by keeping a max list and updating date in case the same keywords
    /// are used.
    /// - Note: Currently the max entries is set to 30 (var maxEntries)
    static func sanitize(_ keywordsHistory: KeywordsHistory) -> KeywordsHistory {
        var history = keywordsHistory
        if history.count > maxEntries {
            let sorted = history.sorted{ $0.value < $1.value }
            let (key, _) = sorted[0]
            history.removeValue(forKey: key)
        }
        return history
    }
    
    private static func convert(_ key: LightDB) -> String {
        return key.description
    }
    
    
    
    static func getSavedList() -> [FakeWord] {
        var list = [FakeWord]()
        guard let savedList = DefaultDB.getValue(for: .list)! as SavedList? else { return list }
        for (_, data) in savedList {
            do {
                let fakeword = try PropertyListDecoder().decode(FakeWord.self, from: data)
                list.append(fakeword)
            } catch {
                print("[getSavedList] Issue while Decoding Data with Error: \(error)")
            }
        }
        
        return list
    }
}
