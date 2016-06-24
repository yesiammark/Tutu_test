//
//  TutuClient.swift
//  Tutu_test
//
//  Created by Dima on 14/06/16.
//  Copyright © 2016 Dima. All rights reserved.
//

import Foundation
//import Alamofire

enum Route {
    case Departure
    case Destination
}

class TutuClient {
    
    class func loadCities(route: Route, success: (cities: [City]) -> (), fault: (NSError) -> ()) {
        
        let url = NSURL(string: "https://raw.githubusercontent.com/tutu-ru/hire_ios-test/master/allStations.json")
        let urlRequest = NSURLRequest(URL: url!)
        let task = NSURLSession.sharedSession().downloadTaskWithRequest(urlRequest) { (localData, response, error) in
            do {
                let data = NSData(contentsOfURL: localData!)
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                
                switch route {
                case .Departure :
                    if let citiesFrom = json["citiesFrom"] as? [NSDictionary] {
                        let citiesArray = City.generateCities(citiesFrom)
                            success(cities: citiesArray)
                    }

                case .Destination :
                    if let citiesTo = json["citiesTo"] as? [NSDictionary] {
                        let citiesArray = City.generateCities(citiesTo)
                        success(cities: citiesArray)
                    }
                }
                
            } catch {
                fault(error as NSError)
            }
        }
        task.resume()
    }
    
}