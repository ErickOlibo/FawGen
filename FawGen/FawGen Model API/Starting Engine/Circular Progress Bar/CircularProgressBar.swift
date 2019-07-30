//
//  CircularProgressBar.swift
//  CircularProgressBar
//
//  Created by Erick Olibo on 26/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class CircularProgressBar: UIView {
    
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    private let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    private var currentFromValue: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    
    
    var progressColor: UIColor = .blue {
        didSet {progressLayer.strokeColor = progressColor.cgColor }
    }
    
    var trackColor : UIColor = .lightGray {
        didSet{ trackLayer.strokeColor = trackColor.cgColor }
    }
    
    
    private func createCircularPath() {
        self.backgroundColor = .white
        self.layer.cornerRadius = self.frame.size.width / 2.0
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        let circlePath = UIBezierPath(arcCenter: center, radius: (frame.size.width - 1.5) / 2, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)

        
        // Track Layer
        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 10.0
        trackLayer.strokeEnd = 1.0
        trackLayer.lineCap = CAShapeLayerLineCap.round
        self.layer.addSublayer(trackLayer)
        
        // Progress Layer
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 0.0
        progressLayer.lineCap = CAShapeLayerLineCap.round
        self.layer.addSublayer(progressLayer)
        
        // Basic Animation
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        
    }
    
    /// Expecting Integer between 0...100 as a representation of percent
    public func setProgressWithAnimationTo(_ value: Int) {
        if value >= 96 {progressColor = .green}
        basicAnimation.fromValue = Double(currentFromValue) / 100
        basicAnimation.toValue = Double(value + 2) / 100
        currentFromValue = value + 2
        progressLayer.add(basicAnimation, forKey: "circularAnimation")
        
        
    }
    
    
    
    
}

