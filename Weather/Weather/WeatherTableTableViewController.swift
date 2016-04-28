//
//  WeatherTableTableViewController.swift
//  Weather
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

//nsfetchedresultcontroller

import UIKit
import CoreData

class WeatherTableTableViewController: UITableViewController, UISearchBarDelegate{

    let weatherSegueIdentifier = "WeatherSegueIdentifier"
    let cityTableCellIdentifier = "CityTableCellIdentifier"
 
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var cityIsTrue : Bool = true
    
    let coreDataManager = CoreDataManager()
    let networkOperation = NetworkOperation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        self.tableView.tableFooterView = UIView()
  
        coreDataManager.viewWillAppearCity()
        coreDataManager.viewWillAppearWeather()
     
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar

   }

    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchController.active = false
        self.tableView.reloadData()
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.tableView.reloadData()
    }
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.tableView.reloadData()
        return true
    }
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.tableView.reloadData()
        return true
    }
    
 
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 1
    }
    
      
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(!searchController.active.boolValue && searchController.searchBar.text == ""){
            self.coreDataManager.viewWillAppearWeather()
            self.coreDataManager.viewWillAppearCity()
            
            if editingStyle == .Delete{
                self.coreDataManager.deleteWeatherData(self.coreDataManager.citiesList[indexPath.row].id)
                self.coreDataManager.deleteCityData(indexPath.row)
                self.coreDataManager.viewWillAppearWeather()
                self.coreDataManager.viewWillAppearCity()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }else{
                return
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (searchController.active.boolValue || searchController.searchBar.text != ""){
            
//            print(searchController.active.boolValue)
//            print(searchController.searchBar.text != "")
            
            return 1
            
        }
        return coreDataManager.citiesList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cityTableCellIdentifier, forIndexPath: indexPath)
      
        if(searchController.active.boolValue || searchController.searchBar.text != ""){
            
            cityIsTrue = networkOperation.getCityCoordinateForZip(searchController.searchBar.text!)
            if (cityIsTrue){
//                cell.textLabel?.text = networkOperation.findedCities[indexPath.row].cityInformation
                cell.textLabel?.text = networkOperation.cityInformation

            }else{
                cell.textLabel?.text = "'\(searchController.searchBar.text!)' not found"
            }           
            
        
        }else{
            cell.textLabel?.text = coreDataManager.citiesList[indexPath.row].cityName
        }
        
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (cityIsTrue){
            self.performSegueWithIdentifier(self.weatherSegueIdentifier, sender: indexPath)
        }
        
    }
    
       override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? ForecastViewController,
            indexPath = sender as? NSIndexPath {
            
            self.coreDataManager.viewWillAppearCity()
            self.coreDataManager.viewWillAppearWeather()
            
            if (searchController.active.boolValue || searchController.searchBar.text != ""){
                
                let id = coreDataManager.smallestCityId()
//                coreDataManager.addCityData(id, name: networkOperation.findedCities[indexPath.row].cityName!, information: networkOperation.findedCities[indexPath.row].cityInformation!, coordinate: networkOperation.findedCities[indexPath.row].cityCoordinate!)
                    coreDataManager.addCityData(id, name: networkOperation.correctCityName, information: networkOperation.cityInformation, coordinate: networkOperation.cityCoordinate)

                
                networkOperation.addCityForecast(id)
                
                
//                searchController.active = false
//                searchController.searchBar.text = ""
                //tableView.reloadData()
                
                 controller.cityId = id
                
            }else{
                //networkOperation.getCityCoordinateForZip(String(coreDataManager.citiesList[indexPath.row].cityName))
                let cityId = coreDataManager.citiesList[indexPath.row].id
                
                coreDataManager.deleteWeatherData(cityId)
                networkOperation.addCityForecast(cityId)
                
                controller.cityId = cityId
                
            }
            coreDataManager.viewWillAppearCity()
            tableView.reloadData()
        }
    }

}
