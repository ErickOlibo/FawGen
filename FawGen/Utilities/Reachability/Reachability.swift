//
//  Reachability.swift
//  FawGen
//
//  Created by Erick Olibo on 01/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit
import SystemConfiguration

class Reachability {
    
    // Properties
    let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    var flags = SCNetworkReachabilityFlags()
    
    public enum ConnectionType: String {
        case unavailable
        case wifi
        case mobileData
    }

    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    public func networkStatus() -> ConnectionType {
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        if !isNetworkReachable(with: flags) {
            return .unavailable
        }
        
        #if os(iOS)
        if flags.contains(.isWWAN) {
            return .mobileData
        }
        #endif
        return .wifi
    }
    
    public func isInternetReachableAlertAction(viewController view: UIViewController) -> Bool {
        switch networkStatus() {
        case .unavailable:
            printConsole("[getAlertAction] - Unavailable")
            let controller = UIAlertController(title: "No Internet Detected", message: "Fawgen app requires an Internet connection to check handles and domains availabilities", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(ok)
            controller.addAction(cancel)
            view.present(controller, animated: true, completion: nil)
            return false
            
        case .mobileData:
            printConsole("[getAlertAction] - Internet Connection OK: Mobile data")
            return true
            
        case .wifi:
            printConsole("[getAlertAction] - Internet Connection OK: WIFI")
            return true
            
        }
    }
    
    public func internetConnectionAlertController() -> UIAlertController? {
        switch networkStatus() {
        case .unavailable:
            printConsole("[internetConnectionAlertController] - Unavailable")
            let controller = UIAlertController(title: "No Internet Detected", message: "Fawgen app requires an Internet connection to check handles and domains availabilities", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(ok)
            controller.addAction(cancel)
        case .mobileData:
            printConsole("")
        case .wifi:
            printConsole("")
        }
        
        return nil
    }
    
    
}

