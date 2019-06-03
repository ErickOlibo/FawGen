//
//  ColorGenerator.swift
//  FawGen
//
//  Updated by Erick Olibo on 02/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//
//  Created by mbcharbonneau on 1/6/15.
//  Copyright (c) 2015 Once Living LLC. All rights reserved.
//  https://github.com/mbcharbonneau/Color-Generator
//



import UIKit

/// Creates random color of type UIColor to use in the UI. It uses
/// the golden ratio to generate color pleasing sets. Each random color
/// generated is visually distinct from each other.
/// There are 3 methods available:
///     - randomColor: returns a random color
///     - gradientColors: returns a pair of suitable color for a gradient blend
///     - variation: returns a color
/// - Author: Marc Charbonneau
public class ColorGenerator {
    
    fileprivate let goldenRatioConjugate: Float = (sqrt(5.0) - 1.0) / 2.0
    fileprivate let gradientDistance: Float = 0.3
    fileprivate var randomHue: Float
    
    var saturation: Float
    var brightness: Float
    
    init(saturation: Float = 0.5, brightness: Float = 0.95) {
        srand48(time(nil))
        self.randomHue = Float(drand48())
        self.saturation = saturation
        self.brightness = brightness
    }
    
    /// This method generates a random color. Each call will yeild a color
    /// that is visually distinct from the previous one.
    /// - Returns: a randomly generated color of type UIColor.
    public func randomColor() -> UIColor {
        randomHue += goldenRatioConjugate
        randomHue.formTruncatingRemainder(dividingBy: 1.0)
        
        return UIColor(hue: CGFloat(randomHue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
    }
    
    /// This method generate a pair of colors to use in the creation
    /// of a visually pleasing gradient.
    /// - Returns: a tuple of two UIColor as start and end for the creation
    /// of a gradient
    public func gradientColors() -> (start: UIColor, end: UIColor) {
        let startHue: Float = Float(drand48()).truncatingRemainder(dividingBy: 1.0)
        let endHue: Float = (startHue + gradientDistance).truncatingRemainder(dividingBy: 1.0)
        
        let start = UIColor(hue: CGFloat(startHue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
        let end = UIColor(hue: CGFloat(endHue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
        
        return (start, end)
    }
    
    // Create a random variant of the given baseColor, using distance to
    // determine how much to change the RGB values.
    /// This method generates a variant of a given UIColor, using distance
    /// as metric to determine the change in RGB values.
    /// - Parameters:
    ///     - baseColor: the initial color to create a variant from
    ///     - distance: a CGFloat between 0.0 -> 1.0 as distance
    /// - Returns: a UIColor variant from the initial color
    public func variation(of baseColor: UIColor, distance: CGFloat) -> UIColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        baseColor.getRed( &red, green: &green, blue: &blue, alpha: nil )
        
        let randomRed: CGFloat = CGFloat(drand48()).truncatingRemainder(dividingBy: distance)
        let randomGreen: CGFloat = CGFloat(drand48()).truncatingRemainder(dividingBy: distance)
        let randomBlue: CGFloat = CGFloat(drand48()).truncatingRemainder(dividingBy: distance)
        
        red += (red + randomRed > 1.0) ? randomRed * -1.0 : randomRed
        green += (red + randomGreen > 1.0) ? randomGreen * -1.0 : randomGreen
        blue += (red + randomBlue > 1.0) ? randomBlue * -1.0 : randomBlue
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
}
