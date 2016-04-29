//
//  NetworkOperation.swift
//  Weather
//
//  Created by Admin on 26.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

class NetworkOperation{
    
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    let apikey = "AIzaSyAvvD1EYt8vfxkunLsEc5SdNYZ1O0mgN6E"
    
    let forecastAPIKey = "15d8d5ecb9ecddd55be4dad88dbccefd"
    
    
    
    
    let coreDataManager = CoreDataManager()
    
    var foundCityName = [String]()
    var foundCityInformation = [String]()
    var foundCityCoordinate = [String]()
    
    
    
    
    func getCityCoordinateForZip(zipCode: String) -> Bool {
        
        
        
        let url = NSURL(string: "\(self.baseUrl)address=\(zipCode.stringByReplacingOccurrencesOfString(" ", withString: "+"))&key=\(self.apikey)")
        
        if (url == nil || zipCode == ""){
            return false
        }
        let data = NSData(contentsOfURL: url!)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        
        let result =  json["results"] as? [[String: AnyObject]]
        for res in result! {
            
            let cityInfo = res["formatted_address"] as? String
            
            foundCityInformation.append(cityInfo!)
            
            if let geometry = res["geometry"] as? NSDictionary {
                if let location = geometry["location"] as? NSDictionary {
                    let latitude = location["lat"] as! Float
                    let longitude = location["lng"] as! Float
                    foundCityCoordinate.append("\(latitude),\(longitude)")
                }
            }
            
            if let addressComponents = res["address_components"] as? [[String : AnyObject]]{
                
                let cityName = addressComponents[0]["long_name"] as! String
                foundCityName.append(cityName)
            }
            
        }
        
        return true
    }
    
    
    func addCityForecast(cityId : Int){
        
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
        let forecastURL = NSURL(string: self.coreDataManager.getCityCoordinate(cityId), relativeToURL: baseURL)
        let weatherData = NSData(contentsOfURL: forecastURL!)
        
        let coreDataManager = CoreDataManager()
        
        do{
            let jsonData = try NSJSONSerialization.JSONObjectWithData(weatherData!, options: []) as! NSDictionary
            
            
            if let currently = jsonData["currently"] as? [String: AnyObject] {
                let temperature = currently["temperature"] as? Double
                let humidity = currently["humidity"] as? Double
                let pressure = currently["pressure"] as? Double
                let windSpeed = currently["windSpeed"] as? Double
                let precipProbability = currently["precipProbability"] as? Double
                let icon = currently["icon"] as? String
                let summary = currently["summary"] as? String;
                
                coreDataManager.addWeatherData(cityId, temperatureMax: temperature!,temperatureMin: temperature!, humidity: humidity!, pressure: pressure!, windSpeed: windSpeed!, precipProbability: precipProbability!, icon: icon!, summary: summary!)
                
            }
            
            
            if let currently = jsonData["daily"] as? [String: AnyObject] {
                if let datas = currently["data"] as? [[String: AnyObject]]{
                    for data in datas {
                        let temperatureMax = data["temperatureMax"] as? Double
                        let temperatureMin = data["temperatureMin"] as? Double
                        let humidity = data["humidity"] as? Double
                        let pressure = data["pressure"] as? Double
                        let windSpeed = data["windSpeed"] as? Double
                        let precipProbability = data["precipProbability"] as? Double
                        let icon = data["icon"] as? String
                        let summary = data["summary"] as? String
                        
                        coreDataManager.addWeatherData(cityId, temperatureMax: temperatureMax!,temperatureMin: temperatureMin!, humidity: humidity!, pressure: pressure!, windSpeed: windSpeed!, precipProbability: precipProbability!, icon: icon!, summary: summary!)
                    }
                }
            }
            
            
        }catch{
            print("error serializing JSON: \(error)")
        }
    }
    
    
    
}