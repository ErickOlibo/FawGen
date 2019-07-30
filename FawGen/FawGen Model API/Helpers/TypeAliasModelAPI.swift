//
//  TypeAliasModelAPI.swift
//  FawGen
//
//  Created by Erick Olibo on 15/04/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


/// Data type to collect the quality requirement for a madeUpword
/// - Note:
///     - The length is the character count of the generated madeUpWord.
///     It must be within the boundaries of the minMaxLength constant.
///     - The algo is the algorithm used to create the madeUpword and goes from 1.0 to 5.0.
/// - Remark: Each quality is optional, meaning that if nil is chosen, the
/// quality requirement will be dismissed (as in set to false)
typealias QualityOptions = (length: Double?, algo: Double?)
