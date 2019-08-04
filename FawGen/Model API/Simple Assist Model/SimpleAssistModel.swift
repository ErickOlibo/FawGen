//
//  SimpleAssistModel.swift
//  FawGenModelAPI
//
//  Created by Erick Olibo on 04/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

class SimpleAssistModel {
    
    // MARK: - Properties
    private(set) var nlp: NLProcessor!
    private(set) var keywords = String()
    private(set) var nameToVector: [String : Vector]
    private weak var kNN: KNearestNeighbors!
    private weak var model: FawGenModel!
    
    init(_ model: FawGenModel, kNN: KNearestNeighbors) {
        nlp = NLProcessor()
        self.model = model
        self.kNN = kNN
        nameToVector = model.nameToVector
        
    }
    
}


// MARK: - Public Methods
extension SimpleAssistModel {
    
    public func getNeighbors(from keywords: String = String()) -> Set<String>? {
        self.keywords = keywords
        return listOfNeighbors()
    }
}


// MARK: - Private methods
extension SimpleAssistModel {
    
    private func listOfNeighbors() -> Set<String>? {
        var neighbors = Set<String>()
        var numbOfNeighbors = Int()
        let tokens = nlp.tokenizeByWords(keywords)
        neighbors.formUnion(tokens)
        
        let tokensInNameToVector = tokens.compactMap { nameToVector[$0] }
        let size = tokensInNameToVector.count
        switch size {
        case 0:
            return neighbors
        case 1:
            numbOfNeighbors = ModelConstants.numberOfNeighbors * 3
        case 2:
            numbOfNeighbors = lround((Double(ModelConstants.numberOfNeighbors) * 1.5))
        default:
            numbOfNeighbors = ModelConstants.numberOfNeighbors
        }
        
        for token in tokens {
            guard let vector = nameToVector[token] else { continue }
            let nearNeighbors = kNN.similarNearestNeighborsTo(vector, numberOfNeighbors: numbOfNeighbors).reduce(into: []) { result, vector in
                result.append(vector.0.name)
            }
            neighbors.formUnion(nearNeighbors)
        }
        return neighbors
    }
}
