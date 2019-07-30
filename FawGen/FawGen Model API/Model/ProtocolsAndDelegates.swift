//
//  ProtocolsAndDelegates.swift
//  ModelForFawGen
//
//  Created by Erick Olibo on 25/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


protocol ModelVocabularyDelegate {
    func modelVocabularyLoading(_ percent: Int)
}

protocol WordToVecModelDelegate {
    func wordToVecLoading(_ percent: Int)
}

protocol StatementsDelegate {
    func statementsLoading(_ percent: Int)
}

protocol GramsDelegate {
    func gramsLoading(_ percent: Int)
}

protocol ModelDelegate {
    func modelLoadingCompletion(at percent: Int)
}

protocol ToolBoxDelegate {
    func toolBoxResultsReady(for task: TaskType)
}
