//
//  WeatherModel.swift
//  Cloudy
//
//  Created by Iain Delaney on 2016-05-10.
//  Copyright © 2016 Lucerne Systems. All rights reserved.
//

import Foundation
import UIKit

struct DailyWeather {
	var temperature: Double = 0.0
	var description: String = ""
    var dateString: String = ""
	var icon: String = ""
}

class WeatherModel {
	var city:String = ""
	var days:[DailyWeather] = []

	let dateFormatter = DateFormatter()

	func parseCity(_ response:[String: AnyObject]) {
		if let city = response["city"] as? [String: AnyObject] {
			self.city = city["name"] as! String
		}else{
			self.city = "Unknown City"
		}
	}

	func dateFromToday(_ days:Int) -> String {
		var dateComponent = DateComponents()
		dateComponent.day = days
		let calendar = Calendar.current

        let date = calendar.date(byAdding: dateComponent, to: Date(), wrappingComponents:true )!
		switch days {
		case 0,1:
			dateFormatter.dateStyle = .short
			dateFormatter.doesRelativeDateFormatting = true
		default:
			dateFormatter.dateFormat = "EEEE"
		}
		return dateFormatter.string(from: date)
	}


	func parse(_ data:Data?) {
		do {
			guard let data = data else {
				return
			}
			if let  response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {

				self.parseCity(response)

				if let list = response["list"] as? [[String:AnyObject]] {
					for (index, element) in list.enumerated() {
						var newDay = DailyWeather()
						if let temp = element["temp"] as? [String:AnyObject] {
							newDay.temperature = temp["day"] as! Double
						}
						if let weatherArray:[AnyObject] = element["weather"] as? [AnyObject] {
							if let weather = weatherArray[0] as? [String:AnyObject] {
								newDay.description = weather["main"] as! String
								newDay.icon = weather["icon"] as! String
							}
						}
						newDay.dateString = dateFromToday(index)
						days.append(newDay)
					}
				}else{
					print("List not found in dictionary")
				}
			}
		} catch let error as NSError {
			print("Error parsing results: \(error.localizedDescription)")
		}
	}
}
