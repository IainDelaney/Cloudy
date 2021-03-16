//
//  DayView.swift
//  Cloudy
//
//  Created by Iain Delaney on 2016-05-11.
//  Copyright © 2016 Lucerne Systems. All rights reserved.
//

import UIKit

class DayView: UIView {
    var iconName: String?
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var forecastLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
}
