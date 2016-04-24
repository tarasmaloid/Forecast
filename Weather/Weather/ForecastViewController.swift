

//
//  ForecastViewController.swift
//  Weather
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    
    private let forecastAPIKey = "15d8d5ecb9ecddd55be4dad88dbccefd"
    
    
    var cityName = ""
    var cityCoordinate = ""
    var daysWeather = [CurrentWeather]()
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
        let forecastURL = NSURL(string: cityCoordinate, relativeToURL: baseURL)
        let weatherData = NSData(contentsOfURL: forecastURL!)
              
        convertToJson(weatherData!)
      
        self.cityNameLabel.text = self.cityName
    }
    let dayTableCellIdentifier = "DayTableCellIdentifier"
    let dayTableSmallCellIdentifier = "DayTableSmallCellIdentifier"
    let currentDate = NSDate()

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.daysWeather.count
    }
    
    
    
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        
        //MyCustomDayCell = self.tableView.dequeueReusableCellWithIdentifier(self.DayTableCellIdentifier) as! MyCustomDayCell
      //  let smallCell : MyCustomDaySmallCell = self.tableView.dequeueReusableCellWithIdentifier(self.DayTableSmallCellIdentifier) as! MyCustomDaySmallCell
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.maximumFractionDigits = 0
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
     
       
        let calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: indexPath.row, toDate: currentDate, options: NSCalendarOptions.init(rawValue: 0))
        
        
        dateFormatter.dateFormat = "EEEE"
        let dayName = dateFormatter.stringFromDate(calculatedDate!)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dayDate = dateFormatter.stringFromDate(calculatedDate!)
        
        if indexPath.row==0{
            cell = self.tableView.dequeueReusableCellWithIdentifier(self.dayTableCellIdentifier, forIndexPath: indexPath)
            let baseCell = cell as! MyCustomDayCell
            
            tableView.rowHeight = 200
        
            baseCell.dayLabel?.text = "\(dayName)"
            baseCell.dateLabel?.text = "\(dayDate)"
            baseCell.temperatureLabel?.text = "\(numberFormatter.stringFromNumber(self.daysWeather[indexPath.row].temperatureMax)!)º"
            baseCell.weatherImage?.image = UIImage(named: daysWeather[indexPath.row].icon)
            baseCell.summaryLabel?.text = daysWeather[indexPath.row].summary
          
            baseCell.humidityImage?.image = UIImage(named: "humidity")
            baseCell.windImage?.image = UIImage(named: "windSpeed")
            baseCell.precipProbabilityImage?.image = UIImage(named: "precip")
            baseCell.pressureImage?.image = UIImage(named: "pressure")
            
            
            baseCell.humidityLabel?.text = "\(numberFormatter.stringFromNumber(daysWeather[indexPath.row].humidity)!)%"
            baseCell.windLabel?.text = "\(numberFormatter.stringFromNumber(daysWeather[indexPath.row].windSpeed)!)m/s"
            baseCell.precipLabel?.text = "\(numberFormatter.stringFromNumber(daysWeather[indexPath.row].precipProbability)!)%"
            baseCell.pressureLabel?.text = "\(numberFormatter.stringFromNumber(daysWeather[indexPath.row].pressure)!)mm"
            
        }else{
            cell = self.tableView.dequeueReusableCellWithIdentifier(self.dayTableSmallCellIdentifier, forIndexPath: indexPath)
            let smallCell = cell as! MyCustomDaySmallCell
            
            tableView.rowHeight = 100
            
            smallCell.dayLabel?.text = "\(dayName)"
            smallCell.dateLabel?.text = "\(dayDate)"
            smallCell.temperatureLabel?.text = "\(numberFormatter.stringFromNumber(self.daysWeather[indexPath.row].temperatureMax)!)º / \(numberFormatter.stringFromNumber(self.daysWeather[indexPath.row].temperatureMin)!)º"
            smallCell.weatherImage?.image = UIImage(named: daysWeather[indexPath.row].icon)
            
        }
       return cell
    }
    
    
    func convertToJson(weatherData:NSData){
        do{
            let jsonData = try NSJSONSerialization.JSONObjectWithData(weatherData, options: []) as! NSDictionary
         
            
            if let currently = jsonData["currently"] as? [String: AnyObject] {
                let temperature = currently["temperature"] as? Double
                let humidity = currently["humidity"] as? Double
                let pressure = currently["pressure"] as? Double
                let windSpeed = currently["windSpeed"] as? Double
                let precipProbability = currently["precipProbability"] as? Double
                let icon = currently["icon"] as? String
                let summary = currently["summary"] as? String;
                
                daysWeather.append(CurrentWeather(temperatureMax: temperature!,temperatureMin: temperature!, humidity: humidity!, pressure: pressure!, windSpeed: windSpeed!, precipProbability: precipProbability!, icon: icon!, summary: summary!))
            }

            
           if let currently = jsonData["daily"] as? [String: AnyObject] {
                    if let datas = currently["data"] as? [[String: AnyObject]]{
                        for data in datas {
                            let temperatureMax = data["temperatureMax"] as? Double
                            let temperatureMin = data["temperatureMin"] as? Double
                            let humidity = data["humidity"] as? Double
                            let pressure = data["pressure"] as? Double
                            let windSpeed = data["windSpeed"] as? Double
                            let precipProbability = data["precipProbability"] as? Double
                            let icon = data["icon"] as? String
                            let summary = data["summary"] as? String
                            
                            daysWeather.append(CurrentWeather(temperatureMax: temperatureMax!,temperatureMin: temperatureMin!, humidity: humidity!, pressure: pressure!, windSpeed: windSpeed!, precipProbability: precipProbability!, icon: icon!, summary: summary!))
                        }
                    }
            }
            
        }catch{
             print("error serializing JSON: \(error)")
        }
    } 

}

