//
//  UserDefaultFawGenDataBase.swift
//  FawGen
//
//  Created by Erick Olibo on 10/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

private let defaults = UserDefaults.standard


// Save the keywords and description history to a file
// in the system. History has date and text as data type.


// organizes and saves the simple data values.

public enum LightDB: String, CustomStringConvertible, Equatable {
    case history, length, lengthOnOff, type, typeOnOff, symbol, symbolOnOff
    
    public var description: String {
        return self.rawValue
    }
}

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
    
    
    
    private static func convert(_ key: LightDB) -> String {
        return key.description
    }
}
