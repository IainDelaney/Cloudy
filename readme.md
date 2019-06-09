#Cloudy App for iOS 9
Cloudy is a single-view app originally written in Swift 2.0 for iOS 9.x. Cloudy runs on the iPhone 6 and up in portrait mode, and the iPad in portrait and landscape mode.
Cloudy has been updated to swift 4.2.

Cloudy needs location services to find your local weather, and retrieves weather information from [openweathermap.org](http://openweathermap.org).

**Notes:**

The BezierPath for the cloud outline was created with the PaintCode tool.

Error handling on the network calls and JSON parsing is not exhaustive.

The App has not been localized yet. Server calls are hard-coded for temperature in Celsius.

The server API call requires an API key which is stored in the App's info.plist. You will need to get your own API key from [openweathermap.org](http://openweathermap.org) in order to run the app.

This app was tested on an iPhone 6s and iPad Mini.

