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
//    
    var cityInformation = ""
    var cityCoordinate = ""
    var correctCityName = ""
    
   var findedCities = [City]()
    
    
    let coreDataManager = CoreDataManager()
    
    func getCityCoordinateForZip(zipCode: String) -> Bool {
        
    //    var currentCity = City()
        
        let url = NSURL(string: "\(self.baseUrl)address=\(zipCode.stringByReplacingOccurrencesOfString(" ", withString: "+"))&key=\(self.apikey)")
        if url == nil{
            return false
        }
        let data = NSData(contentsOfURL: url!)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        
        print(json)
        
        guard let result =  json["results"] as? NSArray, formattedAddress = result.firstObject?["formatted_address"] as? String
            else {
                return false
        }
        
        print("")
        
        print(result[0])
        print(result[1])
        
        cityInformation = formattedAddress
       // currentCity.cityInformation = formattedAddress
        
        if let geometry = result[0]["geometry"] as? NSDictionary {
            if let location = geometry["location"] as? NSDictionary {
                let latitude = location["lat"] as! Float
                let longitude = location["lng"] as! Float
               // currentCity.cityCoordinate = "\(latitude),\(longitude)"
                cityCoordinate = "\(latitude),\(longitude)"
            }
        }
        
        if let addressComponents = result[0]["address_components"] as? [[String : AnyObject]]{
           //currentCity.cityName = addressComponents[0]["long_name"] as? String
            correctCityName = addressComponents[0]["long_name"] as! String
        }
        //findedCities.append(currentCity)
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