//
//  WeatherDataOperation.swift
//  Weather
//
//  Created by Admin on 23.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

class WeatherDataOperation {
    
    internal var daysWeather = [CurrentWeather]()



func getDataFromApi(cityCoordinate: String){
    
    let forecastAPIKey = "15d8d5ecb9ecddd55be4dad88dbccefd"
    let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
    let forecastURL = NSURL(string: cityCoordinate, relativeToURL: baseURL)
    let weatherData = NSData(contentsOfURL: forecastURL!)

    
    convertToJson(weatherData!)
    
}



func convertToJson(weatherData:NSData){
    do{
        let jsonData = try NSJSONSerialization.JSONObjectWithData(weatherData, options: []) as! NSDictionary
        
        
        if let currently = jsonData["currently"] as? [String: AnyObject] {
            if let temperature = currently["temperature"] as? Double {
                if let humidity = currently["humidity"] as? Double{
                    if let pressure = currently["pressure"] as? Double{
                        if let windSpeed = currently["windSpeed"] as? Double{
                            if let precipProbability = currently["precipProbability"] as? Double{
                                if let icon = currently["icon"] as? String{
                                    if let summary = currently["summary"] as? String{                                                                                       daysWeather.append(CurrentWeather(temperatureMax: temperature,temperatureMin: temperature, humidity: humidity, pressure: pressure, windSpeed: windSpeed, precipProbability: precipProbability, icon: icon, summary: summary))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        if let currently = jsonData["daily"] as? [String: AnyObject] {
            if let datas = currently["data"] as? [[String: AnyObject]]{
                for data in datas {
                    if let temperatureMax = data["temperatureMax"] as? Double {
                        if let temperatureMin = data["temperatureMin"] as? Double {
                            if let humidity = data["humidity"] as? Double{
                                if let pressure = data["pressure"] as? Double{
                                    if let windSpeed = data["windSpeed"] as? Double{
                                        if let precipProbability = data["precipProbability"] as? Double{
                                            if let icon = data["icon"] as? String{
                                                if let summary = data["summary"] as? String{
                                                    daysWeather.append(CurrentWeather(temperatureMax: temperatureMax,temperatureMin: temperatureMin, humidity: humidity, pressure: pressure, windSpeed: windSpeed, precipProbability: precipProbability, icon: icon, summary: summary))
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }catch{
        print("error serializing JSON: \(error)")
    }
    }
}
