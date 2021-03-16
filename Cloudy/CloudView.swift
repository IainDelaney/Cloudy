//
//  CloudView.swift
//  DrawCloud
//
//  Created by Iain Delaney on 2016-05-11.
//  Copyright © 2016 Lucerne Systems. All rights reserved.
//

import UIKit

@IBDesignable
class CloudView: UIView {

	override func draw(_ rect: CGRect) {
		//// PaintCode Trial Version
		//// www.paintcodeapp.com
		//// Color Declarations
		let strokeColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
		//// Bezier Drawing
		let bezierPath = UIBezierPath()
		bezierPath.move(to: CGPoint(x: 133.06, y: 4.88))
		bezierPath.addCurve(to: CGPoint(x: 178.57, y: 36.29), controlPoint1: CGPoint(x: 153.85, y: 4.88), controlPoint2: CGPoint(x: 171.6, y: 17.93))
		bezierPath.addCurve(to: CGPoint(x: 217.92, y: 63.1), controlPoint1: CGPoint(x: 195.75, y: 36.51), controlPoint2: CGPoint(x: 210.6, y: 47.35))
		bezierPath.addCurve(to: CGPoint(x: 224.41, y: 62.51), controlPoint1: CGPoint(x: 220.01, y: 62.71), controlPoint2: CGPoint(x: 222.19, y: 62.51))
		bezierPath.addCurve(to: CGPoint(x: 255.98, y: 90.27), controlPoint1: CGPoint(x: 241.85, y: 62.51), controlPoint2: CGPoint(x: 255.98, y: 74.94))
		bezierPath.addCurve(to: CGPoint(x: 224.41, y: 118.03), controlPoint1: CGPoint(x: 255.98, y: 105.6), controlPoint2: CGPoint(x: 241.85, y: 118.03))
		bezierPath.addCurve(to: CGPoint(x: 212.85, y: 116.11), controlPoint1: CGPoint(x: 220.33, y: 118.03), controlPoint2: CGPoint(x: 216.43, y: 117.35))
		bezierPath.addCurve(to: CGPoint(x: 178.02, y: 134.37), controlPoint1: CGPoint(x: 204.64, y: 127.24), controlPoint2: CGPoint(x: 192.09, y: 134.37))
		bezierPath.addCurve(to: CGPoint(x: 151.77, y: 125.04), controlPoint1: CGPoint(x: 168.21, y: 134.37), controlPoint2: CGPoint(x: 159.14, y: 130.91))
		bezierPath.addCurve(to: CGPoint(x: 131.83, y: 131.83), controlPoint1: CGPoint(x: 146.25, y: 129.3), controlPoint2: CGPoint(x: 139.33, y: 131.83))
		bezierPath.addCurve(to: CGPoint(x: 112.51, y: 125.51), controlPoint1: CGPoint(x: 124.6, y: 131.83), controlPoint2: CGPoint(x: 117.92, y: 129.48))
		bezierPath.addCurve(to: CGPoint(x: 83.72, y: 132.89), controlPoint1: CGPoint(x: 104.48, y: 130.14), controlPoint2: CGPoint(x: 94.52, y: 132.89))
		bezierPath.addCurve(to: CGPoint(x: 36.66, y: 103.44), controlPoint1: CGPoint(x: 60.57, y: 132.89), controlPoint2: CGPoint(x: 41.24, y: 120.26))
		bezierPath.addCurve(to: CGPoint(x: 35.1, y: 103.48), controlPoint1: CGPoint(x: 36.14, y: 103.46), controlPoint2: CGPoint(x: 35.62, y: 103.48))
		bezierPath.addCurve(to: CGPoint(x: 9.5, y: 80.63), controlPoint1: CGPoint(x: 20.96, y: 103.48), controlPoint2: CGPoint(x: 9.5, y: 93.25))
		bezierPath.addCurve(to: CGPoint(x: 35.1, y: 57.78), controlPoint1: CGPoint(x: 9.5, y: 68.01), controlPoint2: CGPoint(x: 20.96, y: 57.78))
		bezierPath.addCurve(to: CGPoint(x: 45.74, y: 59.84), controlPoint1: CGPoint(x: 38.9, y: 57.78), controlPoint2: CGPoint(x: 42.5, y: 58.52))
		bezierPath.addCurve(to: CGPoint(x: 75.3, y: 41.28), controlPoint1: CGPoint(x: 51.04, y: 48.86), controlPoint2: CGPoint(x: 62.28, y: 41.28))
		bezierPath.addCurve(to: CGPoint(x: 85.56, y: 42.92), controlPoint1: CGPoint(x: 78.88, y: 41.28), controlPoint2: CGPoint(x: 82.33, y: 41.85))
		bezierPath.addCurve(to: CGPoint(x: 133.06, y: 4.88), controlPoint1: CGPoint(x: 90.41, y: 21.15), controlPoint2: CGPoint(x: 109.83, y: 4.88))
		bezierPath.close()
		bezierPath.miterLimit = 22.93;

		bezierPath.lineCapStyle = .round;

		bezierPath.lineJoinStyle = .round;

		strokeColor.setStroke()
		bezierPath.lineWidth = 3

		let scaleX = self.bounds.width * 0.9 / bezierPath.bounds.width
		let scaleY = self.bounds.height * 0.9 / bezierPath.bounds.height

		bezierPath.apply(CGAffineTransform(scaleX: scaleX, y: scaleY))
		bezierPath.stroke()

	}
}
