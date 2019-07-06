//
//  TypeAlias.swift
//  FawGen
//
//  Created by Erick Olibo on 31/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation



/// This is for the Advance filter the type used to save data
/// to the userDefaults. The keywords (or project description), and the time
/// where the query was requested
public typealias KeywordsHistory = [String : Date]


/// This is the custom type to be saved in the savedList
/// It is a dictionary with key, the word name as String and value
/// is the custom type FakeWord
public typealias SavedList = [String : Data]


// a type that represent an history entry from the DefaultDB
public typealias HistoryEntry = (String, Date)

