//
//  Weather.swift
//  Weather
//
//  Created by Admin on 26.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import CoreData


class Weather: NSManagedObject {

    @NSManaged var id: Int
    @NSManaged var temperatureMax: Double
    @NSManaged var temperatureMin: Double
    @NSManaged var humidity: Double
    @NSManaged var pressure: Double
    @NSManaged var windSpeed: Double
    @NSManaged var precipProbability: Double
    @NSManaged var icon: String?
    @NSManaged var summary: String?
    
    func saveData(id: Int, temperatureMax: Double, temperatureMin: Double, humidity: Double, pressure: Double, windSpeed: Double, precipProbability: Double, icon: String, summary: String, inNSManagedContext : NSManagedObjectContext) {
        
        self.id = id
        self.temperatureMax = (temperatureMax-32) * 5/9 // F --> Cº
        self.temperatureMin = (temperatureMin-32) * 5/9 // F --> Cº
        self.humidity = humidity * 100 // %
        self.pressure = pressure * 0.750063 // mbar --> mm rt st
        self.precipProbability = precipProbability * 100// %
        self.windSpeed = windSpeed * 0.44704 // miles/hour --> m/s
        
        self.icon = icon
        self.summary = summary
        
        try? inNSManagedContext.save()
        
    }

}
