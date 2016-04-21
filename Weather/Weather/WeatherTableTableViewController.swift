//
//  WeatherTableTableViewController.swift
//  Weather
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class WeatherTableTableViewController: UITableViewController {

    let WeatherSegueIdentifier = "WeatherSegueIdentifier"
    let CityTableCellIdentifier = "CityTableCellIdentifier"
    
    
    let dictionaryCity = [
        "Lviv":"49.839683,24.029717",
        "Kyiv":"50.451366,30.528785",
        "Barcelona":"41.385064,2.173403",
        "London":"51.507351,-0.127758"
    ]
    let cities = ["Lviv", "Kyiv", "Barcelona", "London"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dictionaryCity.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.CityTableCellIdentifier, forIndexPath: indexPath)
        
        
        cell.textLabel?.text = self.cities[indexPath.row]
        
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(self.WeatherSegueIdentifier, sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? ForecastViewController,
            indexPath = sender as? NSIndexPath {
            
           // let index = dictionaryCity.startIndex.advancedBy(indexPath.row)
            controller.cityName = String(cities[indexPath.row])
            controller.cityCoordinate = String(dictionaryCity[cities[indexPath.row]]!)
        }
    }

}
