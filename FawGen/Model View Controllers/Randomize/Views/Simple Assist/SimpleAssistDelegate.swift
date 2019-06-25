//
//  SimpleAssistDelegate.swift
//  FawGen
//
//  Created by Erick Olibo on 25/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

protocol SimpleAssistDelegate {
    func queryAssistedModel(by keywords: String)
    func querySimpleModel()
}

extension SimpleAssistDelegate {
    func transferHand(_ type: String){}
}
