//
//  Persistent.swift
//  FawGenModelAPI
//
//  Created by Erick Olibo on 04/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

class Persistent {
    
    private(set) var model: FawGenModel!
    private(set) var kNN: KNearestNeighbors!
    
    private(set) var toolBox: ToolBox!
    private(set) var grams: Grams!
    
    init(_ model: FawGenModel, _ kNN: KNearestNeighbors, _ toolBox: ToolBox, _ grams: Grams) {
        self.model = model
        self.kNN = kNN
        self.toolBox = toolBox
        self.grams = grams
    }
    
    
}
