//
//  profiveViewController.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/19/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import CoreLocation

class profiveViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = twitterUser.currentUser?.name as? String
        screennameLabel.text = "@\(twitterUser.currentUser!.screenname!)"
        bioLabel.text = twitterUser.currentUser?.tagline
        
        
        profileImageView.setImageWithURL((twitterUser.currentUser?.profileImageUrl)!)

        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            location = locationManager.location?.coordinate
            
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onChangeLocation(sender: AnyObject) {
        
        
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = manager.location?.coordinate
        
//        var state = ""
//        var district = ""
//        
//        congressAPI.sharedInstance.getLocalLegislators(location!, success: { (people: [congressPerson]) -> () in
//            
//            state = people[0].stateName!
//            
//            }) { (error: NSError) -> () in
//                print(error.localizedDescription)
//        }
        
        openStatesAPI.sharedInstance.getLegislatorsByLocation(location!, success: { (people: [congressPerson]) -> () in
            print("local: ")
            for person in people{
                print(person.name)
                print(person.stateName)
                print(person.district)
            }
            
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
        stateLabel.text = "Current State: XXXX"
        districtLabel.text = "Current District: XXXX"
        
        manager.stopUpdatingLocation()
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
