//
//  ScheduleViewController.swift
//  Tutu_test
//
//  Created by Dima on 14/06/16.
//  Copyright © 2016 Dima. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, StationInfoViewControllerDelegate {

    @IBOutlet weak var departureLabel: UITextField!
    @IBOutlet weak var destinationLabel: UITextField!
    @IBOutlet weak var dateSelectControl: UISegmentedControl!
    
    var selectedDate: NSDate?
    var isDeparture = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        departureLabel.delegate = self
        destinationLabel.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultIdentifier", forIndexPath: indexPath)
        
        return cell
    }
    
    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        let segment = sender as! UISegmentedControl
        
        if identifier == "SelectDateSegue" && segment.selectedSegmentIndex == 3 {
            return true
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "DepartureSegue" {
            isDeparture = true
            if let nc = segue.destinationViewController as? UINavigationController {
                if let vc = nc.viewControllers.first as? StationsTableViewController {
                    vc.loadDepartureCities()
                    vc.completionHandler = {title in
                        self.departureLabel.text = title
                    }
                }
                
            }
        }
        
        if segue.identifier == "DestinationSegue" {
            isDeparture = false
            if let nc = segue.destinationViewController as? UINavigationController {
                if let vc = nc.viewControllers.first as? StationsTableViewController {
                    vc.loadDestinationCities()
                    vc.completionHandler = { title in
                        self.destinationLabel.text = title
                    }
                }
            }
        }
        
        if segue.identifier == "SelectDateSegue" {
            if let nc = segue.destinationViewController as? UINavigationController {
                if let vc = nc.viewControllers.first as? DateViewController {
                    vc.selectedDate = selectedDate
                    vc.completionHandler = {date in
                        self.selectedDate = date
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "d.MM"
                        self.dateSelectControl.setTitle(dateFormatter.stringFromDate(date), forSegmentAtIndex: self.dateSelectControl.selectedSegmentIndex)
                    }
                }
            }
        }
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if textField.isEqual(departureLabel) {
            performSegueWithIdentifier("DepartureSegue", sender: textField)
            return false
        }
        
        if textField.isEqual(destinationLabel) {
            performSegueWithIdentifier("DestinationSegue", sender: textField)
            return false
        }
        
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        textField.text = ""
        return false
    }
    
    // MARK: - Actions
    
    @IBAction func SwitchAction(sender: UIButton) {
        let destination = destinationLabel.text
        
        destinationLabel.text = departureLabel.text
        departureLabel.text = destination
    }
    
    @IBAction func dateSelectAction(sender: UISegmentedControl) {
        // Sort schedule results

    }
    
    // MARK: - StationInfoViewControllerDelegate
    
    func stationInfoViewController(stationInfoViewController: StationInfoViewController, didSelectStationName stationName: String) {
        if isDeparture {
            departureLabel?.text = stationName
        } else {
            destinationLabel?.text = stationName
        }
    }
}
