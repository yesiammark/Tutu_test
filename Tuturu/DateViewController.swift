//
//  DateViewController.swift
//  Tutu_test
//
//  Created by Dima on 15/06/16.
//  Copyright © 2016 Dima. All rights reserved.
//

import UIKit

protocol DateViewControllerDelegate {
    func dateViewController(dateViewController: DateViewController, didSelectDate date: NSDate)
}

class DateViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var datePicker: UIPickerView!
    
    var datesArray = [NSDate]()
    var selectedDate: NSDate?
    
    var completionHandler: ((NSDate) -> ())!
    
    var delegate:DateViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDates()
        if selectedDate != nil {

            for item in datesArray.enumerate() {
                let order = NSCalendar.currentCalendar().compareDate(selectedDate!, toDate: item.element, toUnitGranularity: [.Month, .Day])
                
                if order == .OrderedSame {
                    datePicker.selectRow(item.index, inComponent: 0, animated: true)
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "EEEE d MMMM"
                    currentDate.text = dateFormatter.stringFromDate(item.element)
                }
            }
            
        } else {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE d MMMM"
            currentDate.text = dateFormatter.stringFromDate(datesArray.first!)
        }
    }
    
    func setUpDates() {
        var date = NSDate()
        for _ in 0...30 {
            datesArray.append(date)
            date = date.dateByAddingTimeInterval(86400)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datesArray.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE d MMMM"
        
        return dateFormatter.stringFromDate(datesArray[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE d MMMM"
        
        currentDate.text = dateFormatter.stringFromDate(datesArray[row])
    }
    
    // MARK: - Actions
    
    @IBAction func doneAction(sender: UIBarButtonItem) {
        let date = datesArray[datePicker.selectedRowInComponent(0)]
        completionHandler(date)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
