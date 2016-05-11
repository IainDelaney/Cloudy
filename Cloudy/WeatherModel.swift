//
//  WeatherModel.swift
//  Cloudy
//
//  Created by Iain Delaney on 2016-05-10.
//  Copyright © 2016 Lucerne Systems. All rights reserved.
//

import Foundation

struct DailyWeather {
	var temperature: Double
	var description: String
	var icon: String
    var todayDate: NSDate
}

class WeatherModel {
	var city:String
	var days:[DailyWeather]

	func parseData(data:NSData) {
		do {
			if let data = data, response = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) as? [String: AnyObject] {

				// Get the results array
				if let city: AnyObject = response["city"] {
					self.city = (city["name"])
				} else {
					print("City not found in dictionary")
				}
				if let list: AnyObject = response["list"] {
					for day in list as! [AnyObject] {
						let newDay = DailyWeather()
						if let temp:AnyObject = day["temp"] {
							newDay.temperature = Double((temp["day"]))
						}
						if let tempArray:AnyObject = day["weather"] {
							let weatherArray = tempArray as! [AnyObject]
							if let weather:AnyObject = weatherArray[0] {
								newDay.description = weather["description"]
								newDay.icon = weather["icon"]
							}
						}
						days.append(newDay)
					}
				}else{
					print("List not found in dictionary")
				}
			} else {
				print("JSON Error")
			}
		} catch let error as NSError {
			print("Error parsing results: \(error.localizedDescription)")
		}
	}
}
