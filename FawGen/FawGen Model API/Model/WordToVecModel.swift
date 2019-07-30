//
//  WordToVecModel.swift
//  FawGen
//
//  Created by Erick Olibo on 04/04/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

class WordToVecModel {
    
    public var delegate: WordToVecModelDelegate?
    private let corpusSize : Double = 37738.0
    private(set) var nameToVector = [String : Vector]()
    private(set) var collectionOfVectors = [Vector]()
    private(set) var centroids = [Vector]()
    private(set) var classificationByCentroids = [[Vector]]() {
        didSet {
            let number = classificationByCentroids.map{ $0.count }.reduce(0, +)
            let percent = Int((Double(number) / corpusSize) * 100)
            delegate?.wordToVecLoading(percent)
        }
    }
    
    
    public func initialize() {
        let start = Date()
        for idx in 1...ModelConstants.numberOfClusters {
            let rows = getClusterFileRowsForCentroid(number: idx)
            processCluster(rows)
        }
        printModelAPI("WORD 2 VEC MODEL Loading Loading [1] - \(start.toNowProcessDuration)")
    }
    
    
    /// Get the Cluster file in the bundle at the position n
    /// and return each rows as array of string
    private func getClusterFileRowsForCentroid(number n: Int) -> [String] {
        var rows = [String]()
        let filename = ModelConstants.clusterTXT + "\(n)" + ModelConstants.extTXT
        var fileContent = String()
        let comp = filename.components(separatedBy: ".")
        let fileURL = Bundle.main.url(forResource: comp[0], withExtension: comp[1])
        do {
            fileContent = try String(contentsOf: fileURL!, encoding: .utf8)
        } catch {
            print("[WordToVecModel Init FAILED!] - Error reading file named: \(filename) - Error description: \(error)")
        }
        rows = fileContent.components(separatedBy: NSCharacterSet.newlines)
        return rows
    }
    
    /// Processes Cluster rows to updates the properties: nameToVector
    /// collectionOfVectors, centroids and classificationByCentroids
    /// - Note: This is the method that takes all the time during StartUp
    /// - ToDo: There is a need to optinize this method in the near future. Maybe
    /// this should be the fisrt question you ask on StackOverflow
    private func processCluster(_ _rows: [String]) {
        var rows = _rows
        let first = rows.removeFirst()
        guard let centroidVector = getVector(from: first) else { return }
        centroids.append(centroidVector)
        let centroidClass = rows.reduce(into: []) { result, line in
            if let vector = getVector(from: line) {
                collectionOfVectors.append(vector)
                nameToVector[vector.name] = vector
                result.append(vector)
            }
            } as! [Vector]
        classificationByCentroids.append(centroidClass)
    }
    
    /// Returns a Vector type from a clusters rrow line
    private func getVector(from line: String) -> Vector? {
        var comp = line.components(separatedBy: .whitespaces)
        let word = comp.removeFirst()
        if word.count < ModelConstants.minCharacter || word.count > ModelConstants.maxLength { return nil }
        let data = comp.map{ Double($0)! }
        return Vector(data, name: word)
    }
    

}
