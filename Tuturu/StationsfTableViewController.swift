//
//  StationsTableViewController.swift
//  Tutu_test
//
//  Created by Dima on 14/06/16.
//  Copyright © 2016 Dima. All rights reserved.
//

import UIKit

class StationsTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {

    var cities = [City]()
    
    var searchResults = [City]()
    var stationsSearch = [[Station]]()
    
    let searchController = UISearchController(searchResultsController: nil)

    let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    
    var completionHandler: ((String) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // indicator setup
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.grayColor()
        view.addSubview(indicator)
        indicator.center = view.center
        
        // searchController setup
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.showsCancelButton = true
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Введите название станции"
        navigationItem.titleView = searchController.searchBar
        
        // tableView height
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return searchResults.count
        }
        
        return cities.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.active && searchController.searchBar.text != "" {
            let city = searchResults[section]
            return city.stations!.count
        }
        
        let city = cities[section]
        return city.stations!.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CityIdentifier", forIndexPath: indexPath)
        
        let station: Station
        
        if searchController.active && searchController.searchBar.text != "" {
            let city = searchResults[indexPath.section]
            station = city.stations![indexPath.row]
        } else {
            let city = cities[indexPath.section]
            station = city.stations![indexPath.row]
        }

        cell.textLabel!.text = station.stationTitle
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if searchController.active && searchController.searchBar.text != "" {
            let city = searchResults[section]
            
            return "\(city.countryTitle!), \(city.cityTitle!)"
        }
        
        let city = cities[section]
        return "\(city.countryTitle!), \(city.cityTitle!)"
    }
    
    // MARK: UITableViewDeligate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let station: Station
        
        if searchController.active && searchController.searchBar.text != "" {
            let city = searchResults[indexPath.section]
            station = city.stations![indexPath.row]
        } else {
            let city = cities[indexPath.section]
            station = city.stations![indexPath.row]
        }
        
        if let title = station.stationTitle {
            completionHandler(title)
        }
        
        searchController.active = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - SearchBarDeligate
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Methods
    
    func filterContactsSearchText(searchText: String) {
        
//        stationsSearch = cities.map({city -> [Station] in
//            city.stations!.filter({ (station) -> Bool in
//                station.stationTitle!.localizedStandardContainsString(searchText)
//            })
//        }).filter {stations -> Bool in
//            stations.count > 0}
        
        searchResults = cities.map({ (city) -> City in
            let stations = city.stations?.filter({ (station) -> Bool in
                station.stationTitle!.localizedCaseInsensitiveContainsString(searchText)
            })
            return City(cityTitle: city.cityTitle!, countryTitle: city.countryTitle!, stations: stations!)
        }).filter({ (city) -> Bool in
            city.stations?.count > 0
        })
        
    }
    
    func loadDepartureCities() {
    indicator.startAnimating()
        TutuClient.loadCities(Route.Departure, success: { (cities) in
            dispatch_async(dispatch_get_main_queue(), { 
                self.cities = cities
                self.tableView.reloadData()
                self.indicator.stopAnimating()
            })
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func loadDestinationCities() {
        indicator.startAnimating()
        TutuClient.loadCities(Route.Destination, success: { (cities) in
            dispatch_async(dispatch_get_main_queue(), {
                self.cities = cities
                self.tableView.reloadData()
                self.indicator.stopAnimating()
            })
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController( searchController: UISearchController) {
        self.filterContactsSearchText(searchController.searchBar.text!)
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowInfoSegue" {
            
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            
            let station: Station
            
            if searchController.active && searchController.searchBar.text != "" {
                let city = searchResults[indexPath!.section]
                station = city.stations![indexPath!.row]
            } else {
                let city = cities[indexPath!.section]
                station = city.stations![indexPath!.row]
            }
            
            var sheduleController = ScheduleViewController()
            
            if let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController {
                if let tabBarController = rootVC.viewControllers.first as? UITabBarController {
                    if let sheduleVC = tabBarController.viewControllers?.first as? ScheduleViewController {
                        sheduleController = sheduleVC
                    }
                }
            }
            
            if let vc = segue.destinationViewController as? StationInfoViewController {
                vc.station = station
                vc.delegate = sheduleController
            }

        }
    }

}
