//
//  DetailWeatherViewController.swift
//  Weather
//
//  Created by Admin on 29.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class DetailWeatherViewController: UIViewController {
    
    var cityName = ""
    var currentDayIndex = 0
    var currentForecastData : [Weather] = []
    let currentDate = NSDate()
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    
    @IBOutlet weak var minTemperatureLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipProbabilityLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.maximumFractionDigits = 0
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        
        
        let calculatedDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: currentDayIndex, toDate: currentDate, options: NSCalendarOptions.init(rawValue: 0))
        
        
        dateFormatter.dateFormat = "EEEE"
        let dayName = dateFormatter.stringFromDate(calculatedDate!)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dayDate = dateFormatter.stringFromDate(calculatedDate!)

        
        cityNameLabel.text = cityName
        dayNameLabel.text = "\(dayName)"
        dateLabel.text = "\(dayDate)"
        
        if currentDayIndex == 0 {
            weatherImage.image = UIImage(named: self.currentForecastData[currentDayIndex].icon!)

        }else{
            weatherImage.image = UIImage(named: self.currentForecastData[currentDayIndex+1].icon!)
        }
        
        
        
        maxTemperatureLabel.text = "\(numberFormatter.stringFromNumber(self.currentForecastData[currentDayIndex+1].temperatureMax)!)º"
        minTemperatureLabel.text = "\(numberFormatter.stringFromNumber(self.currentForecastData[currentDayIndex+1].temperatureMin)!)º"
        summaryLabel.text = self.currentForecastData[currentDayIndex+1].summary
        humidityLabel.text = "\(numberFormatter.stringFromNumber(self.currentForecastData[currentDayIndex+1].humidity)!)%"
        windSpeedLabel.text = "\(numberFormatter.stringFromNumber(self.currentForecastData[currentDayIndex+1].windSpeed)!)m/s"
        precipProbabilityLabel.text = "\(numberFormatter.stringFromNumber(self.currentForecastData[currentDayIndex+1].precipProbability)!)%"
        pressureLabel.text = "\(numberFormatter.stringFromNumber(self.currentForecastData[currentDayIndex+1].pressure)!)mm"
    }
    
    
  

}