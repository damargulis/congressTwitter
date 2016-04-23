//
//  updateLocationViewController.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/23/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import CoreLocation

class updateLocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    var delegate:ModalViewControllerDelegate!
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapSubmit(sender: AnyObject) {
        
        
        var address = ""
        if let street = streetAddressTextField.text{
            address = address + street
        }
        if let city = cityTextField.text{
            address = address + " " + city
        }
        if let state = stateTextField.text{
            address = address + " " + state
        }
        if let zip = zipCodeTextField.text{
            address = address + " " + zip
        }
        
//        googleCivicDataAPI.sharedInstance.getRepsFromAddress(address) { (error: NSError) -> () in
//            print(error.localizedDescription)
//        }
        

        print(address)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let placemark = placemarks?[0]{
                print(placemark.location)
                self.location = placemark.location?.coordinate
                
                self.delegate.sendValue(self.location)
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
            if let error = error{
                print(error.localizedDescription)
            }
        }

    }
    @IBAction func onTapUseCurrentLocation(sender: AnyObject) {
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            location = locationManager.location?.coordinate
            
        }
        

        
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.location = locationManager.location?.coordinate
        
        locationManager.stopUpdatingLocation()
        
        delegate.sendValue(location)
        self.dismissViewControllerAnimated(true, completion: nil)
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
