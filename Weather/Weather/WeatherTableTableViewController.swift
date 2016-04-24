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
    
    @IBOutlet weak var searchBar: UISearchBar!
 
    
    var searchActive : Bool = false
    let cities = ["Lviv", "Kyiv", "Barcelona", "London", "Rava-Rus'ka"]
    
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    let apikey = "AIzaSyAvvD1EYt8vfxkunLsEc5SdNYZ1O0mgN6E"
    var cityCoordinate = ""
    var cityInformation = ""
    var findedCity = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
  
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cities.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.CityTableCellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = self.cities[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(self.WeatherSegueIdentifier, sender: indexPath)
    }
    
   
    
    
    func getCityCoordinateForZip(zipCode: String) {
        let url = NSURL(string: "\(baseUrl)address=\(zipCode)&key=\(apikey)")
        let data = NSData(contentsOfURL: url!)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        if let result = json["results"] as? NSArray {
            cityInformation = result[0]["formatted_address"] as! String
            if let geometry = result[0]["geometry"] as? NSDictionary {
                if let location = geometry["location"] as? NSDictionary {
                    let latitude = location["lat"] as! Float
                    let longitude = location["lng"] as! Float
                    cityCoordinate = "\(latitude),\(longitude)"
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? ForecastViewController,
            indexPath = sender as? NSIndexPath {
            getCityCoordinateForZip(String(cities[indexPath.row]))
          
            controller.cityName = String(cities[indexPath.row])
            controller.cityCoordinate = cityCoordinate
        }
    }

}
