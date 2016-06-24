//
//  City.swift
//  Tutu_test
//
//  Created by Dima on 14/06/16.
//  Copyright © 2016 Dima. All rights reserved.
//

import Foundation

class City {
    
    struct Point {
        var longitude: Double?
        var latitude: Double?
    }
    
    var countryTitle: String?
    var point: Point?
    var districtTitle: String?
    var cityId: Int?
    var cityTitle: String?
    var regionTitle: String?
    var stations: [Station]?
    
    init(dictionary: NSDictionary) {
        if let countryTitle = dictionary["countryTitle"] as? String {
            self.countryTitle = countryTitle
        }
        if let locationPoint = dictionary["point"] as? NSDictionary {
            point = Point()
            if let longitude = locationPoint["longitude"] as? Double {
                point?.longitude = longitude
            }
            if let latitude = locationPoint["latitude"] as? Double {
                point?.latitude = latitude
            }
        }
        if let districtTitle = dictionary["districtTitle"] as? String {
            self.districtTitle = districtTitle
        }
        if let cityId = dictionary["cityId"] as? Int {
            self.cityId = cityId
        }
        if let cityTitle = dictionary["cityTitle"] as? String {
            self.cityTitle = cityTitle
        }
        if let regionTitle = dictionary["regionTitle"] as? String {
            self.regionTitle = regionTitle
        }
        if let stationsArray = dictionary["stations"] as? [NSDictionary] {
            stations = Station.generateStations(stationsArray)
        }
    }
    
    init(cityTitle: String, countryTitle: String, stations: [Station]) {
        self.cityTitle = cityTitle
        self.countryTitle = countryTitle
        self.stations = stations
    }
    
    class func generateCities(dictionaries: [NSDictionary]) -> [City] {
        var cities = [City]()
        
        for item in dictionaries {
        let city = City(dictionary: item)
            cities.append(city)
        }
    
        return cities
    }
}