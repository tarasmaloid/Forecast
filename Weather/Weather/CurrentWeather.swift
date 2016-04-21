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
    let precipProbability: Int
    
    let icon: String
    let summary: String
    
    init(temperatureMax:Double, temperatureMin: Double, humidity: Double, pressure: Double, windSpeed: Double, precipProbability: Int, icon: String, summary: String){
        self.temperatureMax = (temperatureMax-32)*5/9
        self.temperatureMin = (temperatureMin-32)*5/9
        self.humidity = humidity
        self.pressure = pressure
        self.precipProbability = precipProbability
        self.windSpeed = windSpeed
        
        self.icon = icon
        self.summary = summary
    }
}