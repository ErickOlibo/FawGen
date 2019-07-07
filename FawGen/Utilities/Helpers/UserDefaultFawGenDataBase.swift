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
private let maxTakenIconName = 1000 // There are 2239 icons on the server


/// enumeration of the different type of data title to keep
public enum LightDB: String, CustomStringConvertible, Equatable {
    case history, length, lengthOnOff, type, typeOnOff
    case symbol, symbolOnOff, list, takenLogoName, usedLogoNameInSaveList
    
    public var description: String {
        return self.rawValue
    }
}


/// organizes and saves the simple data values necessary to keep
/// the FawGen app running
/// - Note: This is a great example on how to use generic method
public struct DefaultDB {
    
    // Properties
    public var lengthValue: Double {
        get {
            if DefaultDB.getValue(for: .length)! as Double? == nil {
                DefaultDB.save(8.0 as Double, for: .length)
                return 8.0
            }
            return DefaultDB.getValue(for: .length)! as Double
        }
        set(newLength) { DefaultDB.save(newLength, for: .length) }
    }
    
    public var typeValue: Double {
        get {
            if DefaultDB.getValue(for: .type)! as Double? == nil {
                DefaultDB.save(3.0 as Double, for: .type)
                return 3.0
            }
            return DefaultDB.getValue(for: .type)! as Double
        }
        set(newLength) { DefaultDB.save(newLength, for: .type) }
    }
    
    public var symbolValue: Double {
        get {
            if DefaultDB.getValue(for: .symbol)! as Double? == nil {
                DefaultDB.save(3.0 as Double, for: .symbol)
                return 3.0
            }
            return DefaultDB.getValue(for: .symbol)! as Double
        }
        set(newLength) { DefaultDB.save(newLength, for: .symbol) }
    }
    
    
    public var lengthStatus: Bool {
        get {
            if DefaultDB.getValue(for: .lengthOnOff)! as Bool? == nil {
                DefaultDB.save(false, for: .lengthOnOff)
                return false
            }
            return DefaultDB.getValue(for: .lengthOnOff)! as Bool
        }
        set { DefaultDB.save(newValue, for: .lengthOnOff) }
    }
    
    public var typeStatus: Bool {
        get {
            if DefaultDB.getValue(for: .typeOnOff)! as Bool? == nil {
                DefaultDB.save(false, for: .typeOnOff)
                return false
            }
            return DefaultDB.getValue(for: .typeOnOff)! as Bool
        }
        set { DefaultDB.save(newValue, for: .typeOnOff) }
    }
    
    public var symbolStatus: Bool {
        get {
            if DefaultDB.getValue(for: .symbolOnOff)! as Bool? == nil {
                DefaultDB.save(false, for: .symbolOnOff)
                return false
            }
            return DefaultDB.getValue(for: .symbolOnOff)! as Bool
        }
        set { DefaultDB.save(newValue, for: .symbolOnOff) }
    }
    
    
    static func save<T: Equatable>(_ value: T, for key: LightDB) {
        defaults.setValue(value, forKey: convert(key))
        defaults.synchronize()
    }
    
    static func getValue<T: Equatable>(for key: LightDB) -> T? {
        return defaults.object(forKey: convert(key)) as? T
    }
    
    private static func convert(_ key: LightDB) -> String {
        return key.description
    }
 
}


// MARK: - Saved List
extension DefaultDB {
    
    public func getSavedList() -> [FakeWord] {
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
    
    public func addToList(_ fakeWord: FakeWord) {
        do {
            let encodeFakeWord = try PropertyListEncoder().encode(fakeWord)
            if var savedList = DefaultDB.getValue(for: .list)! as SavedList? {
                savedList[fakeWord.name] = encodeFakeWord
                DefaultDB.save(savedList, for: .list)
            } else {
                DefaultDB.save([fakeWord.name : encodeFakeWord], for: .list)
            }
        } catch {
            print("Encoding FakeWard failed with ERROR: \(error)")
        }
    }
    
    public func removeFromList(_ fakeWord: FakeWord) {
        guard var savedList = DefaultDB.getValue(for: .list)! as SavedList? else { return }
        savedList.removeValue(forKey: fakeWord.name)
        DefaultDB.save(savedList, for: .list)
        
        // Print to console list for checking purpose
        let list = savedList.map { $0.key }.sorted()
        print(list)
    }
    
    
}


// Exteonsion of FakeWord to check if that word is in the database
extension FakeWord {
    /// Returns if a fakeword is in the saveList by cheking if its name
    /// is key to the dictionary
    public func isSaved() -> Bool {
        guard let savedList = DefaultDB.getValue(for: .list)! as SavedList? else { return false }
        return savedList[self.name] != nil
    }
}

// MARK: - History
extension DefaultDB {
    /// Adds the keywords query to the UserDefault Database. The keywords
    /// and the date when it was queried is saved
    /// - Parameter keywords: the string text to query against
    public func addToHistory(_ keywords: String) {
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
    
    
    /// Returns the list of keywords history as a dictionary
    /// of String entry and the date of record
    public func getHistory() -> KeywordsHistory {
        if let history = DefaultDB.getValue(for: .history)! as KeywordsHistory? {
            return history
        }
        return KeywordsHistory()
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
    
}


// MARK: - Random Logo Name and type
extension DefaultDB {
    /// This should in the future get a fake logo name by checking if the
    /// name is already in the used one or the saved one
    /// - Warning: Need to be updated later
    public func randomFakeLogoName() -> String {
        let idx = Int.random(in: 1...20)
        return "A_\(idx)"
    }
    
}
