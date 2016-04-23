//
//  CurrentWeather.swift
//  Weather
//
//  Created by Admin on 18.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

struct CurrentWeather {
    
    let temperatureMax: Double
    let temperatureMin: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let precipProbability: Double
    
    let icon: String
    let summary: String
    
    init(temperatureMax:Double, temperatureMin: Double, humidity: Double, pressure: Double, windSpeed: Double, precipProbability: Double, icon: String, summary: String){
        self.temperatureMax = (temperatureMax-32) * 5/9 // F --> Cº
        self.temperatureMin = (temperatureMin-32) * 5/9 // F --> Cº
        self.humidity = humidity * 100 // %
        self.pressure = pressure * 0.750063 // mbar --> mm rt st
        self.precipProbability = precipProbability * 100// %
        self.windSpeed = windSpeed * 0.44704 // miles/hour --> m/s
        
        self.icon = icon
        self.summary = summary
    }
}