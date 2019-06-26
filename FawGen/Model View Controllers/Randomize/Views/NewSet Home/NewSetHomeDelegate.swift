//
//  NewSetHomeDelegate.swift
//  FawGen
//
//  Created by Erick Olibo on 25/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation

/// - Attention:  The creation of a protocol to hold the delegate takes several
/// steps that must be followed
///     - Create a protocol file to hold the delegate conformity methods
///     - The required methods should be in the protocol implementation. Their
///         implementation is left to the class or object that takes delegation ownership
///     - The optional methods can be placed in an extension but need the open/close curly
///         bracket in order to be placed in this extension. Their implementation is left
///         to the class of object that takes delegation ownership
///     - Create a variable property in the class that have methods that need to notify the
///         the delegation ownership
///     - Conform to the protocol and its method in the class that owners the delegate
/// As an example:
///     - Create protocol file -> (NewSetHomeDelegate.swift)
///     - Define Required and Optinal Methods -> (NewSetHomeDelegate.swift)
///     - Create variable property -> (NewSetHomeView.swift)
///     - Conform to the protocol -> (RandomizeViewController.swift -> )

protocol NewSetHomeDelegate {
    func showSimpleAssist()
    func queryNewSetFromSimpleModel()
}

extension NewSetHomeDelegate {
    func transferHand(_ type: String){}
}
