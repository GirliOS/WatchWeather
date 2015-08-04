//
//  WeatherViewController.swift
//  WatchWeather
//
//  Created by girlios on 8/4/15.
//  Copyright © 2015 GirliOS. All rights reserved.
//

import UIKit
import WatchWeatherKit

class WeatherViewController: UIViewController {


//    enum Day: Int {
//        
//        case DayBeforeYesterday = -2
//        case Yesterday
//        case Today
//        case Tomorrow
//        case DayAfterTomorrow
//        
//        var title: String {
//            
//            let result: String
//            switch self {
//            case .DayBeforeYesterday: result = "前天"
//            case .Yesterday: result = "昨天"
//            case  .Today: result = "今天"
//            case .Tomorrow:result = "明天"
//            case .DayAfterTomorrow: result = "后天"
//            }
//            return result
//            
//        }
//    }
    

//    var day : Day? {
//        didSet {
//            title = day?.title
//        }
//    }
    var weather: Weather? {
        didSet {
            title = weather?.day.title
        }
    }
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var lowTemprature: UILabel!
    @IBOutlet weak var highTemprature: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lowTemprature.text = "\(weather!.lowTemperature)℃"
        highTemprature.text = "\(weather!.highTemperature)℃"
        
        let imageName: String
        switch weather!.state {
        case .Sunny: imageName = "sunny"
        case .Cloudy: imageName = "cloudy"
        case .Rain: imageName = "rain"
        case .Snow: imageName = "snow"
        }
        
        weatherImage.image = UIImage(named: imageName)
    }
    


}
