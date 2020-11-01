//
//  FacialController.swift
//  SimpleSwiftApp
//
//  Created by Chau, Cuong | DCMS on 2020/11/01.
//  Copyright © 2020 Chau, Cuong | DCMS. All rights reserved.
//

import Foundation
import UIKit

class FacialViewController: UIViewController {
    
    @IBOutlet weak var faceView: Faceit! {
        didSet {
            let handler = #selector(Faceit.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecognizer)
            
            let tapHandler = #selector(toggleEyes(byReactingTo:))
            let tapRecognizer = UITapGestureRecognizer(target: self, action: tapHandler)
            tapRecognizer.numberOfTouchesRequired = 1
            faceView.addGestureRecognizer(tapRecognizer)
            
            let swipeUpHandler = #selector(increaseHappiness)
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: swipeUpHandler)
            swipeUpRecognizer.direction = .up
            faceView.addGestureRecognizer(swipeUpRecognizer)
            
            let swipeDownHandler = #selector(decreaseHappiness)
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: swipeDownHandler)
            swipeDownRecognizer.direction = .down
            faceView.addGestureRecognizer(swipeDownRecognizer)

            updateUI()

        }
    }

    @objc
    func increaseHappiness() {
        expression = expression.happier
    }

    @objc
    func decreaseHappiness() {
        expression = expression.sadder
    }

    @objc
    func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = expression.eyes == .close ? .open : .close
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    var expression = FacialExpression(eyes: .close, mouth: .smile) {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI(){
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        case .close:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = false
        }
        
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }
        
    private let mouthCurvatures = [
        FacialExpression.Mouth.grin: 0.5,
        FacialExpression.Mouth.frown: -1,
        FacialExpression.Mouth.smile: 1,
        FacialExpression.Mouth.neutral: 0,
        FacialExpression.Mouth.smirk: -0.5
    ]
}
