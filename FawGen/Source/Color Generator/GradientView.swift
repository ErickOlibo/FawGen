//
//  GradientView.swift
//  FawGen
//
//  Updated by Erick Olibo on 02/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//
//  Created by mbcharbonneau on 1/7/15.
//  Copyright (c) 2015 Once Living LLC. All rights reserved.
//  https://github.com/mbcharbonneau/Color-Generator
//

import UIKit

/// A view that holds a linear gradient from two colors. This is meant
/// to be used with the ColorGenerator but can use any other UIColor
/// - Requires: a Start and End color to be set after instantiation
/// - Note: There is a public function randomGradient that set the Start
/// and End color randomly via a ColorGenerator instance
/// - Author: Marc Charbonneau
class GradientView: UIView {

    private let colorGenerator = ColorGenerator()
    
    /// The start color of the gradient to construct
    /// Should be set after instantiating the class if randomGradient
    /// is not used.
    public var start: UIColor? {
        didSet{ assignColors() }
        
    }
    
    /// The end color of the gradient to construct
    /// Should be set after instantiating the class if randomGradient
    /// is not used.
    public var end: UIColor? {
        didSet{ assignColors() }
        
    }
    
    // MARK: - Public Methods
    
    /// Sets the Start color and End color of the gradient
    /// randomly
    public func randomGradient() {
        let (startColor, endColor) = colorGenerator.gradientColors()
        start = startColor
        end = endColor
    }
    
    private func assignColors() {
        guard let startColor = start else { return }
        guard let endColor = end else { return }
        
        let array = [startColor.cgColor, endColor.cgColor]
        let gradientLayer = layer as! CAGradientLayer
        
        gradientLayer.colors = array
        gradientLayer.locations = [0.0, 1.0]
    }
    
    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
}
