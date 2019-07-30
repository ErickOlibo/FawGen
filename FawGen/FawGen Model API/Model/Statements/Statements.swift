//
//  Statements.swift
//  ModelForFawGen
//
//  Created by Erick Olibo on 12/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


class Statements {
    
    public var delegate: StatementsDelegate?
    private var list = Set<String>()
    
    public func initialize() {
        let start = Date()
        self.list = ModelConstants.statements
        printModelAPI("STATEMENT Loading time: \(start.toNowProcessDuration)")
        delegate?.statementsLoading(100)
    }
    
    // Because the file is in the Bundle, there should not be a problem with forced unwraping
    public func randomOne() -> String {
        return list.randomElement()!
    }
}
