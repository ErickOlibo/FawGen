//
//  RVC+Alerts.swift
//  FawGen
//
//  Created by Erick Olibo on 02/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

extension RandomizeViewController {
    
    public func showAlertForNoResults() {
        printConsole("NO RESULTS for this Query")
        let controller = UIAlertController(title: "No New Words Generated!", message: "The Engine couldn't generate new words. Please change the filters or keywords and try again!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (alert) in self.resetSimpleAssistAfterAlert() }
        
        controller.addAction(ok)
        present(controller, animated: true, completion: nil)
    }
    
}
