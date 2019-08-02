//
//  RVC+FilterVCDelegate.swift
//  FawGen
//
//  Created by Erick Olibo on 02/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

extension RandomizeViewController: FilterViewControllerDelegate {
    func filterViewControllerWillDisappear() {
        printConsole("FilterVC Will Disappear Delegate and DataSource count = \(dataSource.items.count)")
        
        
    }
    
    
}
