//
//  profiveViewController.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/19/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import CoreLocation

protocol ModalViewControllerDelegate
{
    func sendValue( loc : CLLocationCoordinate2D?)
}

class profiveViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, ModalViewControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nationalView1: UIView!
    @IBOutlet weak var nationalView2: UIView!
    @IBOutlet weak var nationalView3: UIView!
    @IBOutlet weak var nationalNameLabel1: UILabel!
    @IBOutlet weak var nationalNameLabel2: UILabel!
    @IBOutlet weak var nationalNameLabel3: UILabel!
    @IBOutlet weak var nationalTitleLabel1: UILabel!
    @IBOutlet weak var nationalTitleLabel2: UILabel!
    @IBOutlet weak var nationalTitleLabel3: UILabel!
    @IBOutlet weak var nationalLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    
    var national: [congressPerson]?
    var state: [congressPerson]?
    
    @IBOutlet weak var stateTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateTableView.delegate = self
        stateTableView.dataSource = self
        
        if let cur = twitterUser.currentUser{
            usernameLabel.text = cur.name as? String
            screennameLabel.text = "@\(cur.screenname!)"
            bioLabel.text = cur.tagline
            profileImageView.setImageWithURL((cur.profileImageUrl)!)
        }else{
            usernameLabel.text = "Please Log In"
        }

        
        

        let prefs = NSUserDefaults.standardUserDefaults()
        if let long = prefs.objectForKey("long") as? Double{
            let lat = prefs.doubleForKey("lat")
            let loc = CLLocationCoordinate2DMake(lat, long)
            self.location = loc
            populateData()
            
        } else{
            
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled(){
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                location = locationManager.location?.coordinate
                
            }
            
        }


        
        if twitterUser.currentUser != nil {
            loginButton.tag = 1
            loginButton.title = "Logout"
        } else {
            loginButton.tag = 0
            loginButton.title = "Login"
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = manager.location?.coordinate
        
        openStatesAPI.sharedInstance.getLegislatorsByLocation(location!, success: { (people: [congressPerson]) -> () in
            
            self.state = people
            self.stateTableView.reloadData()
            
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        congressAPI.sharedInstance.getLocalLegislators(location!, success: { (people: [congressPerson]) -> () in
            self.national = people
            self.nationalNameLabel1.text = "\(people[0].firstName!) \(people[0].lastName!)"
            self.nationalTitleLabel1.text = "\(people[0].stateName!) \(people[0].title!)"
            self.nationalNameLabel2.text = "\(people[1].firstName!) \(people[1].lastName!)"
            self.nationalTitleLabel2.text = "\(people[1].stateName!) \(people[1].title!)"
            self.nationalNameLabel3.text = "\(people[2].firstName!) \(people[2].lastName!)"
            self.nationalTitleLabel3.text = "\(people[2].stateName!) \(people[2].title!)"
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
        manager.stopUpdatingLocation()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("stateCell", forIndexPath: indexPath) as! profileStateTableViewCell
        let rep = state![indexPath.row]
        cell.nameLabel.text = rep.name
        cell.titleLabel.text = rep.title
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let statereps = state{
            return statereps.count
        }else{
            return 0
        }
    }
    
    
    // MARK: - Navigation

    func sendValue(loc: CLLocationCoordinate2D?) {
        self.location = loc
        
        openStatesAPI.sharedInstance.getLegislatorsByLocation(location!, success: { (people: [congressPerson]) -> () in
            
            self.state = people
            self.stateTableView.reloadData()
            
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        congressAPI.sharedInstance.getLocalLegislators(location!, success: { (people: [congressPerson]) -> () in
            self.national = people
            self.nationalNameLabel1.text = "\(people[0].firstName!) \(people[0].lastName!)"
            self.nationalTitleLabel1.text = "\(people[0].stateName!) \(people[0].title!)"
            self.nationalNameLabel2.text = "\(people[1].firstName!) \(people[1].lastName!)"
            self.nationalTitleLabel2.text = "\(people[1].stateName!) \(people[1].title!)"
            self.nationalNameLabel3.text = "\(people[2].firstName!) \(people[2].lastName!)"
            self.nationalTitleLabel3.text = "\(people[2].stateName!) \(people[2].title!)"
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
        
    }
    
    @IBAction func onTapLogin(sender: AnyObject) {
        
        if (sender.tag == 0){
            let client = twitterAPI.sharedInstance
            client.login({ () -> () in
                self.loginButton.title = "Logout"
                self.loginButton.tag = 1
                self.usernameLabel.text = twitterUser.currentUser!.name as? String
                self.screennameLabel.text = "@\(twitterUser.currentUser!.screenname!)"
                self.bioLabel.text = twitterUser.currentUser!.tagline
                self.profileImageView.setImageWithURL((twitterUser.currentUser!.profileImageUrl)!)

                }) { (error: NSError) -> () in
                    print(error.localizedDescription)
            }
        } else {
            twitterAPI.sharedInstance.logout()
            self.usernameLabel.text = "Please Log In"
            self.screennameLabel.text = "To Twitter"
            self.bioLabel.text = ""
            self.profileImageView.image = nil
            loginButton.title = "Login"
            loginButton.tag = 0
        }

        
    }
    
    
    func populateData(){
        
        openStatesAPI.sharedInstance.getLegislatorsByLocation(location!, success: { (people: [congressPerson]) -> () in
            
            self.state = people
            self.stateTableView.reloadData()
            
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        congressAPI.sharedInstance.getLocalLegislators(location!, success: { (people: [congressPerson]) -> () in
            self.national = people
            self.nationalNameLabel1.text = "\(people[0].firstName!) \(people[0].lastName!)"
            self.nationalTitleLabel1.text = "\(people[0].stateName!) \(people[0].title!)"
            self.nationalNameLabel2.text = "\(people[1].firstName!) \(people[1].lastName!)"
            self.nationalTitleLabel2.text = "\(people[1].stateName!) \(people[1].title!)"
            self.nationalNameLabel3.text = "\(people[2].firstName!) \(people[2].lastName!)"
            self.nationalTitleLabel3.text = "\(people[2].stateName!) \(people[2].title!)"
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let dvc = segue.destinationViewController as? congressmanDetailView{
            if let cell = sender as? profileStateTableViewCell{
                let ip = self.stateTableView.indexPathForCell(cell)
                dvc.congressman = state![ip!.row]
            } else{
                let gr = sender as! UITapGestureRecognizer
                if let v = gr.view{
                    if(v == nationalView1){
                        dvc.congressman = national![0]
                    }else if(v == nationalView2){
                        dvc.congressman = national![1]
                    }else if(v == nationalView3){
                        dvc.congressman = national![2]
                    }
                }
            }
        } else if let dvc = segue.destinationViewController as? updateLocationViewController{
            
            dvc.delegate = self
            
        }
    }

}
