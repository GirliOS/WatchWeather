//
//  ViewController.swift
//  WatchWeather
//
//  Created by girlios on 8/4/15.
//  Copyright © 2015 GirliOS. All rights reserved.
//

import UIKit
import WatchWeatherKit


class ViewController: UIPageViewController {
    
    var data = [Day: Weather]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.whiteColor()  
        setViewControllers([vc], direction: .Forward, animated: true, completion: nil)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible =  true
        

        WeatherClient.sharedClient.requestWeathers { (weather, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error == nil && weather != nil {
                for w in weather! where w != nil {
                    
                    self.data[w!.day] = w
                }
                
                let vc = self.weatherViewControllerForDay(.Today)
                self.setViewControllers([vc], direction: .Forward, animated: false, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: error?.description ?? "Unknown Error", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func weatherViewControllerForDay(day:Day) -> UIViewController {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("WeatherViewController") as! WeatherViewController
        let nav = UINavigationController(rootViewController: vc)
        vc.weather = data[day]
        
        return nav
    }

}

extension ViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let  nav = viewController as? UINavigationController, viewController = nav.viewControllers.first as? WeatherViewController, day = viewController.weather?.day else {
                return nil
        }
        
        if day == .DayBeforeYesterday {
            return nil
        }
        
        guard let earlierDay = Day(rawValue: day.rawValue - 1) else {
            return nil
        }
        
        return self.weatherViewControllerForDay(earlierDay)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let nav = viewController as? UINavigationController, viewController = nav.viewControllers.first as? WeatherViewController,day = viewController.weather?.day else {
            return nil
        }
        
        if day == .DayAfterTomorrow {
            return nil
        }
        
        guard let laterDay = Day(rawValue: day.rawValue + 1) else {
            return nil
        }
        
        return self.weatherViewControllerForDay(laterDay)
    }
}

