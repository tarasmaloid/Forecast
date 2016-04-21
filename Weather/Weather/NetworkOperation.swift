//
//  NetworkOperation.swift
//  Weather
//
//  Created by Admin on 19.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

class NetworkOperation{
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    
    
    
    init(url: NSURL){
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion: JSONDictionaryCompletion){
        let request: NSURLRequest = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
           
            if let httpResponse = response as? NSHTTPURLResponse{
                
                switch(httpResponse.statusCode){
                case 200:
                    
                    
                    let jsonDictionary =try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String: AnyObject]
                    completion(jsonDictionary)
                default: print("Get request not succesful")
                }
            }else{
                print("Error")
            }
                
        }
    }
}