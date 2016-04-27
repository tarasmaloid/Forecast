//
//  WeatherTableTableViewController.swift
//  Weather
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreData

class WeatherTableTableViewController: UITableViewController, UISearchBarDelegate{

    let weatherSegueIdentifier = "WeatherSegueIdentifier"
    let cityTableCellIdentifier = "CityTableCellIdentifier"
    
    @IBOutlet weak var searchBar: UISearchBar!
 
    
    var searchActive : Bool = false
    var cityIsTrue : Bool = true
    
    var findedCity = ""
    
    let coreDataManager = CoreDataManager()
    let networkOperation = NetworkOperation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.leftBarButtonItem = editButtonItem()
        self.tableView.tableFooterView = UIView()
       // self.tableView.editing = true
        coreDataManager.viewWillAppearCity()
     
   }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
      
        findedCity = searchText
        
        if(findedCity==""){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
      
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            self.coreDataManager.deleteCityData(indexPath.row)
            self.coreDataManager.viewWillAppearCity()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }else{
            return
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (searchActive){
            return 1
        }
        return coreDataManager.citiesList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cityTableCellIdentifier, forIndexPath: indexPath)
        if (findedCity=="") {searchActive=false}else {searchActive=true}
        if(searchActive){
            cityIsTrue = networkOperation.getCityCoordinateForZip(String(self.findedCity))
            if (cityIsTrue){
                cell.textLabel?.text = networkOperation.cityInformation
               // cell.textLabel?.text = findedCity
            }else{
                cell.textLabel?.text = "'\(self.findedCity)' not found"
            }
        
        }else{
            cell.textLabel?.text = coreDataManager.citiesList[indexPath.row].valueForKey("cityName") as? String
          
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (findedCity=="") {searchActive=false}else {searchActive=true}
        if (cityIsTrue){
            self.performSegueWithIdentifier(self.weatherSegueIdentifier, sender: indexPath)
        }
    }
    
       override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? ForecastViewController,
            indexPath = sender as? NSIndexPath {
            
            if (searchActive){
                let id = coreDataManager.smallestCityId()
                
                controller.cityName = networkOperation.correctCityName
                coreDataManager.addCityData(id, name: networkOperation.correctCityName, information: networkOperation.cityInformation, coordinate: networkOperation.cityCoordinate)
               controller.cityCoordinate = networkOperation.cityCoordinate
                
                
                
                
            }else{
                networkOperation.getCityCoordinateForZip(String(coreDataManager.citiesList[indexPath.row].valueForKey("cityName")))
                controller.cityName = coreDataManager.citiesList[indexPath.row].valueForKey("cityName") as! String
                controller.cityCoordinate = coreDataManager.citiesList[indexPath.row].valueForKey("cityCoordinate") as! String

            }
            coreDataManager.viewWillAppearCity()
            tableView.reloadData()
            
        }
    }

}
