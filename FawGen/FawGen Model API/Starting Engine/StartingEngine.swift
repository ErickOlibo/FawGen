//
//  StartingEngine.swift
//  ModelForFawGen
//
//  Created by Erick Olibo on 13/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class StartingEngine: UIView {

    // MARK: - Properties
    private let numberOfImages = 30
    private let basicName = "ThreeGears_"
    private(set) var view: UIView!
    private(set) var images: [UIImage]!
    
    // MARK: - Outlets
    @IBOutlet weak var progressBar: CircularProgressBar!
    @IBOutlet weak var startingEngineLabel: UILabel!
    @IBOutlet weak var pleaseWaitLabel: UILabel!
    @IBOutlet weak var threeGearsImageView: UIImageView!
    
    
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
        setupThreeGearsImages()
        setupThreeGearsAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitialization()
        setupThreeGearsImages()
        setupThreeGearsAnimation()

    }

    
    
    private func setupThreeGearsImages() {
        var images = [UIImage]()
        for idx in 1...30 {
            let imageName = basicName + String(idx)
            let image = UIImage(named: imageName)!
            images.append(image)
        }
        self.images = images
    }
    
    private func setupThreeGearsAnimation() {
        threeGearsImageView.animationImages = images
        threeGearsImageView.animationDuration = 1.0 // with 30 images speed is 30fps
        threeGearsImageView.animationRepeatCount = 0
    }
    
    private func commonInitialization() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight]

        view.addSubview(progressBar)
        view.addSubview(startingEngineLabel)
        view.addSubview(pleaseWaitLabel)
        view.addSubview(threeGearsImageView)
        

        view.layer.cornerRadius = 10
        self.view = view
        self.addSubview(view)
 
    }
    
    
    // MARK: - Public methods
    public func startAnimating() {
        threeGearsImageView.startAnimating()
    }
    
    
    public func stopAnimating() {
        threeGearsImageView.stopAnimating()
    }

}
