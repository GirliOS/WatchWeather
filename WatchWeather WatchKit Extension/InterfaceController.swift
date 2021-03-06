//
//  InterfaceController.swift
//  WatchWeather WatchKit Extension
//
//  Created by girlios on 8/4/15.
//  Copyright © 2015 GirliOS. All rights reserved.
//

import WatchKit
import Foundation
import WatchWeatherFramework


class InterfaceController: WKInterfaceController {

    @IBOutlet var weatherImage: WKInterfaceImage!
    @IBOutlet var highTempratureLabel: WKInterfaceLabel!
    @IBOutlet var lowTempratureLabel: WKInterfaceLabel!
    
    static var index = Day.DayBeforeYesterday.rawValue
    static var controllers = [Day: InterfaceController]()
    static var token: dispatch_once_t = 0
    
    var weather: Weather? {
        didSet {
            if let w = weather {
                updateWeather(w)
            }
        }
    }
    
    func request() {
        WeatherClient.sharedClient.requestWeathers({ [weak self] (weathers, error) -> Void in
            if let weathers = weathers {
                for weather in weathers where weather != nil {
                    guard let controller = InterfaceController.controllers[weather!.day] else {
                        continue
                    }
                    controller.weather = weather
                }
            } else {
                let action = WKAlertAction(title: "Retry", style: .Default, handler: { () -> Void in
                    self?.request()
                })
                let errorMessage = (error != nil) ? error!.description : "Unknown Error"
                self?.presentAlertControllerWithTitle("Error", message: errorMessage, preferredStyle: .Alert, actions: [action])
            }
            })
    }
    
    func updateWeather(weather: Weather) {
        lowTempratureLabel.setText("\(weather.lowTemperature)℃")
        highTempratureLabel.setText("\(weather.highTemperature)℃")
        
        let imageName: String
        switch weather.state {
        case .Sunny: imageName = "sunny"
        case .Cloudy: imageName = "cloudy"
        case .Rain: imageName = "rain"
        case .Snow: imageName = "snow"
        }
        
        weatherImage.setImageNamed(imageName)
    }
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        guard let day = Day(rawValue: InterfaceController.index) else {
            return
        }
        
        InterfaceController.controllers[day] = self
        InterfaceController.index = InterfaceController.index + 1
        
        if day == .Today {
            becomeCurrentPage()
        }
        
        dispatch_once(&InterfaceController.token) { () -> Void in
            self.request()
        }
        
    }

    override func willActivate() {
        super.willActivate()
        if let w = weather {
            updateWeather(w)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
