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
    
    var cityInformation = ""
    var cityCoordinate = ""
    var correctCityName = ""
    
    
    func getCityCoordinateForZip(zipCode: String) -> Bool {
        let url = NSURL(string: "\(self.baseUrl)address=\(zipCode.stringByReplacingOccurrencesOfString(" ", withString: "+"))&key=\(self.apikey)")
        if url == nil{
            return false
        }
        let data = NSData(contentsOfURL: url!)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        
        
        guard let result =  json["results"] as? NSArray, formattedAddress = result.firstObject?["formatted_address"] as? String
            else {
                return false
        }
        
        self.cityInformation = formattedAddress
        
        if let geometry = result[0]["geometry"] as? NSDictionary {
            if let location = geometry["location"] as? NSDictionary {
                let latitude = location["lat"] as! Float
                let longitude = location["lng"] as! Float
                self.cityCoordinate = "\(latitude),\(longitude)"
            }
        }
        
        if let addressComponents = result[0]["address_components"] as? [[String : AnyObject]]{
           self.correctCityName = addressComponents[0]["long_name"] as! String
        }
        return true
    }
    

}