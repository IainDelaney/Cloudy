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
    
	@IBOutlet weak var spinner: UIActivityIndicatorView!

    
	var locationManager: CLLocationManager = CLLocationManager()

	let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

	var dataTask: NSURLSessionDataTask?

	var APIKey = NSBundle.mainBundle().objectForInfoDictionaryKey("APIKey") as! String
 
    var weatherModel = WeatherModel()
	var iconNames = Set<String>()

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		iconNames.removeAll()
		spinner.startAnimating()
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
				dispatch_async(dispatch_get_main_queue() ) {
					self.spinner.stopAnimating()
				}
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
		self.spinner.stopAnimating()
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
			let dayData = self.weatherModel.days[index]
			dayView?.dayLabel.text = dayData.dateString
			dayView?.forecastLabel.text = dayData.description
			let temperatureString = String(format: "%.0f℃", dayData.temperature)
			dayView?.temperatureLabel.text = temperatureString
			dayView?.iconName = dayData.icon
			loadIcon(dayData.icon)
			view.addSubview(dayView!)

		}
		spinner.stopAnimating()
	}
	
	func loadIcon(iconName: String) {
		if iconNames.contains(iconName) {
			return
		}
		let queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)

		dispatch_async(queue) {
			let iconPath = "http://openweathermap.org/img/w/\(iconName).png"
			if let imageURL = NSURL(string: iconPath) {
				if let imageData = NSData(contentsOfURL: imageURL) {
					if let image = UIImage(data: imageData) {
						self.iconNames.insert(iconName)
						dispatch_async(dispatch_get_main_queue() ) {
							self.updateIcon(iconName,image:image)
						}
					}
				}
			}
		}

	}

	func updateIcon(iconName:String, image:UIImage){
		for view in weatherDays {
			if let dayView = view.subviews[0] as? DayView {
				if dayView.iconName == iconName {
					dayView.weatherIcon.image = image
				}
			}
		}
	}
}

