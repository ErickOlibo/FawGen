//
//  PersistentModel.swift
//  FawGen
//
//  Created by Erick Olibo on 27/04/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

class PersistentModel {
    
    // MARK: - Properties
    static let shared = PersistentModel("sharedModel")
    
    let model: Model
    let name: String
    
    // Initializaion
    private init(_ name: String) {
        self.name = name
        self.model = Model(self.name)
    }
}
