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

struct WeatherData {
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

protocol ViewModelDelegate: class {
	func updateUI(with weatherData:WeatherData)
}

class ViewModel {
	var weatherData: WeatherData?
	weak var delegate:ViewModelDelegate?

	func loadWeather(latitude:String, longitude: String) {
		let APIKey = Bundle.main.object(forInfoDictionaryKey: "APIKey") as! String
		let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&mode=json&units=metric&cnt=5&APPID=\(APIKey)")
		URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
			if let error = error {
				print(error.localizedDescription)
			} else if let httpResponse = response as? HTTPURLResponse {
				if httpResponse.statusCode == 200 {
					if let data = data {
						let decoder = JSONDecoder()
						do {
							let modelData = try decoder.decode(DataModel.self, from: data)
							let weatherModel = WeatherData.init(modelData)
							DispatchQueue.main.async {
								self.delegate?.updateUI(with: weatherModel)
							}
						} catch let error {
							print(error)
						}
					}
				}
			}
		}).resume()
	}

}
