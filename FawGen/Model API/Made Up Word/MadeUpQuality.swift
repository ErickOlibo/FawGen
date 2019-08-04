//
//  MadeUpQuality.swift
//  ModelForFawGen
//
//  Created by Erick Olibo on 17/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


/// Class To keep a hold on the quality of the madeUpWords generated
///
class MadeUpQuality: Hashable, CustomStringConvertible, Codable {
    
    
    private(set) var title = String()
    private(set) var length = Double()
    private(set) var algoNumber = Double()
    private(set) var algoName = String()
    
    init(_ title: String, algo: MadeUpAlgo) {
        self.title = title
        self.length = Double(title.count)
        self.algoNumber = getAlgoNumber(for: algo).rawValue
        self.algoName = getAlgoName(for: algo).rawValue
    }
    
    var description: String {
        return "\(title) - Quality [\(length), \(algoNumber)]"
    }
    
    
}

func == (lhs: MadeUpQuality, rhs: MadeUpQuality) -> Bool {
    return lhs.title == rhs.title
}

extension MadeUpQuality {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
}

extension MadeUpQuality {
    
    private func getAlgoNumber(for algo: MadeUpAlgo) -> AlgoNumber {
        switch algo {
        case .simpleSwap, .startBlendSwap, .endBlendSwap, .vowelsBlendSwap:
            return .swap
        case .substitute:
            return .subs
        case .concat:
            return .concat
        case .markovChain:
            return .chains
        case .flavor:
            return .flavor
        }
    }
    
    private func getAlgoName(for algo: MadeUpAlgo) -> AlgoName {
        switch algo {
        case .simpleSwap, .startBlendSwap, .endBlendSwap, .vowelsBlendSwap:
            return .swap
        case .substitute:
            return .subs
        case .concat:
            return .concat
        case .markovChain:
            return .chains
        case .flavor:
            return .flavor
        }
    }
    
}


private enum AlgoNumber: Double {
    typealias RawValue = Double
    case swap = 1.0
    case subs = 2.0
    case concat = 3.0
    case chains = 4.0
    case flavor = 5.0
}

private enum AlgoName: String {
    case swap, subs, concat, chains, flavor

}
