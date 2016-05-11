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

	var locationManager: CLLocationManager = CLLocationManager()
	var startLocation: CLLocation!

	let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

	var dataTask: NSURLSessionDataTask?

	var APIKey = NSBundle.mainBundle().objectForInfoDictionaryKey("APIKey") as! String
 
    var weatherModel = WeatherModel()
    
	override func viewDidLoad() {
		super.viewDidLoad()

		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		startLocation = nil
	}

	func locationManager(manager: CLLocationManager,
	                     didUpdateLocations locations: [CLLocation])
	{
		let latestLocation: AnyObject = locations[locations.count - 1]

		let latitudeString = String(format: "%.4f",
		                       latestLocation.coordinate.latitude)
		let longitudeString = String(format: "%.4f",
		                        latestLocation.coordinate.longitude)


		if startLocation == nil {
			startLocation = latestLocation as! CLLocation
		}

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
					weatherModel.parseData(data)
				}
			}
		}
		dataTask?.resume()

	}

	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("Location Error")

	}

	func parseWeatherData(data: NSData?) {
		do {
			if let data = data, response = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) as? [String: AnyObject] {

				// Get the results array
				if let city: AnyObject = response["city"] {
					print(city["name"])
				} else {
					print("City not found in dictionary")
				}
				if let list: AnyObject = response["list"] {
					for day in list as! [AnyObject] {
						if let temp:AnyObject = day["temp"] {
							print(temp["day"])
						}
						if let tempArray:AnyObject = day["weather"] {
							let weatherArray = tempArray as! [AnyObject]
							if let weather:AnyObject = weatherArray[0] {
								print(weather["description"])
								print(weather["icon"])
							}
						}

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

