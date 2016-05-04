//
//  CoreDataManager.swift
//  Weather
//
//  Created by Admin on 26.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager{
    
    var citiesList = [City]()
    var weatherList = [Weather]()
    
    func addCityData(id: Int, name: String, information : String, coordinate : String) {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("City",
                                                        inManagedObjectContext:managedContext)
        
        let city = NSManagedObject(entity: entity!,
                                   insertIntoManagedObjectContext: managedContext) as? City
        city?.saveData(id, name: name, information: information, coordinate: coordinate, inNSManagedContext: managedContext)
        
        viewWillAppearCity()
        
    }
    
    func deleteCityData(index : Int) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.managedObjectContext
        managedContext.deleteObject(citiesList[index] as NSManagedObject)
        
        citiesList.removeAtIndex(index)
        do{
            try managedContext.save()
        }catch{
        }
        
        viewWillAppearCity()
    }
    
    func viewWillAppearCity() {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "City")
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            
            citiesList = results as! [City]
            citiesList =  citiesList.reverse()
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func addWeatherData(cityId: Int, temperatureMax:Double, temperatureMin: Double, humidity: Double, pressure: Double, windSpeed: Double, precipProbability: Double, icon: String, summary: String) {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Weather",
                                                        inManagedObjectContext:managedContext)
        
        let weather = NSManagedObject(entity: entity!,
                                      insertIntoManagedObjectContext: managedContext) as? Weather
        weather!.saveData(cityId, temperatureMax: temperatureMax, temperatureMin: temperatureMin, humidity: humidity, pressure: pressure, windSpeed: windSpeed, precipProbability: precipProbability, icon: icon, summary: summary, inNSManagedContext: managedContext)
        
        viewWillAppearWeather()
        
    }
    
    func viewWillAppearWeather() {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Weather")
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            weatherList = results as! [Weather]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func deleteWeatherData(cityId : Int) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.managedObjectContext
        
        
        
        
        for index in 0...self.weatherList.count-1 {
            if (self.weatherList[index].id == cityId){
                managedContext.deleteObject(weatherList[index] as NSManagedObject)
                
                do{
                    try managedContext.save()
                }catch{}
                
            }
        }
        viewWillAppearWeather()
        
    }
    
    
    func smallestCityId() -> Int {
        
        let citiesIDs = self.citiesList.map { $0.id }
        var i = 0
        
        while citiesIDs.contains(i) {
            i=i+1
        }
        return i
    }
    
    func getCityForecast(id: Int) -> [Weather]{
        var currentCityForecast = [Weather]()
        viewWillAppearWeather()
        
        for index in 0...self.weatherList.count-1 {
            if (self.weatherList[index].id == id){
                currentCityForecast.append(weatherList[index])
            }
        }       
        
        return currentCityForecast
    }
    
    
    func getCityCoordinate(cityId: Int) -> String{
        viewWillAppearCity()
        
        for index in 0...self.citiesList.count-1 {
            if (self.citiesList[index].id == cityId){
                return self.citiesList[index].cityCoordinate!
            }
        }
        return ""
    }
    
    func getCityName(cityId: Int) -> String{
        viewWillAppearCity()
        
        for index in 0...self.citiesList.count-1 {
            if (self.citiesList[index].id == cityId){
                return self.citiesList[index].cityName!
            }
        }
        return ""
    }
    
    
    
}
