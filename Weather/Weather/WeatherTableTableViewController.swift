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
        searchController.searchBar.barTintColor = UIColor(red: 51/255, green: 102/255, blue: 153/255, alpha: 1)
        tableView.tableHeaderView = searchController.searchBar
        
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
        } else {
            print("Internet connection FAILED")
            showAlert()
        }
    }
    
    @IBAction func showAlert() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.networkOperation.foundCityName.removeAll()
        self.networkOperation.foundCityInformation.removeAll()
        self.networkOperation.foundCityCoordinate.removeAll()
        
        
        if Reachability.isConnectedToNetwork() {
            cityIsTrue = networkOperation.getCityCoordinateForZip(searchText)
        }
        
        self.tableView.reloadData()
        
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchController.active = false
        self.tableView.reloadData()
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchController.active = false        
        
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
            
            let numberOfRows = self.networkOperation.foundCityName.count
            
            if numberOfRows == 0 {
                return 1
            }else{
                return numberOfRows
            }
            
        }
        return coreDataManager.citiesList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cityTableCellIdentifier, forIndexPath: indexPath)
        
        if(searchController.active.boolValue || searchController.searchBar.text != ""){
            
            let findCityCount = self.networkOperation.foundCityName.count
            
            if (findCityCount > 0){
                
                
                cell.textLabel?.text = networkOperation.foundCityName[indexPath.row]
                cell.detailTextLabel?.text = networkOperation.foundCityInformation[indexPath.row]
                
                
            }else{
                
                cityIsTrue = false
                if Reachability.isConnectedToNetwork(){
                    cell.textLabel?.text = "'\(searchController.searchBar.text!)' not found"
                    cell.detailTextLabel?.text = ""
                }else{
                    cityIsTrue = false
                    cell.textLabel?.text = "No Internet Connection"
                    cell.detailTextLabel?.text = "Make sure your device is connected to the internet."
                }
                
                
            }
            
            
        }else{
            
            cityIsTrue = true
            
            cell.textLabel?.text = coreDataManager.citiesList[indexPath.row].cityName
            cell.detailTextLabel?.text = coreDataManager.citiesList[indexPath.row].cityInformation
            
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
                coreDataManager.addCityData(id, name: networkOperation.foundCityName[indexPath.row], information: networkOperation.foundCityInformation[indexPath.row], coordinate: networkOperation.foundCityCoordinate[indexPath.row])
                
                networkOperation.addCityForecast(id)
                
                
                controller.cityId = id
                
            }else{
                
                let cityId = coreDataManager.citiesList[indexPath.row].id
                
                if (Reachability.isConnectedToNetwork()==true){
                    
                    print("Internet connection OK")
                    
                    coreDataManager.deleteWeatherData(cityId)
                    networkOperation.addCityForecast(cityId)
                }
                controller.cityId = cityId
                
                coreDataManager.viewWillAppearCity()
                tableView.reloadData()
            }
        }
    }
    
}
