//
//  City.swift
//  Tutu_test
//
//  Created by Dima on 14/06/16.
//  Copyright © 2016 Dima. All rights reserved.
//

import Foundation

class Station {
    
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
    var stationId: Int?
    var stationTitle: String?
    
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
        if let stationId = dictionary["stationId"] as? Int {
            self.stationId = stationId
        }
        if let stationTitle = dictionary["stationTitle"] as? String {
            self.stationTitle = stationTitle
        }
    }
    
    class func generateStations(dictionaries: [NSDictionary]) -> [Station] {
        var stations = [Station]()
        
        for item in dictionaries {
            let station = Station(dictionary: item)
            stations.append(station)
        }
        
        return stations
    }
    
}