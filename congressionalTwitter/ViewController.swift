//
//  ViewController.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 3/10/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var chamberControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    
    //Local Representative Taps
    @IBOutlet var tapGesture1: UITapGestureRecognizer!
    @IBOutlet var tapGesture2: UITapGestureRecognizer!
    @IBOutlet var tapGesture3: UITapGestureRecognizer!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allCongressman: [congressPerson]?
    var localCongressman: [congressPerson]?
    
    //Locaiton Controls
    var locationManager: CLLocationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    
    //Controls for inifinite scroll
    var isMoreDataLoading = false
    var page: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        page = 1
        
        chamberControl.selectedSegmentIndex = 2
        chamberControl.addTarget(self, action: #selector(ViewController.chamberDidChange(_:)), forControlEvents: .ValueChanged)

        
        
        //Request and get location
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            location = locationManager.location?.coordinate

        }
        
        //Twitter login/logout control
        if twitterUser.currentUser != nil {
            
            loginButton.tag = 1
            loginButton.title = "Logout"
            
        } else {
            
            loginButton.tag = 0
            loginButton.title = "Login"
        }
        
        //load congress data into table
        congressAPI.sharedInstance.getLegislators(page, searchText: nil, chamber: nil, success: { (people: [congressPerson]) -> () in
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
        
        //Control cell color by party
        if(congressman.partyCode == "D"){
            cell.backgroundColor = UIColor.blueColor()
            cell.nameLabel.textColor = UIColor.whiteColor()
            cell.partyLabel.textColor = UIColor.whiteColor()
            cell.stateLabel.textColor = UIColor.whiteColor()
            
        } else if(congressman.partyCode == "R"){
            cell.backgroundColor = UIColor.redColor()
            cell.nameLabel.textColor = UIColor.blackColor()
            cell.partyLabel.textColor = UIColor.blackColor()
            cell.stateLabel.textColor = UIColor.blackColor()
            
        } else if(congressman.partyCode == "I"){
            cell.backgroundColor = UIColor.grayColor()
            cell.nameLabel.textColor = UIColor.blackColor()
            cell.partyLabel.textColor = UIColor.blackColor()
            cell.stateLabel.textColor = UIColor.blackColor()
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
    
    //Twitter login/logout control
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
    
    
    //Inifite scroll controls
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
        var chamber: String?
        if(chamberControl.selectedSegmentIndex == 1){
            chamber = "senate"
        } else if(chamberControl.selectedSegmentIndex == 0){
            chamber = "house"
        }
        
        congressAPI.sharedInstance.getLegislators(page, searchText: self.searchBar.text, chamber: chamber, success: { (nextPage: [congressPerson]) -> () in
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
            //Sender is from table of congressmen
            
            let indexPath = tableView.indexPathForCell(cell)
            let congressman = allCongressman![indexPath!.row]
            detailViewController.congressman = congressman
        } else {

            
        }
        
        
    }

    
    //Search bar controls
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.page = 1
        var chamber: String?
        if(chamberControl.selectedSegmentIndex == 1){
            chamber = "senate"
        } else if(chamberControl.selectedSegmentIndex == 0){
            chamber = "house"
        }
        
        congressAPI.sharedInstance.getLegislators(page, searchText: searchBar.text, chamber: chamber, success: { (people: [congressPerson]) -> () in
            self.allCongressman = people
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    func chamberDidChange(sender: UISegmentedControl){
        var chamber: String?
        if(chamberControl.selectedSegmentIndex == 1){
            chamber = "senate"
        } else if(chamberControl.selectedSegmentIndex == 0){
            chamber = "house"
        }
        
        page = 1
        congressAPI.sharedInstance.getLegislators(page, searchText: self.searchBar.text, chamber: chamber, success: { (nextPage: [congressPerson]) -> () in
            self.allCongressman = nextPage
            
            self.tableView.reloadData()
            self.page = self.page + 1
            self.isMoreDataLoading = false
            
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
    }
    
    
    
    
}

