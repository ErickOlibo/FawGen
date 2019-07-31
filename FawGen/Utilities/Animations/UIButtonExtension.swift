//
//  UIButtonExtension.swift
//  ButtonAnimations
//
//  Created by Erick Olibo on 09/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


extension UIButton {
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 20
        layer.add(pulse, forKey: nil)
    }
    
    func pulse() {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = 0.15
        pulse.fromValue = 1
        pulse.toValue = 0.90
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.add(pulse, forKey: nil)
    }
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        
        layer.add(flash, forKey: nil)
    }
    
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        
        shake.autoreverses = true
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: nil)
        
    }
    
    
}

extension UILabel {
    
    
    
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        
        shake.autoreverses = true
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: nil)
        
    }
    
    func flashLimit() {
        CATransaction.begin()
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.7
        flash.fromValue = 0.1
        flash.toValue = 1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        CATransaction.setCompletionBlock { [weak self] in
            self?.dim()
        }
        layer.add(flash, forKey: nil)
        CATransaction.commit()
    }
    
    func dim() {
        UIView.animate(withDuration: 0.6, delay: 1.4, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (_) in
            //print("Dim is completed")
        }
    }
    
    func stopAllRunningAnimations() {
        self.layer.removeAllAnimations()
        
    }
    
    
}

//// Spinner indicator
//extension UIButton {
//    func loadingIndicator(_ show: Bool) {
//        let tag = 808404
//        if show {
//            self.isEnabled = false
//            self.alpha = 0.5
//            let indicator = UIActivityIndicatorView()
//            let buttonHeight = self.bounds.size.height
//            let buttonWidth = self.bounds.size.width
//            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
//            indicator.tag = tag
//            self.addSubview(indicator)
//            indicator.startAnimating()
//        } else {
//            self.isEnabled = true
//            self.alpha = 1.0
//            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
//                indicator.stopAnimating()
//                indicator.removeFromSuperview()
//            }
//        }
//    }
//}
