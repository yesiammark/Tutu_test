//
//  StationInfoViewController.swift
//  Tutu_test
//
//  Created by Dima on 14/06/16.
//  Copyright © 2016 Dima. All rights reserved.
//

import UIKit
import MapKit

protocol StationInfoViewControllerDelegate {
    func stationInfoViewController(stationInfoViewController: StationInfoViewController, didSelectStationName stationName: String)
}

class StationInfoViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapInfo: MKMapView!
    @IBOutlet weak var staionLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var selectButton: UIButton!

    var station: Station?
    var delegate: StationInfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        streetLabel.text = ""
        locationLabel.text = ""
        staionLabel.text = station?.stationTitle
        navigationItem.title = station?.stationTitle
        
        if let stationPoint = station?.point {
            
            guard let latitude = stationPoint.latitude else {return}
            guard let longitude = stationPoint.longitude else {return}
            
            let stationLocation = CLLocationCoordinate2DMake(latitude, longitude)
            let pin = MKPointAnnotation()
            pin.coordinate = stationLocation
            mapInfo.showAnnotations([pin], animated: true)
            
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                var placeMark: CLPlacemark!
                placeMark = placemarks?.first
                
                // Street address
                if let street = placeMark.addressDictionary?["Thoroughfare"] as? String
                {
                    self.streetLabel.text = street
                }
                
                // Street Number
                if let streetNumber = placeMark.addressDictionary?["SubThoroughfare"] as? String
                {
                    self.streetLabel.text = self.streetLabel.text! + ", " + streetNumber
                }
                // Country
                if let country = placeMark.addressDictionary?["Country"] as? String
                {
                    self.locationLabel.text = country
                }
                // Region
                if let region = placeMark.addressDictionary?["State"] as? String
                {
                    self.locationLabel.text = self.locationLabel.text! + ", " + region
                }
                
                // City
                if let city = placeMark.addressDictionary?["City"] as? String
                {
                    self.locationLabel.text = self.locationLabel.text! + "\n" + city
                }
            })
        }
        
        view.bringSubviewToFront(selectButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func selectStationAction(sender: UIButton) {
        
        // TODO: Pass data to delegate
        delegate?.stationInfoViewController(self, didSelectStationName: station!.stationTitle!)
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
