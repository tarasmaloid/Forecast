//
//  MyCustomDayCell.swift
//  Weather
//
//  Created by Admin on 23.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit


class MyCustomDayCell: UITableViewCell{    
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    @IBOutlet weak var humidityImage: UIImageView!
    @IBOutlet weak var windImage: UIImageView!
    @IBOutlet weak var precipProbabilityImage: UIImageView!
    @IBOutlet weak var pressureImage: UIImageView!
    
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var precipLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
}

