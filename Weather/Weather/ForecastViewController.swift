

//
//  ForecastViewController.swift
//  Weather
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    
    var cityId : Int = 0
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let coreDataManager = CoreDataManager()
    var currentForecastData : [Weather] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreDataManager.viewWillAppearWeather()
        coreDataManager.viewWillAppearCity()
        
        currentForecastData = coreDataManager.getCityForecast(cityId)
        
    }
    let dayTableCellIdentifier = "DayTableCellIdentifier"
    let dayTableSmallCellIdentifier = "DayTableSmallCellIdentifier"
    let currentDate = NSDate()

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentForecastData.count
    }
    
    
    
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        
        self.coreDataManager.viewWillAppearCity()
        self.coreDataManager.viewWillAppearWeather()
        
        self.cityNameLabel.text = self.coreDataManager.getCityName(cityId)
        
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
            baseCell.temperatureLabel?.text = "\(numberFormatter.stringFromNumber(self.currentForecastData[indexPath.row].temperatureMax)!)º"
            baseCell.weatherImage?.image = UIImage(named: self.currentForecastData[indexPath.row].icon!)
            baseCell.summaryLabel?.text = self.currentForecastData[indexPath.row].summary
          
            baseCell.humidityImage?.image = UIImage(named: "humidity")
            baseCell.windImage?.image = UIImage(named: "windSpeed")
            baseCell.precipProbabilityImage?.image = UIImage(named: "precip")
            baseCell.pressureImage?.image = UIImage(named: "pressure")
            
            
            baseCell.humidityLabel?.text = "\(numberFormatter.stringFromNumber(self.currentForecastData[indexPath.row].humidity)!)%"
            baseCell.windLabel?.text = "\(numberFormatter.stringFromNumber(self.currentForecastData[indexPath.row].windSpeed)!)m/s"
            baseCell.precipLabel?.text = "\(numberFormatter.stringFromNumber(self.currentForecastData[indexPath.row].precipProbability)!)%"
            baseCell.pressureLabel?.text = "\(numberFormatter.stringFromNumber(self.currentForecastData[indexPath.row].pressure)!)mm"
            
        }else{
            cell = self.tableView.dequeueReusableCellWithIdentifier(self.dayTableSmallCellIdentifier, forIndexPath: indexPath)
            let smallCell = cell as! MyCustomDaySmallCell
            
            tableView.rowHeight = 100
            
            smallCell.dayLabel?.text = "\(dayName)"
            smallCell.dateLabel?.text = "\(dayDate)"
            smallCell.temperatureLabel?.text = "\(numberFormatter.stringFromNumber(self.currentForecastData[indexPath.row].temperatureMax)!)º / \(numberFormatter.stringFromNumber(self.currentForecastData[indexPath.row].temperatureMin)!)º"
            smallCell.weatherImage?.image = UIImage(named: self.currentForecastData[indexPath.row].icon!)
            
        }
       return cell
    }
    
    
    
}

