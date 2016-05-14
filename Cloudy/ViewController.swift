//
//  ViewController.swift
//  Cloudy
//
//  Created by Iain Delaney on 2016-05-10.
//  Copyright © 2016 Lucerne Systems. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

	@IBOutlet weak var cityLabel: UILabel!

	@IBOutlet var weatherDays: [UIView]!
    

    
	var locationManager: CLLocationManager = CLLocationManager()

	let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

	var dataTask: NSURLSessionDataTask?

	var APIKey = NSBundle.mainBundle().objectForInfoDictionaryKey("APIKey") as! String
 
    var weatherModel = WeatherModel()
    

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
	}

	func locationManager(manager: CLLocationManager,
	                     didUpdateLocations locations: [CLLocation])
	{
		let latestLocation = locations[locations.count - 1]

		let latitudeString = String(format: "%.4f",
		                       latestLocation.coordinate.latitude)
		let longitudeString = String(format: "%.4f",
		                        latestLocation.coordinate.longitude)

		locationManager.stopUpdatingLocation()

		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		let url = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitudeString)&lon=\(longitudeString)&mode=json&units=metric&cnt=5&APPID=\(APIKey)")

		dataTask = defaultSession.dataTaskWithURL(url!) { data, response, error in
			dispatch_async(dispatch_get_main_queue()) {
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			}
			if let error = error {
				print(error.localizedDescription)
			} else if let httpResponse = response as? NSHTTPURLResponse {
				if httpResponse.statusCode == 200 {
					self.weatherModel.parseData(data!)
					dispatch_async(dispatch_get_main_queue()) {
						self.updateUI()
					}
				}
			}
		}
		dataTask?.resume()
	}

	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		let alertController = UIAlertController(title: "Location Error", message: "Error finding your location. Please make sure location services are enabled.", preferredStyle: .Alert)
		let defaultAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)

		alertController.addAction(defaultAction)
		presentViewController(alertController, animated: true, completion: nil)
	}

	func updateUI() {
		self.cityLabel.text = "Weather for \(self.weatherModel.city)"
		for (index, view) in weatherDays.enumerate() {
			let dayView = UINib(nibName: "DayView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? DayView
			dayView!.frame = view.bounds
			dayView?.dayLabel.text = self.weatherModel.days[index].dateString
			dayView?.forecastLabel.text = self.weatherModel.days[index].description
			let temperatureString = String(format: "%.0f℃", self.weatherModel.days[index].temperature)
			dayView?.temperatureLabel.text = temperatureString
			view.addSubview(dayView!)

		}

	}
}

