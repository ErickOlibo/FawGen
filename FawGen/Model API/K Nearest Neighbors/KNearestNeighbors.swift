//
//  KNearestNeighbors.swift
//  FawGenModelAPI
//
//  Created by Erick Olibo on 04/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


class KNearestNeighbors {
    
    // MARK: - Properties
    private weak var model: FawGenModel!
    
    private(set) var centroids = [Vector]()
    private(set) var classificationByCentroids = [[Vector]]()
    private(set) var collectionOfVectors = [Vector]()
    
    private let type: SimilarityType = .euclidean
    
    
    // MARK: - Initialization
    init(_ model: FawGenModel) {
        self.model = model
        centroids = model.centroids
        classificationByCentroids = model.classificationByCentroids
        collectionOfVectors = model.collectionOfVectors
    }
    
}


// MARK: - Public methods
extension KNearestNeighbors {
    
    /// Returns the K-Nearest Neighbor using Euclidean Similarity as default.
    /// - Parameters:
    ///     - point: a vector point insite the word2vec space
    ///     - k: the size of the closest neighbors to return
    /// - Returns: an array of tuple (vector, Double) with the Double value between 0 to 1
    /// with closer to 1 indicating the closest similarity to the initial vector
    public func similarNearestNeighborsTo (_ point: Vector, numberOfNeighbors k: Int = ModelConstants.numberOfNeighbors) -> [(Vector, Double)]{
        var neighborsSize = [Int]()
        var distanceToVectors = [Vector : Double]()
        let nearestCenters = indicesOfKNearestCenters(point)
        var nearestNeighbors : [Vector] {
            var vectors = [Vector]()
            for idx in nearestCenters {
                let neighborhood = classificationByCentroids[idx]
                vectors.append(contentsOf: neighborhood)
                neighborsSize.append(neighborhood.count)
            }
            neighborsSize.append(neighborsSize.reduce(0, +))
            return vectors
        }
        
        switch type {
        case .cosine:
            for pointA in nearestNeighbors {
                if point == pointA { continue }
                distanceToVectors[pointA] = point.cosineSimilarityTo(pointA)
            }
            let sorted = distanceToVectors.sorted { $0.value > $1.value }
            return Array(sorted.prefix(k))
        case .euclidean:
            for pointA in nearestNeighbors {
                if point == pointA { continue }
                distanceToVectors[pointA] = point.euclideanDistanceTo(pointA)
            }
            let sorted = distanceToVectors.sorted { $0.value < $1.value }
            return Array(sorted.prefix(k))
        }
    }
    
}

// MARK: - Private methods
extension KNearestNeighbors {
    
    /// Returns the index of the K-Nearest Centroids to a vector point
    /// - Parameters:
    ///     - point: a vector point insite the word2vec space
    ///     - k: the number of centroids closest to the vector point
    private func indicesOfKNearestCenters(_ point: Vector, k: Int = ModelConstants.numbCentroids) -> [Int] {
        var indices = [Int]()
        var centerIndexAndDistance = [Int : Double]()
        for (idx, center) in centroids.enumerated() {
            let distance = point.euclideanDistanceTo(center)
            centerIndexAndDistance[idx] = distance
        }
        let sorted = centerIndexAndDistance.sorted { $0.value < $1.value }
        for (idx, _) in sorted.prefix(k) {
            indices.append(idx)
        }
        return indices
    }
    
}
