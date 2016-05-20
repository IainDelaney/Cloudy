//
//  ViewController.swift
//  Cloudy
//
//  Created by Iain Delaney on 2016-05-10.
//  Copyright © 2016 Lucerne Systems. All rights reserved.
//

import UIKit
import CoreLocation

class CloudyViewController: UIViewController, CLLocationManagerDelegate {

	@IBOutlet weak var cityLabel: UILabel!

	@IBOutlet var weatherDays: [UIView]!
    
	@IBOutlet weak var spinner: UIActivityIndicatorView!

    
	var locationManager: CLLocationManager = CLLocationManager()

	let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

	var dataTask: NSURLSessionDataTask?

	var APIKey = NSBundle.mainBundle().objectForInfoDictionaryKey("APIKey") as! String
 
    var weatherModel = WeatherModel()
	var iconNames = Set<String>()

	var haveLocation = false

	override func viewDidLoad() {
		for view in weatherDays {
			let dayView = UINib(nibName: "DayView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? DayView
			dayView!.frame = view.bounds
			view.addSubview(dayView!)
		}
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		startUI()
	}

	func startUI() {
		haveLocation = false
        iconNames.removeAll()
        spinner.startAnimating()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
		locationManager.requestLocation()

    }
	func locationManager(manager: CLLocationManager,
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

		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		let url = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitudeString)&lon=\(longitudeString)&mode=json&units=metric&cnt=5&APPID=\(APIKey)")

		defaultSession.dataTaskWithURL(url!, completionHandler: { data, response, error in
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
		}).resume()
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
			let dayView = view.subviews[0] as? DayView
			let dayData = self.weatherModel.days[index]
			print(dayData)
			dayView?.dayLabel.text = dayData.dateString
			dayView?.forecastLabel.text = dayData.description
			let temperatureString = String(format: "%.0f℃", dayData.temperature)
			dayView?.temperatureLabel.text = temperatureString
			dayView?.iconName = dayData.icon
			self.iconNames.insert(dayData.icon)
		}
		spinner.stopAnimating()
		loadIcons()
	}
	
	func loadIcons() {

		for iconName in self.iconNames {
            let iconPath = "http://openweathermap.org/img/w/\(iconName).png"
            let imageURL = NSURL(string: iconPath)
            defaultSession.dataTaskWithURL(imageURL!, completionHandler: {
                data,response, error in
				if let error = error {
					dispatch_async(dispatch_get_main_queue() ) {
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
                    dispatch_async(dispatch_get_main_queue() ) {
                        self.updateIcon(iconName,image:image)
                    }
                }
            }).resume()
        }
	}

	func updateIcon(iconName:String, image:UIImage){
		for view in self.weatherDays {
			if let dayView = view.subviews[0] as? DayView {
				if dayView.iconName == iconName {
					dayView.weatherIcon.image = image
				}
			}
		}
	}
}

