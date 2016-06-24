//
//  AboutViewController.swift
//  Tutu_test
//
//  Created by Dima on 14/06/16.
//  Copyright © 2016 Dima. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var appVersion: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appVersion?.text = "ver. \(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
