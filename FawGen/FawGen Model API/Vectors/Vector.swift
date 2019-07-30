//
//  Vector.swift
//  FawGen
//
//  Created by Erick Olibo on 13/03/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

struct Vector: CustomStringConvertible, Equatable, Hashable {
    private(set) var dimension = 0
    private(set) var data: [Double]
    private(set) var name: String

    
    init(_ data: [Double], name: String) {
        self.data = data
        self.dimension = data.count
        self.name = name
    }
    
    var description: String {
        return "\(name)"
    }
    
    /// Euclidean Distance to another Vector
    /// The closer to 0 (zero), the similar the vectors are.
    /// The greater the value, the further the vectors are.
    func euclideanDistanceTo(_ other: Vector) -> Double {
        var distance = 0.0
        for idx in 0..<dimension {
            distance += pow(data[idx] - other.data[idx], 2.0)
        }
        return sqrt(distance)
    }
    
    /// Returns two vectors Dot product as a double
    private func dotProduct(_ other: Vector) -> Double {
        var product = Double()
        for idx in 0..<dimension {
            product += data[idx] * other.data[idx]
        }
        return product
    }
    
    /// Returns a Vector Magnitude for other one
    private func magnitude(_ vector: [Double]) -> Double {
        var magnitude = Double()
        for idx in 0..<vector.count {
            magnitude += pow(vector[idx], 2.0)
        }
        return sqrt(magnitude)
    }
    
    /// Returns the Cosine Similarity between 2 vectors
    /// The closer to 1 (zero), the similar the vectors are.
    /// The closer to 0 (zero), the disticnt the vectors are.
    func cosineSimilarityTo(_ other: Vector) -> Double {
        let numerator = dotProduct(other)
        let denominator = magnitude(data) * magnitude(other.data)
        return numerator / denominator
    }
}


func ==(lhs: Vector, rhs: Vector) -> Bool {
    for idx in 0..<lhs.dimension {
        if lhs.data[idx] != rhs.data[idx] {
            return false
        }
    }
    return true
}


func +(lhs: Vector, rhs: Vector) -> Vector {
    var newValue = [Double]()
    for idx in 0..<lhs.dimension {
        newValue.append(lhs.data[idx] + rhs.data[idx])
    }
    let newName = lhs.name + "_" + rhs.name
    return Vector(newValue, name: newName)
}


func +=(lhs: inout Vector, rhs: Vector) {
    lhs = lhs + rhs
}


func -(lhs: Vector, rhs: Vector) -> Vector {
    var newValue = [Double]()
    for idx in 0..<lhs.dimension {
        newValue.append(lhs.data[idx] - rhs.data[idx])
    }
    let newName = lhs.name + "_" + rhs.name
    return Vector(newValue, name: newName)
}


func -=(lhs: inout Vector, rhs: Vector) {
    lhs = lhs - rhs
}


func /(lhs: Vector, rhs: Double) -> Vector {
    var newValue = [Double]()
    for value in lhs.data {
        newValue.append(value / rhs)
    }
    return Vector(newValue, name: lhs.name)
}


func /=(lhs: inout Vector, rhs: Double) {
    lhs = lhs / rhs
}
