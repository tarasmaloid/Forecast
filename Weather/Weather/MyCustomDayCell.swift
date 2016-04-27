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





//
//{
//    results =     (
//        {
//            "address_components" =             (
//                {
//                    "long_name" = Lviv;
//                    "short_name" = Lviv;
//                    types =                     (
//                        locality,
//                        political
//                    );
//                },


//                {
//                    "long_name" = "L'vivs'ka city council";
//                    "short_name" = "L'vivs'ka city council";
//                    types =                     (
//                        "administrative_area_level_3",
//                        political
//                    );
//                },


//                {
//                    "long_name" = "Lviv Oblast";
//                    "short_name" = "Lviv Oblast";
//                    types =                     (
//                        "administrative_area_level_1",
//                        political
//                    );
//                },


//                {
//                    "long_name" = Ukraine;
//                    "short_name" = UA;
//                    types =                     (
//                        country,
//                        political
//                    );
//                }

//            );



//            "formatted_address" = "Lviv, Lviv Oblast, Ukraine";

//            geometry =             {
//                bounds =                 {
//                    northeast =                     {
//                        lat = "49.897471";
//                        lng = "24.118191";
//                    };
//                    southwest =                     {
//                        lat = "49.7679071";
//                        lng = "23.9062801";
//                    };
//                };

//                location =                 {
//                    lat = "49.839683";
//                    lng = "24.029717";
//                };

//                "location_type" = APPROXIMATE;
//                viewport =                 {
//                    northeast =                     {
//                        lat = "49.897471";
//                        lng = "24.118191";
//                    };
//                    southwest =                     {
//                        lat = "49.7679071";
//                        lng = "23.9062801";
//                    };
//                };
//            };
//            "place_id" = ChIJV5oQCXzdOkcR4ngjARfFI0I;
//            types =             (
//                locality,
//                political
//            );
//        }
//    );
//    status = OK;
//}
