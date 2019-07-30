//
//  PersistentKNN.swift
//  FawGen
//
//  Created by Erick Olibo on 28/04/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


class PersistentKNN {
    
    static let shared = PersistentKNN("sharedKNN")
    let kNN: KNearestNeighbors
    let name: String
    
    private init(_ name: String) {
        self.name = name
        self.kNN = KNearestNeighbors(self.name)
    }
    

    
}
