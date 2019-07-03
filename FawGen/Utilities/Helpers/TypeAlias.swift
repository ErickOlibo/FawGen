//
//  TypeAlias.swift
//  FawGen
//
//  Created by Erick Olibo on 31/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


/// This is the domain name we are querying the availability
/// It should not include the extension
/// In this App it represent a randomly generated word
/// Used for the class DomainChecker for better code wrtiting style
public typealias Domain = String

/// This is the socialNetwork handle or username we are querying the availability
/// In this App it represent a randomly generated word
/// Used for the class SocialChecker for better code writing style
public typealias Handle = String


/// This is for the Advance filter the type used to save data
/// to the userDefaults. The keywords (or project description), and the time
/// where the query was requested
public typealias KeywordsHistory = [String : Date]


/// This is the custom type to be saved in the savedList
/// It is a dictionary with key, the word name as String and value
/// is the custom type FakeWord
public typealias SavedList = [String : Data]



public typealias SaveableFakeWord = (Bool, Date, String, String, String, String, String, String)
