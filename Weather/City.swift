//
//  City+CoreDataProperties.swift
//  Weather
//
//  Created by Admin on 26.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

class City : NSManagedObject {

    @NSManaged var cityName: String?
    @NSManaged var cityCoordinate: String?
    @NSManaged var cityInformation: String?
    @NSManaged var id: Int
    
    func saveData(id : Int, name : String, information : String, coordinate: String, inNSManagedContext : NSManagedObjectContext) {
        self.id = id
        self.cityName = name
        self.cityCoordinate = coordinate
        self.cityInformation = information
        
        do{
            try inNSManagedContext.save()
        }catch{}
        
    }

}
