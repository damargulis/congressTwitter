//
//  ViewController.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 3/10/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    var allCongressman: [congressPerson]?
    var localCongressman: [congressPerson]?
    var locationManager: CLLocationManager = CLLocationManager()
    
    var location: CLLocationCoordinate2D?
    
    @IBOutlet weak var localName1Label: UILabel!
    @IBOutlet weak var localParty1Label: UILabel!
    @IBOutlet weak var localName2Label: UILabel!
    @IBOutlet weak var localParty2Label: UILabel!
    @IBOutlet weak var localName3Label: UILabel!
    @IBOutlet weak var localParty3Label: UILabel!
    
    @IBOutlet var tapGesture1: UITapGestureRecognizer!
    @IBOutlet var tapGesture2: UITapGestureRecognizer!
    @IBOutlet var tapGesture3: UITapGestureRecognizer!
    
    var isMoreDataLoading = false
    var page: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        page = 1
        
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            location = locationManager.location?.coordinate
            print("lat")
            print(location?.latitude)
            print("long")
            print(location?.longitude)
            
            
            congressAPI.sharedInstance.getLocalLegislators(location!, success: { (people: [congressPerson]) -> () in
                self.localCongressman = people
                print("LOCAL CONGRESSMAN")
                self.localName1Label.text = self.localCongressman![0].name
                self.localParty1Label.text = self.localCongressman![0].partyName
                self.localName2Label.text = self.localCongressman![1].name
                self.localParty2Label.text = self.localCongressman![1].partyName
                self.localName3Label.text = self.localCongressman![2].name
                self.localParty3Label.text = self.localCongressman![2].partyName
                
                for item in people{
                    print(item.name)
                }
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
            
        }
        
        if twitterUser.currentUser != nil {
            
            loginButton.tag = 1
            loginButton.title = "Logout"
            
        } else {
            loginButton.tag = 0
            loginButton.title = "Login"
        }
        
        //load congressdata into array
        congressAPI.sharedInstance.getLegislators(page, success: { (people: [congressPerson]) -> () in
            self.allCongressman = people
            self.tableView.reloadData()
            self.page = self.page + 1
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
            })
        
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("congressCell", forIndexPath: indexPath) as! congressTableViewCell
        let congressman = allCongressman![indexPath.row]
        cell.nameLabel.text = congressman.name
        cell.partyLabel.text = congressman.partyName
        cell.stateLabel.text = congressman.stateName
        
        if(congressman.partyCode == "D"){
            cell.backgroundColor = UIColor.blueColor()
        } else if(congressman.partyCode == "R"){
            cell.backgroundColor = UIColor.redColor()
        }
        
        return cell
        
        
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let allCongressman = allCongressman{
            return allCongressman.count
        } else {
            return 0
        }
    }
    
    
    @IBAction func onLogin(sender: AnyObject) {
        
        if (sender.tag == 0){
            let client = twitterAPI.sharedInstance
            
            client.login({ () -> () in
                
                self.loginButton.title = "Logout"
                self.loginButton.tag = 1
                
                }) { (error: NSError) -> () in
                    print(error.localizedDescription)
            }
            
            
            
        } else {
            
            twitterAPI.sharedInstance.logout()
            
            loginButton.title = "Login"
            loginButton.tag = 0
            
        }
        
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !isMoreDataLoading {
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
            
        }
    }
    
    func loadMoreData(){
        
        print("loading more data")
        
        congressAPI.sharedInstance.getLegislators(page, success: { (nextPage: [congressPerson]) -> () in
            for item in nextPage{
                self.allCongressman?.append(item)
            }
            
            self.tableView.reloadData()
            self.page = self.page + 1
            self.isMoreDataLoading = false
            
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let detailViewController = segue.destinationViewController as! congressmanDetailView
        
        if let cell = sender as? UITableViewCell{
            let indexPath = tableView.indexPathForCell(cell)
            let congressman = allCongressman![indexPath!.row]
            detailViewController.congressman = congressman
        } else {
            let x = sender as! UITapGestureRecognizer
            
            if(x.isEqual(tapGesture1)){
                
                detailViewController.congressman = localCongressman![0]
                
            } else if(x.isEqual(tapGesture2)){
                
                detailViewController.congressman = localCongressman![1]
                
            } else if(x.isEqual(tapGesture3)){
                
                detailViewController.congressman = localCongressman![2]
                
            }

            
        }
        
        
    }

    
    
}

