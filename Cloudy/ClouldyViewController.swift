//
//  ViewController.swift
//  Cloudy
//
//  Created by Iain Delaney on 2016-05-10.
//  Copyright © 2016 Lucerne Systems. All rights reserved.
//

import UIKit
import CoreLocation

class CloudyViewController: UIViewController, CLLocationManagerDelegate, ViewModelDelegate {

	var viewModel = ViewModel()

	@IBOutlet weak var cityLabel: UILabel!

	@IBOutlet var weatherDays: [UIView]!
    
	@IBOutlet weak var spinner: UIActivityIndicatorView!

	var locationManager: CLLocationManager = CLLocationManager()

	var haveLocation = false

	override func viewDidLoad() {
		viewModel.delegate = self
		
		for view in weatherDays {
			let dayView = UINib(nibName: "DayView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? DayView
			dayView!.frame = view.bounds
			view.addSubview(dayView!)
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		startUI()
	}

	func startUI() {
		haveLocation = false
        spinner.startAnimating()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
		locationManager.requestLocation()

    }
	func locationManager(_ manager: CLLocationManager,
	                     didUpdateLocations locations: [CLLocation])
	{
		if haveLocation {
			return
		}
		haveLocation = true
		let latestLocation = locations[locations.count - 1]

		let latitudeString = String(format: "%.4f",
		                       latestLocation.coordinate.latitude)
		let longitudeString = String(format: "%.4f",
		                        latestLocation.coordinate.longitude)

		viewModel.loadWeather(latitude: latitudeString, longitude: longitudeString)
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}


	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		self.spinner.stopAnimating()
		let alertController = UIAlertController(title: "Location Error", message: "Error finding your location. Please make sure location services are enabled.", preferredStyle: .alert)
		let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

		alertController.addAction(defaultAction)
		present(alertController, animated: true, completion: nil)
	}

	func updateUI(with weatherData:WeatherData) {
		var iconNames = Set<String>()
		self.cityLabel.text = "Weather for \(weatherData.city)"
		for (index, view) in weatherDays.enumerated() {
			let dayView = view.subviews[0] as? DayView
			let dayData = weatherData.days[index]
			dayView?.dayLabel.text = dayData.dateString
			dayView?.forecastLabel.text = dayData.description
			let temperatureString = String(format: "%.0f℃", dayData.temperature)
			dayView?.temperatureLabel.text = temperatureString
			dayView?.iconName = dayData.icon
			iconNames.insert(dayData.icon)
		}
		spinner.stopAnimating()
		loadIcons(iconNames)
	}
	
	func loadIcons(_ iconNames:Set<String>) {

		for iconName in iconNames {
            let iconPath = "https://openweathermap.org/img/w/\(iconName).png"
            let imageURL = URL(string: iconPath)
			URLSession.shared.dataTask(with: imageURL!, completionHandler: {
                data,response, error in
				if let error = error {
					DispatchQueue.main.async {
                        self.spinner.stopAnimating()
					}
					print(error.localizedDescription)
					return
				}
                guard let data = data else {
					print("no data")
                    return
                }
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.updateIcon(iconName,image:image)
                    }
                }
            }).resume()
        }
	}

	func updateIcon(_ iconName:String, image:UIImage){
		for view in self.weatherDays {
			if let dayView = view.subviews[0] as? DayView {
				if dayView.iconName == iconName {
					dayView.weatherIcon.image = image
				}
			}
		}
	}
}

