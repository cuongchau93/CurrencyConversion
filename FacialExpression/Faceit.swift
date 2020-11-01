//
//  Faceit.swift
//  SimpleSwiftApp
//
//  Created by Chau, Cuong | DCMS on 2020/10/31.
//  Copyright © 2020 Chau, Cuong | DCMS. All rights reserved.
//

import UIKit

@IBDesignable
class Faceit: UIView {

    @IBInspectable
    var scale: CGFloat = 0.9 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var eyesOpen: Bool = true{
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var mouthCurvature: Double = -0.5 // 1.0 is full smile, -1.0 is full frown
    {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var lineWidth: CGFloat = 5.0
    {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var color: UIColor = UIColor.blue
    {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @objc
    func changeScale (byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    private enum Eye {
        case left
        case right
    }
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale;
    }
    
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private func skullPath() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        
        path.lineWidth = lineWidth;
        return path;
    }

    
    private func eyePath(_ eye: Eye) -> UIBezierPath {
        func centerOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
            return eyeCenter
        }
        
        let eyeCenter = centerOfEye(eye)
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let path:UIBezierPath
        if eyesOpen {
            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y ))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y ))
        }
         
        
        path.lineWidth = lineWidth;
        return path;
    }
    
    private func mouthPath() -> UIBezierPath {
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthCenter = skullCenter
        
        let mouthRect = CGRect(
            x: mouthCenter.x - mouthWidth / 2,
            y: mouthCenter.y + mouthOffset,
            width: mouthWidth,
            height: mouthHeight
        )
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)

        let smileOffset = max(-1, min(CGFloat(mouthCurvature), 1)) * mouthRect.height
        let controlPoint1 = CGPoint(
            x: start.x + mouthRect.width / 3,
            y: start.y + smileOffset
        )
        
        let controlPoint2 = CGPoint(x: end.x - mouthRect.width / 3, y: start.y + smileOffset)

        
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: controlPoint1, controlPoint2: controlPoint2)

        path.lineWidth = lineWidth;
        return path;
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        skullPath().stroke()
        eyePath(.left).stroke()
        eyePath(.right).stroke()
        
        mouthPath().stroke()
    }

    private struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 4
    }
}
