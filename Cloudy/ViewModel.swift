//
//  ViewModel.swift
//  Cloudy
//
//  Created by Iain Delaney on 2020-05-09.
//  Copyright © 2020 Lucerne Systems. All rights reserved.
//

import Foundation

struct DailyWeather {
	let temperature: Float
	let description: String
    let dateString: String
	let icon: String

	init(_ weatherModel: WeatherModel, index: Int) {
		self.temperature = weatherModel.temp.day
		self.description = weatherModel.weather[0].description
		self.icon = weatherModel.weather[0].icon
		let dateFormatter = DateFormatter()
		var dateComponent = DateComponents()
		dateComponent.day = index
		let calendar = Calendar.current
        let date = calendar.date(byAdding: dateComponent, to: Date(), wrappingComponents:true )!
		switch index {
		case 0,1:
			dateFormatter.dateStyle = .short
			dateFormatter.doesRelativeDateFormatting = true
		default:
			dateFormatter.dateFormat = "EEEE"
		}

		self.dateString = dateFormatter.string(from: date)
	}
}

struct ViewModel {
	let city:String
	var days:[DailyWeather]
	init(_ dataModel: DataModel) {
		self.city = dataModel.city.name
		days = [DailyWeather]()
		for (index,model) in dataModel.list.enumerated() {
			days.append(DailyWeather.init(model, index: index))
		}
	}
}
