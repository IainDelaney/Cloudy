//
//  DayView.swift
//  Cloudy
//
//  Created by Iain Delaney on 2016-05-11.
//  Copyright © 2016 Lucerne Systems. All rights reserved.
//

import UIKit

class DayView: UIView {

//	let cloudView = CloudView(frame: CGRect(x: 28, y: 0, width: 249, height: 137))
	let dayLabel = UILabel(frame: CGRect(x: 86, y: 129, width: 120, height: 21))
	let tempLabel = UILabel(frame: CGRect(x: 118, y: 84, width: 64, height: 21))
	let forecastlabel = UILabel(frame: CGRect(x: 85, y: 67, width: 162, height: 21))

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
//		self.addSubview(cloudView)
		dayLabel.textAlignment = .Center
		dayLabel.text = "Day label"
		self.addSubview(dayLabel)
		tempLabel.textAlignment = .Center
		tempLabel.text = "10 C"
		self.addSubview(tempLabel)
		forecastlabel.textAlignment = .Center
		forecastlabel.text = "forecast label"
		self.addSubview(forecastlabel)
	}
	override func layoutSubviews() {
//		let cloudRect = CGRect(x: 28, y: 0, width: 249, height: 137)
//		cloudView.frame = cloudRect
		let dayRect = CGRect(x: 86, y: 129, width: 120, height: 21)
		dayLabel.frame = dayRect

		let tempRect = CGRect(x: 118, y: 84, width: 64, height: 21)
		tempLabel.frame = tempRect

		let forecastRect = CGRect(x: 85, y: 67, width: 162, height: 21)
		forecastlabel.frame = forecastRect

//		cloudView.setNeedsDisplay()

	}

}
